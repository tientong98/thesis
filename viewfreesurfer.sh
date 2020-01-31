#export FREESURFER_HOME=/Shared/pinc/sharedopt/apps/freesurfer/Darwin/x86_64/6.0.0
export FREESURFER_HOME=/Shared/pinc/sharedopt/apps/freesurfer/Linux/x86_64/6.0.0
export SUBJECTS_DIR=/Shared/jvaidya/functional/JV_Kids/BIDS/derivatives/freesurfer/N4_T1nT2
#source /Shared/pinc/sharedopt/apps/freesurfer/Darwin/x86_64/6.0.0/SetUpFreeSurfer.sh
source /Shared/pinc/sharedopt/apps/freesurfer/Linux/x86_64/6.0.0/SetUpFreeSurfer.sh

for i in $(cat ${SUBJECTS_DIR}/list.txt); do
freeview -v \
${SUBJECTS_DIR}/$i/mri/orig.mgz \
${SUBJECTS_DIR}/$i/mri/T1.mgz \
${SUBJECTS_DIR}/$i/mri/wm.mgz \
${SUBJECTS_DIR}/$i/mri/brainmask.mgz \
${SUBJECTS_DIR}/$i/mri/aseg.mgz:colormap=lut:opacity=0.2 \
-f ${SUBJECTS_DIR}/$i/surf/lh.white:edgecolor=blue \
${SUBJECTS_DIR}/$i/surf/lh.pial:edgecolor=red \
${SUBJECTS_DIR}/$i/surf/rh.white:edgecolor=blue \
${SUBJECTS_DIR}/$i/surf/rh.pial:edgecolor=red \
${SUBJECTS_DIR}/$i/surf/lh.pial:annot=aparc.annot:name=pial_aparc:visible=0 \
${SUBJECTS_DIR}/$i/surf/rh.pial:annot=aparc.annot:name=pial_aparc:visible=0
echo "Press [CTRL+C] to stop.."
	sleep 2
done
