#!/bin/bash

function Usage {
    cat <<USAGE
`basename $0` extract ROI ts from the extended Power atlas, then calculate correlation
Usage:
`basename $0`  -s subject_id \
               -v session_id \
               -f fmriprep_path \
               -p path \
               -h <help>
Example:
  bash $0  \
 -s sub-NDARINVT345WWLE \
 -v ses-baselineYear1Arm1 \
 -f /Shared/tientong_scratch/abcd/derivatives/fmriprep/fmriprep \
 -p /Shared/tientong_scratch/abcd/derivatives/post_fmriprep
Arguments:
  -s subject_id     The subject id
  -v session_id     The session id
  -f fmriprep_path  The path to outputs from fMRIPrep
  -p path  	    The path of the post-fMRIPrep derivatives
  -h help
USAGE
    exit 1
}

# Parse input operators -------------------------------------------------------
while getopts "s:v:f:p:h" option ; do
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
	  p) # path
	    path=${OPTARG}
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

source /Shared/pinc/sharedopt/apps/sourcefiles/afni_source.sh

# get time series from ROIs
# cite Taylor PA, Saad ZS (2013).  FATCAT: (An Efficient) Functional And Tractographic Connectivity Analysis Toolbox. Brain Connectivity 3(5):523-535.

echo `date`": Start calculating fcon for ${sub} run $(expr $run + 1)"

sub_fmriprepdir=$fmriprepdir/${sub}/${ses}/func

mask=$sub_fmriprepdir/${sub}_${ses}_task-rest_space-MNI152NLin6Asym_res-2_desc-brain_mask.nii.gz

3dNetCorr \
 -inset $path/${sub}/${ses}/res4d_normscaled.nii.gz \
 -in_rois /Shared/oleary/atlas/greeneatlas/greene300LPI.nii.gz \
 -mask $mask \
 -fish_z \
 -prefix $path/${sub}/${ses}/${sub}_${ses}_extendedPowerpush \
 -push_thru_many_zeros         

