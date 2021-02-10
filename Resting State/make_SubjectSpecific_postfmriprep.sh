#!/bin/bash

list=($(cat /Shared/tientong_scratch/abcd/derivatives/baw/randomhash_200725.txt))
bidsdir=/Shared/tientong_scratch/abcd/rawdata
template=/Shared/tientong_scratch/abcd/code/postfmriprep/template
subjectscript=/Shared/tientong_scratch/abcd/code/postfmriprep/subject_scripts

for i in ${!list[@]} ; do
 SUBJECT=(`echo ${list[$i]} | awk '{gsub("/"," "); print $5}'| awk '{gsub("-"," "); print $2}'`)
 SESSION=baselineYear1Arm1
 if [ -d ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/func ] &&
    [ 0 -lt `ls ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/anat/*T1w*.nii.gz 2>/dev/null | wc -l` ] ; then
  if [ 1 -eq `ls ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/func/*rest*.nii.gz 2>/dev/null | wc -l` ] ; then
    sed -e "s|SUBJECT|${SUBJECT}|g" ${template}/postfMRIPrep_singlerun_wrapper_TEMPLATE.sh \
    > ${subjectscript}/sub-${SUBJECT}_ses-${SESSION}_postfMRIPrep_singlerun.sh
    qsub ${subjectscript}/sub-${SUBJECT}_ses-${SESSION}_postfMRIPrep_singlerun.sh
  else
    sed -e "s|SUBJECT|${SUBJECT}|g" ${template}/postfMRIPrep_multirun_wrapper_TEMPLATE.sh \
    > ${subjectscript}/sub-${SUBJECT}_ses-${SESSION}_postfMRIPrep_multirun.sh
    qsub ${subjectscript}/sub-${SUBJECT}_ses-${SESSION}_postfMRIPrep_multirun.sh        
  fi
 fi
done


################################################################################ 

SUBJECT=(NDARINVA3G711KJ)
 SESSION=baselineYear1Arm1
 rm /Shared/tientong_scratch/abcd/code/derivative_logs/postfmriprep/*${SUBJECT}*
 if [ -d ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/func ] &&
    [ 0 -lt `ls ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/anat/*T1w*.nii.gz 2>/dev/null | wc -l` ] ; then
  if [ 1 -eq `ls ${bidsdir}/sub-${SUBJECT}/ses-${SESSION}/func/*rest*.nii.gz 2>/dev/null | wc -l` ] ; then
    sed -e "s|SUBJECT|${SUBJECT}|g" ${template}/postfMRIPrep_singlerun_wrapper_TEMPLATE.sh \
    > ${subjectscript}/sub-${SUBJECT}_ses-${SESSION}_postfMRIPrep_singlerun.sh
    #qsub ${subjectscript}/sub-${SUBJECT}_ses-${SESSION}_postfMRIPrep_singlerun.sh
  else
    sed -e "s|SUBJECT|${SUBJECT}|g" ${template}/postfMRIPrep_multirun_wrapper_TEMPLATE.sh \
    > ${subjectscript}/sub-${SUBJECT}_ses-${SESSION}_postfMRIPrep_multirun.sh
    #qsub ${subjectscript}/sub-${SUBJECT}_ses-${SESSION}_postfMRIPrep_multirun.sh        
  fi
fi
