#! /bin/bash
function Usage {
    cat <<USAGE

`basename $0` creates  shell scripts to submit to cluster with appropriate template TMPL file in pwd 

`basename $0`  -r researcher_directory
                        -p project_name
                        -s site
                        -h <help>
                        
Example:
  bash $0 -r /Shared/nopoulos -p sca_pilot -s 00201
Arguments:
  -r researcher_directory  The full root directory the imaging project resides
  -p project_name          A unique name of the imaging project where the BFC T1s and T2s reside
  -s site                  Input the site where scans were acquired 
  -h help
USAGE
    exit 1
}

# Parse input operators -------------------------------------------------------
while getopts "r:p:o:h" option
do
case "${option}"
in
  r) # researcher_directory
    researcherRoot=${OPTARG}
    ;;
  p) # project_name
    projectName=${OPTARG}
    ;;
  s) # site
    site=${OPTARG}
    ;;
  h) # help
    Usage >&2
    exit 0
    ;;
  *) # unknown options
    echo "ERROR: Unrecognized option -$OPT $OPTARG"
    exit 1
    ;;
esac
done


for i in ${researcherRoot}/${projectName}/rawdata/[a-zA-Z0-9]*/[a-zA-Z0-9]*/anat/ ; do
SUBJECTID=(`echo $i | awk '{gsub("/"," "); print $5}'`)
MRQID=(`echo $i | awk '{gsub("/"," "); print $6}'`)
T1=`find $i -name \*T1w.nii.gz`

 SHSCRIPTtmp=$(pwd)/${projectName}_atroposn4t1_${SUBJECTID}_${MRQID}_tmp.sh
 SHSCRIPT=$(pwd)/${projectName}_atroposn4t1_${SUBJECTID}_${MRQID}.sh
 cp /Shared/tientong_scratch/abcd/code/freesurfer00AtroposN4_T1TEMPLATE.sh.in ${SHSCRIPTtmp}
 cat ${SHSCRIPTtmp} | sed "s#BASEPATH#${BASEPATH}#g" | sed "s#SUBJECTID#${SUBJECTID}#g" | sed "s#MRQID#${MRQID}#g" | sed "s#T1#${T1}#g" >> ${SHSCRIPT}
 rm ${SHSCRIPTtmp}

done
