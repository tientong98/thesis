#!/bin/bash
path=`/Shared/oleary/functional/UICL/freesurfer/OLEARY_FS_v53_2014/OLEARY_FS_v53_2014_3045_64066514/stats`
sleep 1
cd $path
echo "This bash script will create table from ?.stats files"
echo "Written by Jamaan Alghamdi & Dr. Vanessa Sluming"
echo "University of Liverpool"
echo "jamaan.alghamdi@gmail.com"
echo "http://www.easyneuroimaging.com"
echo "20/12/2010
"
free="module load freesurfer/v6"
sleep 1
source $FREESURFER_HOME/Shared/pinc/sharedopt/apps/freesurfer/Linux/x86_64/5.3.0
sleep 1

export SUBJECTS_DIR=/Shared/oleary/functional/UICL/freesurfer/OLEARY_FS_v53_2014/OLEARY_FS_v53_2014_3045_64066514/stats

cd $SUBJECTS_DIR
list="`ls -d */`"
asegstats2table --subjects $list --meas volume --skip --tablefile aseg_stats.txt
aparcstats2table --subjects $list --hemi lh --meas thickness --skip --tablefile aparc_thickness_lh.txt
aparcstats2table --subjects $list --hemi lh --meas area --skip --tablefile aparc_area_lh.txt
aparcstats2table --subjects $list --hemi rh --meas thickness --skip --tablefile aparc_thickness_rh.txt
aparcstats2table --subjects $list --hemi rh --meas area --skip --tablefile aparc_area_rh.txt
