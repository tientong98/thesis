#!/bin/bash
#$ -pe smp 12
#$ -q PINC
#$ -m e
#$ -M tien-tong@uiowa.edu
#$ -o /Users/tientong/logs/abcd/freesurfer/out
#$ -e /Users/tientong/logs/abcd/freesurfer/err

if [ -f "/Shared/tientong_scratch/log/sub-NDARINV01TXCDJN_ses-baselineYear1Arm1.log" ] ; then
   echo "subject log already exists"
  else
   cd /Shared/tientong_scratch/log
   touch sub-NDARINV01TXCDJN_ses-baselineYear1Arm1.log
  fi

subject_log=/Shared/tientong_scratch/log/sub-NDARINV01TXCDJN_ses-baselineYear1Arm1.log

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task: FSwbcv6T1T2' >> ${subject_log}
echo 't1: /Shared/tientong_scratch//derivatives/anat/prep/sub-NDARINV01TXCDJN/ses-baselineYear1Arm1/sub-NDARINV01TXCDJN_ses-baselineYear1Arm1_T1w_prep-biasFieldN4.nii.gz >> ${subject_log}
echo 't2: /Shared/tientong_scratch//derivatives/anat/prep/sub-NDARINV01TXCDJN/ses-baselineYear1Arm1/sub-NDARINV01TXCDJN_ses-baselineYear1Arm1_T2w_prep-biasFieldN4.nii.gz >> ${subject_log}
echo 'software: FreeSurfer' >> ${subject_log}
echo 'version: 6.0' >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

if [ -d "/Shared/tientong_scratch/derivatives/fsurf" ] ; then
   echo "fsurf directory already exists"   
  else
   mkdir -p /Shared/tientong_scratch/derivatives/fsurf
  fi

export FREESURFER_HOME=/Shared/pinc/sharedopt/apps/freesurfer/Linux/x86_64/6.0.0
export SUBJECTS_DIR=/Shared/tientong_scratch/derivatives/fsurf
source ${FREESURFER_HOME}/FreeSurferEnv.sh
recon-all -subject sub-NDARINV01TXCDJN_ses-baselineYear1Arm1 -i /Shared/tientong_scratch//derivatives/anat/prep/sub-NDARINV01TXCDJN/ses-baselineYear1Arm1/sub-NDARINV01TXCDJN_ses-baselineYear1Arm1_T1w_prep-biasFieldN4.nii.gz -T2 /Shared/tientong_scratch//derivatives/anat/prep/sub-NDARINV01TXCDJN/ses-baselineYear1Arm1/sub-NDARINV01TXCDJN_ses-baselineYear1Arm1_T2w_prep-biasFieldN4.nii.gz -cw256 -T2pial -all
date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
