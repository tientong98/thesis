This folder has codes to run Freesurfer after field bias correction with ANTS Atropos N4. The pipeline was modified from https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_surfometrics/freesurfer60.md


# Create Atropos N4 T1 and T2

  * Template:
    * [AtroposN4_T1_TEMPLATE.sh](https://github.com/tientong98/thesis/blob/master/FreeSurfer/AtroposN4_T1_TEMPLATE.sh)
    * [AtroposN4_T2_TEMPLATE.sh](https://github.com/tientong98/thesis/blob/master/FreeSurfer/AtroposN4_T2_TEMPLATE.sh)
    
  * Make subject-specific script from the template:
    * [make_SubjectSpecific_AtroposN4_T1.sh](https://github.com/tientong98/thesis/blob/master/FreeSurfer/make_SubjectSpecific_AtroposN4_T1.sh)
    * [make_SubjectSpecific_AtroposN4_T2.sh](https://github.com/tientong98/thesis/blob/master/FreeSurfer/make_SubjectSpecific_AtroposN4_T2.sh)

# Run Freesurfer

  * Template:
    * [freesurfer_T1_TEMPLATE.sh](https://github.com/tientong98/thesis/blob/master/FreeSurfer/freesurfer_T1_TEMPLATE.sh): template for subjects with T1w only
    * [freesurfer_T1T2_TEMPLATE.sh](https://github.com/tientong98/thesis/blob/master/FreeSurfer/freesurfer_T1T2_TEMPLATE.sh): template for subjects with both T1w and T2w
    
  * Make subject-specific script from the template:
    * [make_SubjectSpecific_freesurfer.sh](https://github.com/tientong98/thesis/blob/master/FreeSurfer/make_SubjectSpecific_freesurfer.sh)
    
 # QC Freesurfer with QOALA T:
 
  * Qoala_T_A_model_based_github.R
  * Stats2Table.R
