BASEPATH=/Shared/tientong_scratch/abcd/derivatives/baw/test_base_Results/abcd

# for i in $(cat review.list); do

for i in sub-NDARINV01TXCDJN/ses-baselineYear1Arm1 ; do

SUBJECTID=$(echo $i |awk -F/ '{print $1}')

SCANID=$(echo $i |awk -F/ '{print $2}')

echo "Inspecting $SUBJECTID/$SCANID"

/Shared/pinc/sharedopt/apps/itk-snap/Linux/x86_64/3.8.0-20190612/bin/itksnap -g ${BASEPATH}/${SUBJECTID}/${SCANID}/TissueClassify/t1_average_BRAINSABC.nii.gz -o ${BASEPATH}/${SUBJECTID}/${SCANID}/TissueClassify/t2_average_BRAINSABC.nii.gz -s ${BASEPATH}/${SUBJECTID}/${SCANID}/JointFusion/JointFusion_HDAtlas20_2015_dustCleaned_label.nii.gz

#/Shared/pinc/sharedopt/apps/itk-snap/Darwin/x86_64/3.6.0-20170401/ITK-SNAP.app/Contents/MacOS/ITK-SNAP -g ${BASEPATH}/${SUBJECTID}/${SCANID}/TissueClassify/t1_average_BRAINSABC.nii.gz -o ${BASEPATH}/${SUBJECTID}/${SCANID}/TissueClassify/t2_average_BRAINSABC.nii.gz ${BASEPATH}/${SUBJECTID}/${SCANID}/TissueClassify/pd_average_BRAINSABC.nii.gz -s ${BASEPATH}/${SUBJECTID}/${SCANID}/JointFusion/JointFusion_HDAtlas20_2015_dustCleaned_label.nii.gz

echo "Press [CTRL+C] to stop.."

               sleep 2

done
