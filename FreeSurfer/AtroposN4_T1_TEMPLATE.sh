#!/bin/bash
#$ -pe smp 2
#$ -q PINC,CCOM,UI
#$ -o /Shared/tientong_scratch/abcd/code/derivative_logs/n4_t1
#$ -e /Shared/tientong_scratch/abcd/code/derivative_logs/n4_t1

outdir=/Shared/tientong_scratch/abcd/derivatives/atroposn4/SUBJECT/SESSION

[ ! -d $outdir ] && mkdir -p $outdir

source /Shared/pinc/sharedopt/apps/sourcefiles/ants_source.sh
source /Shared/pinc/sharedopt/apps/sourcefiles/afni_source.sh

3dAutomask -prefix $outdir/T1w_mask.nii.gz T1IMAGE

antsAtroposN4.sh \
  -d 3 \
  -a T1IMAGE \
  -x $outdir/T1w_mask.nii.gz \
  -c 0 -o $outdir/T1w_
