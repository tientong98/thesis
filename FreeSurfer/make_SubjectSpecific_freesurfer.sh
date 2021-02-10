#!/bin/bash

n4dir=/Shared/tientong_scratch/abcd/derivatives/atroposn4
template=/Shared/tientong_scratch/abcd/code/freesurfer/freesurfer_run/template
t1_t2scripts=/Shared/tientong_scratch/abcd/code/freesurfer/freesurfer_run/t1_t2scripts
t1scripts=/Shared/tientong_scratch/abcd/code/freesurfer/freesurfer_run/t1scripts

T1bc=($(find ${n4dir}/*/*/ -name T1w_Segmentation0N4.nii.gz))

for i in ${!T1bc[@]} ; do
 SUBJECT=`cut -d "/" -f7 <<< ${T1bc[$i]}`
 SESSION=`cut -d "/" -f8 <<< ${T1bc[$i]}`
 if [ 0 -lt `ls ${n4dir}/${SUBJECT}/${SESSION}/T2w_Segmentation0N4.nii.gz 2>/dev/null | wc -l` ] ; then
   T2bc=${n4dir}/${SUBJECT}/${SESSION}/T2w_Segmentation0N4.nii.gz
   sed -e "s|SUBID|${SUBJECT}|g" -e "s|SESSION|${SESSION}|g" \
       -e "s|T1BIASCORRECTED|${T1bc[$i]}|g" -e "s|T2BIASCORRECTED|${T2bc}|g" \
       ${template}/freesurfer_T1T2_TEMPLATE.sh > \
       ${t1_t2scripts}/${SUBJECT}_${SESSION}_T1T2_freesurfer.sh
   qsub ${t1_t2scripts}/${SUBJECT}_${SESSION}_T1T2_freesurfer.sh
 else
   sed -e "s|SUBID|${SUBJECT}|g" -e "s|SESSION|${SESSION}|g" \
       -e "s|T1BIASCORRECTED|${T1bc[$i]}|g" \
       ${template}/freesurfer_T1_TEMPLATE.sh > \
       ${t1scripts}/${SUBJECT}_${SESSION}_T1_freesurfer.sh
   qsub ${t1scripts}/${SUBJECT}_${SESSION}_T1_freesurfer.sh
 fi
done




