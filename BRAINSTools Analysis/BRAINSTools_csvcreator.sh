
#! /bin/bash
function Usage {
    cat <<USAGE
`basename $0` creates a csv file to feed into BRAINSTools.
Usage:
`basename $0`  -r researcher_directory
                        -p project_name
			-o full path output csv name of file desired	
                        -h <help>
Example:
  bash $0 -r /Shared/nopoulos -p sca_pilot -o /Shared/axelsone_scratch/sca.csv
Arguments:
  -r researcher_directory  The full root directory the imaging project resides
  -p project_name          A unique name of the imaging project where the nifti directory
  			   reside
  -o outputFile 	   The full path to the desired output csv file with name desired
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
  o) # project_name
    outputFile=${OPTARG}
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

bids=${researcherRoot}/${projectName}/rawdata
T1=($(find $bids/*/*/ -name \*T1w.nii.gz))

for i in ${!T1[@]} ; do
 SUBJECT=`cut -d "/" -f6 <<< ${T1[$i]}`
 SESSION=`cut -d "/" -f7 <<< ${T1[$i]}`
 if [ 0 -lt `ls ${bids}/${SUBJECT}/${SESSION}/anat/*T2w.nii.gz 2>/dev/null | wc -c` ] ; then
   T2=`ls ${bids}/${SUBJECT}/${SESSION}/anat/*T2w.nii.gz`
   printf \"${projectName}\",\"${SUBJECT}\",\"${SESSION}\",\"\{\'T1-30\'\:\[\'${T1[$i]}\'\]\,\'T2-30\'\:\[\'$T2\'\]\}\"'\n'
 else
   printf \"${projectName}\",\"${SUBJECT}\",\"${SESSION}\",\"\{\'T1-30\'\:\[\'${T1[$i]}\'\]\}\"'\n'
 fi
done > ${outputFile}
