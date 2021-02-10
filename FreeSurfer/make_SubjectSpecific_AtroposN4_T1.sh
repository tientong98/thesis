#!/bin/bash

rawdata=/Shared/tientong_scratch/abcd/rawdata
t1scriptdir=/Shared/tientong_scratch/abcd/code/freesurfer/n4/t1scripts
template=/Shared/tientong_scratch/abcd/code/freesurfer/n4/template

T1=($(find ${rawdata}/*/*/anat -name \*T1w.nii.gz))

for i in ${!T1[@]} ; do
  SUBJECT=`cut -d "/" -f6 <<< ${T1[$i]}`
  SESSION=`cut -d "/" -f7 <<< ${T1[$i]}`  
  sed -e "s|SUBJECT|${SUBJECT}|g" -e "s|SESSION|${SESSION}|g" -e "s|T1IMAGE|${T1[$i]}|g" \
  ${template}/AtroposN4_T1_TEMPLATE.sh > ${t1scriptdir}/${SUBJECT}_${SESSION}_AtroposN4_T1w.sh
  qsub ${t1scriptdir}/${SUBJECT}_${SESSION}_AtroposN4_T1w.sh
done



############ RE-RUN FOR SUBJECTS WHO NEED REORIENT FROM AIL TO LPI #############

rawdata=/Shared/tientong_scratch/abcd/rawdata
t1scriptdir=/Shared/tientong_scratch/abcd/code/freesurfer/n4/t1scripts
template=/Shared/tientong_scratch/abcd/code/freesurfer/n4/template
n4outdir=/Shared/tientong_scratch/abcd/derivatives/atroposn4

T1_whole=($(find ${rawdata}/*/*/anat -name \*T1w.nii.gz))
for i in ${!T1_whole[@]} ; do
  SUBJECT=`cut -d "/" -f6 <<< ${T1_whole[$i]}`
  SESSION=`cut -d "/" -f7 <<< ${T1_whole[$i]}`
  if [ 0 -eq `ls ${n4outdir}/${SUBJECT}/${SESSION}/T1w_Segmentation.nii.gz 2>/dev/null | wc -c` ] ; then
     T1LPI=$(echo `cut -d "." -f1 <<< ${T1_whole[$i]}`_LPI.nii.gz)
     sed -e "s|SUBJECT|${SUBJECT}|g" -e "s|SESSION|${SESSION}|g" \
         -e "s|T1IMAGE|${T1_whole[$i]}|g" -e "s|REORIENT|${T1LPI}|g" \
         ${template}/AtroposN4_reorient_T1_TEMPLATE.sh > \
         ${t1scriptdir}/${SUBJECT}_${SESSION}_AtroposN4_reorient_T1w.sh
     qsub ${t1scriptdir}/${SUBJECT}_${SESSION}_AtroposN4_reorient_T1w.sh
  fi
done



