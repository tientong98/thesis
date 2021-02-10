#!/bin/bash
#$ -pe smp 4
#$ -q PINC,CCOM,UI
#$ -o /Shared/tientong_scratch/abcd/code/derivative_logs/freesurfer
#$ -e /Shared/tientong_scratch/abcd/code/derivative_logs/freesurfer

source /Shared/pinc/sharedopt/apps/sourcefiles/freesurfer_source.sh
export SUBJECTS_DIR=/Shared/tientong_scratch/abcd/derivatives/freesurfer

recon-all \
 -subject SUBID_SESSION \
 -i T1BIASCORRECTED \
 -cw256 -all

