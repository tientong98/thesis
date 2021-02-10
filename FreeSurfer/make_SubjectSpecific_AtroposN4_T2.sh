#!/bin/bash

rawdata=/Shared/tientong_scratch/abcd/rawdata
t2scriptdir=/Shared/tientong_scratch/abcd/code/freesurfer/n4/t2scripts
template=/Shared/tientong_scratch/abcd/code/freesurfer/n4/template

T2=($(find ${rawdata}/*/*/anat -name \*T2w.nii.gz))

for i in ${!T2[@]} ; do
  SUBJECT=`cut -d "/" -f6 <<< ${T2[$i]}`
  SESSION=`cut -d "/" -f7 <<< ${T2[$i]}`  
  sed -e "s|SUBJECT|${SUBJECT}|g" -e "s|SESSION|${SESSION}|g" -e "s|T2IMAGE|${T2[$i]}|g" \
  ${template}/AtroposN4_T2_TEMPLATE.sh > ${t2scriptdir}/${SUBJECT}_${SESSION}_AtroposN4_T2w.sh
  qsub ${t2scriptdir}/${SUBJECT}_${SESSION}_AtroposN4_T2w.sh
done

############ RE-RUN FOR SUBJECTS WHO NEED REORIENT FROM AIL TO LPI #############

rawdata=/Shared/tientong_scratch/abcd/rawdata
t2scriptdir=/Shared/tientong_scratch/abcd/code/freesurfer/n4/t2scripts
template=/Shared/tientong_scratch/abcd/code/freesurfer/n4/template
n4outdir=/Shared/tientong_scratch/abcd/derivatives/atroposn4

T2_whole=($(find ${rawdata}/*/*/anat -name \*T2w.nii.gz))
for i in ${!T2_whole[@]} ; do
  SUBJECT=`cut -d "/" -f6 <<< ${T2_whole[$i]}`
  SESSION=`cut -d "/" -f7 <<< ${T2_whole[$i]}`
  if [ 0 -eq `ls ${n4outdir}/${SUBJECT}/${SESSION}/T2w_Segmentation.nii.gz 2>/dev/null | wc -c` ] ; then
     T2LPI=$(echo `cut -d "." -f1 <<< ${T2_whole[$i]}`_LPI.nii.gz)
     sed -e "s|SUBJECT|${SUBJECT}|g" -e "s|SESSION|${SESSION}|g" \
         -e "s|T2IMAGE|${T2_whole[$i]}|g" -e "s|REORIENT|${T2LPI}|g" \
         ${template}/AtroposN4_reorient_T2_TEMPLATE.sh > \
         ${t2scriptdir}/${SUBJECT}_${SESSION}_AtroposN4_reorient_T2w.sh
     qsub ${t2scriptdir}/${SUBJECT}_${SESSION}_AtroposN4_reorient_T2w.sh
  fi
done
