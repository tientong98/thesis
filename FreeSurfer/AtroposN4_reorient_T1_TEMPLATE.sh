#!/bin/bash
#$ -pe smp 2
#$ -q PINC,CCOM,UI
#$ -o /Shared/tientong_scratch/abcd/code/derivative_logs/n4_t1
#$ -e /Shared/tientong_scratch/abcd/code/derivative_logs/n4_t1

ail_bids=/Shared/tientong_scratch/abcd/rawdata_AIL/SUBJECT/SESSION
outdir=/Shared/tientong_scratch/abcd/derivatives/atroposn4/SUBJECT/SESSION

[ ! -d $outdir ] && mkdir -p $outdir
[ ! -d $ail_bids ] && mkdir -p $ail_bids

source /Shared/pinc/sharedopt/apps/sourcefiles/ants_source.sh
source /Shared/pinc/sharedopt/apps/sourcefiles/afni_source.sh

rm $outdir/T1w_*

3dresample \
 -orient lpi \
 -prefix REORIENT \
 -input T1IMAGE

mv T1IMAGE $ail_bids
mv REORIENT T1IMAGE

3dAutomask -prefix $outdir/T1w_mask.nii.gz \
  T1IMAGE

antsAtroposN4.sh \
  -d 3 \
  -a T1IMAGE \
  -x $outdir/T1w_mask.nii.gz \
  -c 0 -o $outdir/T1w_
