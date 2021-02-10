This folder contain codes for brain volumetric analysis with BRAINSTools - [BRAINSTools wiki](https://github.com/BRAINSia/BRAINSTools/wiki).

The scipts are modified from the pipeline developed by the researchers at the [Iowa Neuroimaging Core](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_volumetrics/baw.md).

# Running BrainsTools

0. Create random hash

Note: BrainsTools expects all session to be different - have to replace session (baselineYear1Arm1) with a series of random numbers/strings 

```bash
bids=/Shared/tientong_scratch/abcd/rawdata

# change session to a random hash

for i in $bids/*/* ; do 
 sub=(`echo $i | awk '{gsub("/"," "); print $5}'| awk '{gsub("-"," "); print $2}'`)
 ses=(`echo $i | awk '{gsub("/"," "); print $6}'| awk '{gsub("-"," "); print $2}'`)
 mv $i $bids/sub-${sub}/ses-`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 16`
done

# save this random hash to a file

ls -d $bids/*/*/ > /Shared/tientong_scratch/abcd/derivatives/baw/randomhash_200725.txt
```

1. Run the csv creator

[`BRAINSTools_csvcreator.sh`](https://github.com/tientong98/thesis/blob/master/BRAINSTools%20Analysis/BRAINSTools_csvcreator.sh)


```bash
sh /Shared/tientong_scratch/abcd/code/brainstools/BRAINSTools_csvcreator.sh \
 -r /Shared/tientong_scratch \
 -p abcd \
 -o /Shared/tientong_scratch/abcd/derivatives/baw/200725.csv
```

2. Make changes to the config file (on the lines written in the header

[`BRAINSTools.config`](https://github.com/tientong98/thesis/blob/master/BRAINSTools%20Analysis/BRAINSTools.config)

3. Run BrainsTools on argon with

`baw03runbaw.sh`

The steps are pasted below:


```bash
# run this on argon
export PATH=/Shared/pinc/sharedopt/apps/anaconda3/Linux/x86_64/4.3.0/bin:$PATH
bash /Shared/tientong_scratch/abcd/code/brainstools/BRAINSTools_runbaw.sh \
 -p 1 -s all \
 -r SGEGraph \
 -c /Shared/tientong_scratch/abcd/code/brainstools/BRAINSTools.config

```
