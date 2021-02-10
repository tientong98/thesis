#!/bin/bash

function Usage {
    cat <<USAGE
`basename $0` regress, bandpass, smooth, normalize and scale
Usage:
`basename $0`  -s subject_id \
               -v session_id \
               -f fmriprep_path \
               -o path \
               -h <help>
Example:
  bash $0  \
 -s sub-NDARINVT345WWLE \
 -v ses-baselineYear1Arm1 \
 -f /Shared/tientong_scratch/abcd/derivatives/fmriprep/fmriprep \
 -o /Shared/tientong_scratch/abcd/derivatives/post_fmriprep
Arguments:
  -s subject_id     The subject id
  -v session_id     The session id
  -f fmriprep_path  The path to outputs from fMRIPrep
  -o path  	    The path of the post-fMRIPrep derivatives
  -h help
USAGE
    exit 1
}

# Parse input operators -------------------------------------------------------
while getopts "s:v:f:o:h" option ; do
  case "${option}" in
	  s) # subject_id
	    sub=${OPTARG}
	    ;;
	  v) # session_id
	    ses=${OPTARG}
	    ;;
	  f) # fMRIPrep_path
	    fmriprepdir=${OPTARG}
	    ;;
	  o) # output_path
	    outdir=${OPTARG}
	    ;;
	  h) # help
	    Usage >&2
	    exit 0
	    ;;
	  *) # unknown options
	    echo "ERROR: Unrecognized option -${option} $OPTARG"
	    exit 1
	    ;;
  esac
done

source /Shared/pinc/sharedopt/apps/sourcefiles/fsl_source.sh --fslver 5.0.8_multicore
source /Shared/pinc/sharedopt/apps/sourcefiles/afni_source.sh


#sub=sub-NDARINVT345WWLE
#ses=ses-baselineYear1Arm1
#outdir=/Shared/tientong_scratch/abcd/derivatives/post_fmriprep
fmriprepdir=/Shared/tientong_scratch/abcd/derivatives/fmriprep/fmriprep

# script was modified from https://github.com/mwvoss/RestingState/blob/master/removeNuisanceRegressor.sh#L147

mkdir -p $outdir/${sub}/${ses}
sub_fmriprepdir=$fmriprepdir/${sub}/${ses}/func

# already do highpass with cosine regressors
# only do lowpass with -bandpass
# fbot can be 0 if you want to do a lowpass filter only. HOWEVER, the mean and Nyquist freq are always removed.

input4d=$sub_fmriprepdir/${sub}_${ses}_task-rest_space-MNI152NLin6Asym_res-2_desc-preproc_bold.nii.gz
mask=$sub_fmriprepdir/${sub}_${ses}_task-rest_space-MNI152NLin6Asym_res-2_desc-brain_mask.nii.gz
confound=$sub_fmriprepdir/${sub}_${ses}_task-rest_desc-confounds_regressors_final.txt

3dTproject \
 -input $input4d \
 -prefix $outdir/${sub}/${ses}/temp_reg_bp_smooth.nii.gz \
 -mask $mask \
 -bandpass 0 0.08 \
 -blur 4 \
 -ort $confound \
 -verb &&\

# add mean back in more details in the links below
# https://github.com/HBClab/RestingState/issues/111
# https://afni.nimh.nih.gov/afni/community/board/read.php?1,84353,84356

echo `date`": Start regression and temporal filter for ${sub}"
3dTstat \
 -mean \
 -prefix $outdir/${sub}/${ses}/orig_mean.nii.gz \
 $input4d &&\

3dcalc \
 -a $outdir/${sub}/${ses}/temp_reg_bp_smooth.nii.gz \
 -b $outdir/${sub}/${ses}/orig_mean.nii.gz \
 -expr "a+b" \
 -prefix ${outdir}/${sub}/${ses}/final_reg_bp_smooth.nii.gz

###### Post-regression spatial smoothing ###################################
#echo `date`": Start smoothing for ${sub}"
#3dBlurToFWHM \
# -FWHM 4 \
# -mask $mask \
# -prefix ${outdir}/${sub}/${ses}/final_reg_bp_smooth.nii.gz \
# -input ${outdir}/${sub}/${ses}/final_reg_bp.nii.gz

###### Post-regression normalization and scaling ###########################
fslmaths \
 $mask \
 -mul 1000 \
 ${outdir}/${sub}/${ses}/mask1000.nii.gz \
 -odt float

# normalize
echo `date`": Start normalizing and scaling for ${sub}"
input_to_norm=${outdir}/${sub}/${ses}/final_reg_bp_smooth.nii.gz

fslmaths \
 $input_to_norm \
 -Tmean \
 ${outdir}/${sub}/${ses}/res4d_tmean

fslmaths \
 $input_to_norm \
 -Tstd \
 ${outdir}/${sub}/${ses}/res4d_std

fslmaths \
 $input_to_norm \
 -sub \
 ${outdir}/${sub}/${ses}/res4d_tmean \
 ${outdir}/${sub}/${ses}/res4d_dmean

fslmaths \
 ${outdir}/${sub}/${ses}/res4d_dmean \
 -div ${outdir}/${sub}/${ses}/res4d_std \
 ${outdir}/${sub}/${ses}/res4d_normed

fslmaths \
 ${outdir}/${sub}/${ses}/res4d_normed \
 -add ${outdir}/${sub}/${ses}/mask1000.nii.gz \
 ${outdir}/${sub}/${ses}/res4d_normscaled \
 -odt float

echo `date`": Start removing temp files for ${sub}"
rm ${outdir}/${sub}/${ses}/temp_reg_bp_smooth.nii.gz
rm ${outdir}/${sub}/${ses}/orig_mean.nii.gz
rm ${outdir}/${sub}/${ses}/final_reg_bp_smooth.nii.gz
rm ${outdir}/${sub}/${ses}/mask1000.nii.gz
rm ${outdir}/${sub}/${ses}/res4d_tmean.nii.gz
rm ${outdir}/${sub}/${ses}/res4d_std.nii.gz
rm ${outdir}/${sub}/${ses}/res4d_dmean.nii.gz
rm ${outdir}/${sub}/${ses}/res4d_normed.nii.gz
