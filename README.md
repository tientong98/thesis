This Github repo consists of codes used in my thesis project: Testing differences in brain structure and functional connectivity between children with and without a family history of Alcohol Use Disorder, data from the Adolescents Brain Cognitive Development (ABCD) study.

* [Step 1: Identify subjects with and without a family history of Alcohol Use Disorder](https://github.com/tientong98/thesis/tree/master/Family%20History)
* [Step 2: Download the data and organize in BIDS format](https://github.com/tientong98/thesis#download-data-and-organize-in-bids-format)
* [Step 3: Run MRIQC](https://github.com/tientong98/thesis#run-mriqc)
* [Step 4: Run BRAINSTools](https://github.com/tientong98/thesis/tree/master/BRAINSTools%20Analysis)
* [Step 5: Run Freesurfer](https://github.com/tientong98/thesis/tree/master/FreeSurfer)
  * QC with [Quoala-T](https://github.com/Qoala-T)
* [Step 6: Run fMRIPrep and Resting State analysis](https://github.com/tientong98/thesis/tree/master/Resting%20State)

# [Download data and organize in BIDS format](https://github.com/tientong98/thesis/blob/master/run_abcd2bids.sh)

Instruction here: https://github.com/DCAN-Labs/abcd-dicom2bids

To run their scripts on our machines, make sure you follow what is listed in the file below
`/Shared/tientong_scratch/abcd/code/00abcd2bids_convert/abcd2bids_github/notes_abcd2bids.txt`

Also, because I only care about rs fMRI and sMRI, I went through all of the scripts and config files in my local abcd-dicom2bids repo and delete everything related to task fMRI or validating BIDS (running BIDS validation needs docker, which can't be run on IFT machines). Below is an example of how to run this script

```
python <path to script>/abcd2bids.py \
 /Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.8 \
 /Shared/tientong_scratch/abcd/code/00abcd2bids_convert/R2016b/v91 \
 --username tientong --password <your password> 2>&1 | tee abcd2bids_log.txt 
```

What I would recommend is submitting this as job on Argon

```bash
# run this on argon
qsub /Shared/tientong_scratch/abcd/code/run_abcd2bids.sh 
```

## Move data

`mv /Shared/tientong_scratch/abcd/code/00abcd2bids_convert/abcd2bids_github/data/* /Shared/tientong_scratch/abcd/rawdata`

## Run BIDS Validator

http://bids-standard.github.io/bids-validator/

Some file wasn't associated with json files, e.g., `/Shared/tientong_scratch/abcd/rawdata/sub-NDARINV12F1NWCG/ses-baselineYear1Arm1/fmap/vol0002.nii.gz`

Right now not sure what happened with the abcd2bids script, move all of those files to 
`/Shared/tientong_scratch/abcd/nojson` with the code in the cell below:


```bash
for i in /Shared/tientong_scratch/abcd/rawdata/[a-zA-Z0-9]*/[a-zA-Z0-9]*/fmap ; do 
  sub=(`echo $i | awk '{gsub("/"," "); print $5}' | awk '{gsub("-"," "); print $2}'`)
  ses=(`echo $i | awk '{gsub("/"," "); print $6}' | awk '{gsub("-"," "); print $2}'`)
  [ -f /Shared/tientong_scratch/abcd/rawdata/sub-${sub}/ses-${ses}/fmap/vol*2*.nii.gz ] && \
  mkdir -p /Shared/tientong_scratch/abcd/nojson/sub-${sub}/ses-${ses}/fmap && \
  mv /Shared/tientong_scratch/abcd/rawdata/sub-${sub}/ses-${ses}/fmap/vol*.nii.gz \
  /Shared/tientong_scratch/abcd/nojson/sub-${sub}/ses-${ses}/fmap
done
```

## To run a different batch of participants

Download the `ABCD Fasttrack QC Instrument` file (https://nda.nih.gov/) with the list of participants you're interested in. You can then make changes to this file (e.g., exclude task fMRI, DTI) by running [`getStructandRS.R`](https://github.com/tientong98/thesis/blob/master/getStructandRS.R)

then, copy the output to

<local abcd2bids repo>/spreadsheets/abcd_fastqc01.txt

## Multiple images of the same imaging module of the same session

Have to pick the run that is better. How? running MRIQC



# Run MRIQC

## MRIQC Subject Level

Create a template file (currently put on argon

`/Users/tientong/job_scripts/mriqc/abcd/mriqc_TEMPLATE.job`

Content of the template file pasted below


```bash
#!/bin/sh
#$ -pe smp 16
#$ -q PINC,CCOM,UI
#$ -m e
#$ -M tien-tong@uiowa.edu
#$ -o /Users/tientong/logs/abcd/mriqc/out
#$ -e /Users/tientong/logs/abcd/mriqc/err
OMP_NUM_THREADS=8
singularity run -H /Users/tientong/singularity_home \
  /Users/tientong/mriqc_0.14.2.sif \
     /Shared/tientong_scratch/abcd/rawdata \
     /Shared/tientong_scratch/abcd/derivatives/mriqc \
     participant --participant_label SUBJECT \
     --no-sub --verbose-reports --write-graph \
     -w /Shared/tientong_scratch/abcd/derivatives/mriqc \
     --n_procs 8 --mem_gb 36000
```
**Create a list of available subjects**

```bash
outputFile=/Shared/tientong_scratch/abcd/log/subjectlist/200129list.txt
for i in /Shared/tientong_scratch/abcd/rawdata/[a-zA-Z0-9]*/[a-zA-Z0-9]*/anat ; do 
  info=(`echo $i | awk '{gsub("/"," "); print $5}'`)
  sub=(`echo $info | awk '{gsub("-"," "); print $2}'`)
  echo $sub
done > ${outputFile}
```
**Then run this on argon to create individual subjects mriqc job script, then submit the jobs**

```bash
for sub in $(cat /Shared/tientong_scratch/abcd/log/subjectlist/200129list.txt | tr '\n' ' ') ; do
    sed -e "s|SUBJECT|${sub}|" /Users/tientong/job_scripts/mriqc/abcd/mriqc_TEMPLATE.job > \
    /Users/tientong/job_scripts/mriqc/abcd/mriqc_sub-${sub}.job
done

for sub in $(cat /Shared/tientong_scratch/abcd/log/subjectlist/200129list.txt | tr '\n' ' ') ; do
    qsub /Users/tientong/job_scripts/mriqc/abcd/mriqc_sub-${sub}.job
done 
```

## After subject level mriqc

**Jan 30 2020** Completed running mriqc all subjects in the list below

`/Shared/tientong_scratch/abcd/log/subjectlist/200129list.txt`

EXCEPT  
sub-NDARINV93KR583V - T2w  
sub-NDARINVA01DRNBZ - resting state   
sub-NDARINVCVK8YHVR - T2w  
sub-NDARINVJXT9LVJP - T2w  
sub-NDARINVRT0YKWJM - T2w  
sub-NDARINVZL6CFV5G - T2w  
  
Detailed logs are at `/Shared/tientong_scratch/abcd/derivatives/mriqc/logs`

## MRIQC group level


```bash
# after finish subject level analysis, run the group analysis (concatnate subjects' files)

singularity run \
   -H /Users/tientong/singularity_home \
   /Users/tientong/mriqc_0.14.2.sif \
      /Shared/tientong_scratch/abcd/rawdata \
      /Shared/tientong_scratch/abcd/derivatives/mriqc \
      group --no-sub --verbose-reports --write-graph \
      -w /Shared/tientong_scratch/abcd/derivatives/mriqc
```

Once the group level MRIQC is completed, move all files to

`/Shared/tientong_scratch/abcd/derivatives/mriqc/200129list_group`

# Choosing the best T1 or T2

Code: [`baw00ChooseBestStruct.R`](https://github.com/tientong98/thesis/blob/master/BRAINSTools%20Analysis/baw00ChooseBestStruct.R)
