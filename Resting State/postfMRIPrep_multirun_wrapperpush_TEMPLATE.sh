#!/bin/bash
#$ -pe smp 3
#$ -q PINC,UI,CCOM
#$ -o /Shared/tientong_scratch/abcd/code/derivative_logs/postfmriprep_push
#$ -e /Shared/tientong_scratch/abcd/code/derivative_logs/postfmriprep_push

# wrapper script running all the necessary steps after fMRIPrep

script_path=/Shared/tientong_scratch/abcd/code/postfmriprep/template

# extract ROI ts from the extended Power atlas, then calculate correlation

$script_path/postfMRIPrep_03-correlpush_multirun.sh \
 -s sub-SUBJECT \
 -v ses-baselineYear1Arm1 \
 -f /Shared/tientong_scratch/abcd/derivatives/fmriprep/fmriprep \
 -p /Shared/tientong_scratch/abcd/derivatives/post_fmriprep


