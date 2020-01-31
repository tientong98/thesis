This folder contain codes for brain volumetric analysis with BRAINSTools - [BRAINSTools wiki](https://github.com/BRAINSia/BRAINSTools/wiki).

The scipts are modified from the pipeline developed by the researchers at the [Iowa Neuroimaging Core](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_volumetrics/baw.md).

# Running BrainsTools

1. Run the csv creator

`baw01BRAINSTools_csvcreator.sh`

Note: BrainsTools expects all session to be different - have to replace session (baselineYear1Arm1) with a series of random numbers/strings 

```bash
%%bash
for i in /Shared/tientong_scratch/abcd/rawdata/[a-zA-Z0-9]*/[a-zA-Z0-9]* ; do 
sub=(`echo $i | awk '{gsub("/"," "); print $5}'| awk '{gsub("-"," "); print $2}'`)
ses=(`echo $i | awk '{gsub("/"," "); print $6}'| awk '{gsub("-"," "); print $2}'`)
mv $i /Shared/tientong_scratch/abcd/rawdata/sub-${sub}/ses-$("uuidgen")
done
```

2. Make changes to the config file (on the lines written in the header

`baw02BRAINSTools.config`

3. Run BrainsTools on argon with

`baw03runbaw.sh`

The steps are pasted below:


```bash
# run this on argon

sh /Shared/tientong_scratch/abcd/code/baw01BRAINSTools_csvcreator.sh -r /Shared/tientong_scratch -p abcd -o /Shared/tientong_scratch/abcd/derivatives/baw/200129.csv

export PATH=/Shared/pinc/sharedopt/apps/anaconda3/Linux/x86_64/4.3.0/bin:$PATH
bash /Shared/tientong_scratch/abcd/code/baw03runbaw.sh -p 1 -s all -r SGEGraph -c /Shared/tientong_scratch/abcd/code/baw02BRAINSTools.config
```
