This folder has codes to run Freesurfer after field bias correction with ANTS Atropos N4. The pipeline was modified from https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_surfometrics/freesurfer60.md

For both steps (ANTS Atropos N4 correction and freesurfer recon-all):
* First, create a template .sh script, with placeholders for subject id and session number
* Then, run the `create.sh` scripts to create individual subject script using `sed` to replace placeholders with actual IDs
* Lastly, run scripts in parallel with `xargs`
* QC Freesurfer outputs with `stats2table_bash_qoala_t.sh`

# Running Freesurfer

## First Create Atropos N4  T1 and T2

```bash
cd /Shared/tientong_scratch/abcd/code/freesurfer00AtroposN4_T1 # all the sh scripts will be here
sh /Shared/tientong_scratch/abcd/code/freesurfer00createAtroposN4_T1.sh -r /Shared/tientong_scratch -p abcd
ls * | xargs -i{} -P10 sh {}
```


```bash
cd /Shared/tientong_scratch/abcd/code/freesurfer00AtroposN4_T2 # all the sh scripts will be here
sh /Shared/tientong_scratch/abcd/code/freesurfer00createAtroposN4_T2.sh -r /Shared/tientong_scratch -p abcd
ls * | xargs -i{} -P10 sh {}
```

## Run Freesurfer for subjects with both T1 and T2

```bash
cd /Shared/tientong_scratch/abcd/code/freesurfer01createFSjobsT1T2 # all the sh scripts will be here
sh /Shared/tientong_scratch/abcd/code/freesurfer01createFSjobsT1T2.sh -r /Shared/tientong_scratch -p abcd
ls * | xargs -i{} -P10 sh {}
```
