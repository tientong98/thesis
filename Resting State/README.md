
# Section:
  * [Preprocessing with fMRIPrep](#preprocessing-with-fmriprep)
  * [Post-processing: Regression, bandpass, ROI timeseries extraction, get correlation matrix](#post-processing-regression-bandpass-roi-timeseries-extraction-get-correlation-matrix)


# Preprocessing with fMRIPrep

Skip slice-time correction, because the data is multiband

  * Template files:
    * [fmriprep_nostc_TEMPLATE.sh](https://github.com/tientong98/thesis/blob/master/Resting%20State/fmriprep_nostc_TEMPLATE.sh): use subject's own fieldmap for field distortion correction
    * [fmriprep_nostc_syn_TEMPLATE.sh](https://github.com/tientong98/thesis/blob/master/Resting%20State/fmriprep_nostc_syn_TEMPLATE.sh): use an ANTs function to correct for field distortion for those that don't have fieldmap
    
  * [Create subject-specific fMRIPrep script from the template file:](https://github.com/tientong98/thesis/blob/master/Resting%20State/make_SubjectSpecific_fmriprep.sh)
  
  ```bash
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
  ```

# Post-processing: Regression, bandpass, ROI timeseries extraction, get correlation matrix

  * Template files: wrapper scripts for sessions with either [single run](https://github.com/tientong98/thesis/blob/master/Resting%20State/postfMRIPrep_singlerun_wrapper_TEMPLATE.sh) or [multiple runs](https://github.com/tientong98/thesis/blob/master/Resting%20State/postfMRIPrep_multirun_wrapper_TEMPLATE.sh). Include the following steps:
    * `postfMRIPrep_01-acompcor-pipeline.R`: Get confounds including:
      * non-steady state volumes
      * 5 CSF and 5 WF components
      * cosine ts
      * 6 MPs + their derivatives (12HMP)
    * `postfMRIPrep_02-bpreg_*.sh`:  regress, bandpass, smooth, normalize and scale
    * `postfMRIPrep_03-correl_*.sh`: extract ROI ts from the extended Power atlas, then calculate correlation
    
  * Create subject-specific fMRIPrep script from the template file:
  
  ```bash
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
  ```
