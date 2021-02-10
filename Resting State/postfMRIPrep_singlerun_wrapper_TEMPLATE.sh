#!/bin/bash
#$ -pe smp 3
#$ -q PINC,UI,CCOM
#$ -o /Shared/tientong_scratch/abcd/code/derivative_logs/postfmriprep
#$ -e /Shared/tientong_scratch/abcd/code/derivative_logs/postfmriprep

# wrapper script running all the necessary steps after fMRIPrep

script_path=/Shared/tientong_scratch/abcd/code/postfmriprep/template

# first get confound regressors: 
#    - non-steady state volumes
#    - 5 CSF and 5 WF components
#    - cosine ts
#    - 6 MPs + their derivatives (12HMP)	
cd /Shared/tientong_scratch/abcd/code/postfmriprep/template
module load R/3.5.1
$script_path/postfMRIPrep_01-acompcor-pipeline.R \
 --path_fmriprep /Shared/tientong_scratch/abcd/derivatives/fmriprep/fmriprep/ \
 --subject sub-SUBJECT \
 --visit ses-baselineYear1Arm1

# then, run regression, lowpass filter, smooth, normalize, and scale

$script_path/postfMRIPrep_02-bpreg_singlerun.sh \
 -s sub-SUBJECT \
 -v ses-baselineYear1Arm1 \
 -f /Shared/tientong_scratch/abcd/derivatives/fmriprep/fmriprep \
 -o /Shared/tientong_scratch/abcd/derivatives/post_fmriprep

# extract ROI ts from the extended Power atlas, then calculate correlation

$script_path/postfMRIPrep_03-correl_singlerun.sh \
 -s sub-SUBJECT \
 -v ses-baselineYear1Arm1 \
 -f /Shared/tientong_scratch/abcd/derivatives/fmriprep/fmriprep \
 -p /Shared/tientong_scratch/abcd/derivatives/post_fmriprep


