#!/bin/bash

##### move random hash (created for BRAINSTools) back to ses-baselineYear1Arm1

list=($(cat /Shared/tientong_scratch/abcd/derivatives/baw/randomhash_200725.txt))
bidsdir=/Shared/tientong_scratch/abcd/rawdata

for i in ${!list[@]} ; do
 sub=(`echo ${list[$i]} | awk '{gsub("/"," "); print $5}'| awk '{gsub("-"," "); print $2}'`)
 ses=(`echo ${list[$i]} | awk '{gsub("/"," "); print $6}'| awk '{gsub("-"," "); print $2}'`)
 mv ${bidsdir}/sub-${sub}/ses-${ses} ${bidsdir}/sub-${sub}/ses-baselineYear1Arm1
done

##### create subject-specific fmriprep jobs
# 6 subs with func+anat but didn't have fmap
# 832 subs with func+anat AND fmap
# total 838 (out of 917)

list=($(cat /Shared/tientong_scratch/abcd/derivatives/baw/randomhash_200725.txt))
bidsdir=/Shared/tientong_scratch/abcd/rawdata
template=/Shared/tientong_scratch/abcd/code/fmriprep/template
script=/Shared/tientong_scratch/abcd/code/fmriprep/subject_scripts

for i in ${!list[@]} ; do
 SUBJECT=(`echo ${list[$i]} | awk '{gsub("/"," "); print $5}'| awk '{gsub("-"," "); print $2}'`)
 SESSION=baselineYear1Arm1
 if [ -d ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/func ] &&
    [ 0 -lt `ls ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/anat/*T1w*.nii.gz 2>/dev/null | wc -l` ] ; then
  STR=$'"IntendedFor"\: \[$'
  if [ -d ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/fmap ] &&
     [ 0 -lt `grep -rnw ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/fmap -e "$STR" 2>/dev/null | wc -l` ] ; then
    sed -e "s|SUBJECT|${SUBJECT}|g" ${template}/fmriprep_nostc_TEMPLATE.sh \
    > ${script}/sub-${SUBJECT}_ses-${SESSION}_fmriprep_nostc.sh
    #qsub ${script}/sub-${SUBJECT}_ses-${SESSION}_fmriprep_nostc.sh
  else
    sed -e "s|SUBJECT|${SUBJECT}|g" ${template}/fmriprep_nostc_syn_TEMPLATE.sh \
    > ${script}/sub-${SUBJECT}_ses-${SESSION}_fmriprep_nostc_syn.sh
    #qsub ${script}/sub-${SUBJECT}_ses-${SESSION}_fmriprep_nostc_syn.sh        
  fi
 fi
done

##### 838 jobs - submitting 100 at once

jobs=($(ls /Shared/tientong_scratch/abcd/code/fmriprep/subject_scripts/*))

for i in $(seq 0 1 200) ; do
  qsub ${jobs[$i]}
done


for i in $(seq 701 1 837) ; do
  qsub ${jobs[$i]}
done


