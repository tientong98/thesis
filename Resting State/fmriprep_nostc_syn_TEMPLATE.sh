#!/bin/sh
#$ -pe smp 10
#$ -q PINC,UI,CCOM
#$ -o /Shared/tientong_scratch/abcd/code/derivative_logs/fmriprep
#$ -e /Shared/tientong_scratch/abcd/code/derivative_logs/fmriprep
OMP_NUM_THREADS=8
singularity run -H /Users/tientong/singularity_home \
  /Users/tientong/fmriprep_20.1.3.simg \
  /Shared/tientong_scratch/abcd/rawdata \
  /Shared/tientong_scratch/abcd/derivatives/fmriprep \
  participant --participant-label SUBJECT \
  --fs-license-file /Shared/oleary/functional/FreeSurferLicense/license.txt \
  -w /Shared/tientong_scratch/abcd/derivatives/fmriprep --write-graph \
  --output-spaces T1w MNI152NLin6Asym:res-2 --stop-on-first-crash \
  --omp-nthreads 8 --nthreads 8 --mem 20 --notrack --fs-no-reconall \
  --skip_bids_validation --ignore slicetiming fieldmaps --use-syn-sdc
