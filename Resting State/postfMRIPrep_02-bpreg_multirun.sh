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
files=($(ls $sub_fmriprepdir/*_space-MNI152NLin6Asym_res-2_desc-preproc_bold.nii.gz))

for run in ${!files[@]} ; do

input4d=$sub_fmriprepdir/${sub}_${ses}_task-rest_run-$(expr $run + 1)_space-MNI152NLin6Asym_res-2_desc-preproc_bold.nii.gz
mask=$sub_fmriprepdir/${sub}_${ses}_task-rest_run-$(expr $run + 1)_space-MNI152NLin6Asym_res-2_desc-brain_mask.nii.gz
confound=$sub_fmriprepdir/${sub}_${ses}_task-rest_run-$(expr $run + 1)_desc-confounds_regressors_final.txt

3dTproject \
 -input $input4d \
 -prefix $outdir/${sub}/${ses}/temp_reg_bp_smooth_run-$(expr $run + 1).nii.gz \
 -mask $mask \
 -bandpass 0 0.08 \
 -blur 4 \
 -ort $confound \
 -verb &&\

# add mean back in more details in the links below
# https://github.com/HBClab/RestingState/issues/111
# https://afni.nimh.nih.gov/afni/community/board/read.php?1,84353,84356

echo `date`": Start regression and temporal filter for ${sub} run $(expr $run + 1)"
3dTstat \
 -mean \
 -prefix $outdir/${sub}/${ses}/orig_mean_run-$(expr $run + 1).nii.gz \
 $input4d &&\

3dcalc \
 -a $outdir/${sub}/${ses}/temp_reg_bp_smooth_run-$(expr $run + 1).nii.gz \
 -b $outdir/${sub}/${ses}/orig_mean_run-$(expr $run + 1).nii.gz \
 -expr "a+b" \
 -prefix ${outdir}/${sub}/${ses}/final_reg_bp_smooth_run-$(expr $run + 1).nii.gz

###### Post-regression spatial smoothing ###################################
#echo `date`": Start smoothing for ${sub} run $(expr $run + 1)"
#3dBlurToFWHM \
# -FWHM 4 \
# -mask $mask \
# -prefix ${outdir}/${sub}/${ses}/final_reg_bp_smooth_run-$(expr $run + 1).nii.gz \
# -input ${outdir}/${sub}/${ses}/final_reg_bp_run-$(expr $run + 1).nii.gz

###### Post-regression normalization and scaling ###########################
fslmaths \
 $mask \
 -mul 1000 \
 ${outdir}/${sub}/${ses}/mask1000_run-$(expr $run + 1).nii.gz \
 -odt float

# normalize
echo `date`": Start normalizing and scaling for ${sub} run $(expr $run + 1)"
input_to_norm=${outdir}/${sub}/${ses}/final_reg_bp_smooth_run-$(expr $run + 1).nii.gz

fslmaths \
 $input_to_norm \
 -Tmean \
 ${outdir}/${sub}/${ses}/res4d_tmean_run-$(expr $run + 1)

fslmaths \
 $input_to_norm \
 -Tstd \
 ${outdir}/${sub}/${ses}/res4d_std_run-$(expr $run + 1)

fslmaths \
 $input_to_norm \
 -sub \
 ${outdir}/${sub}/${ses}/res4d_tmean_run-$(expr $run + 1) \
 ${outdir}/${sub}/${ses}/res4d_dmean_run-$(expr $run + 1)

fslmaths \
 ${outdir}/${sub}/${ses}/res4d_dmean_run-$(expr $run + 1) \
 -div ${outdir}/${sub}/${ses}/res4d_std_run-$(expr $run + 1) \
 ${outdir}/${sub}/${ses}/res4d_normed_run-$(expr $run + 1)

fslmaths \
 ${outdir}/${sub}/${ses}/res4d_normed_run-$(expr $run + 1) \
 -add ${outdir}/${sub}/${ses}/mask1000_run-$(expr $run + 1).nii.gz \
 ${outdir}/${sub}/${ses}/res4d_normscaled_run-$(expr $run + 1) \
 -odt float

echo `date`": Start removing temp files for ${sub} run $(expr $run + 1)"
rm ${outdir}/${sub}/${ses}/temp_reg_bp_smooth_run-$(expr $run + 1).nii.gz
rm ${outdir}/${sub}/${ses}/orig_mean_run-$(expr $run + 1).nii.gz
rm ${outdir}/${sub}/${ses}/final_reg_bp_smooth_run-$(expr $run + 1).nii.gz
rm ${outdir}/${sub}/${ses}/mask1000_run-$(expr $run + 1).nii.gz
rm ${outdir}/${sub}/${ses}/res4d_tmean_run-$(expr $run + 1).nii.gz
rm ${outdir}/${sub}/${ses}/res4d_std_run-$(expr $run + 1).nii.gz
rm ${outdir}/${sub}/${ses}/res4d_dmean_run-$(expr $run + 1).nii.gz
rm ${outdir}/${sub}/${ses}/res4d_normed_run-$(expr $run + 1).nii.gz

done

