library(dplyr)

#############################################################################################################################
################################################# CHOOSING T1 ###############################################################
#############################################################################################################################

# read the data

t1qc <- read.table("/Shared/tientong_scratch/abcd/derivatives/mriqc/200129list_group/group_T1w.tsv", 
                   header = T, stringsAsFactors = F)

# filter out subjects with only 1 T1 (keep subjects with multiple T1s)
t1qc <- t1qc[grep("run", t1qc$bids_name),]

# get subject id
t1qc$sub <- 0
t1qc$ses <- 0
for (i in 1:length(t1qc$bids_name)) {
  t1qc$sub[i] <- strsplit(t1qc$bids_name[i], split = "_")[[1]][1]
  t1qc$ses[i] <- strsplit(t1qc$bids_name[i], split = "_")[[1]][2]
}
subt1 <- unique(t1qc$sub)

# choose the best T1
for (i in 1:length(subt1)) {
  subject <- t1qc %>% filter(sub == subt1[i])
  iqm1 <- subject$bids_name[which.min(subject$cjv)]
  iqm2 <- subject$bids_name[which.max(subject$cnr)]
  iqm3 <- subject$bids_name[which.max(subject$snr_total)]
  iqm4 <- subject$bids_name[which.min(subject$efc)]
  iqm5 <- subject$bids_name[which.max(subject$fber)]
  iqm6 <- subject$bids_name[which.min(subject$fwhm_avg)]
  iqm7 <- subject$bids_name[which.min(subject$rpve_csf)]
  iqm8 <- subject$bids_name[which.min(subject$rpve_gm)]
  iqm9 <- subject$bids_name[which.min(subject$rpve_wm)]
  iqms <- c(iqm1, iqm2, iqm3, iqm4, iqm5, iqm6, iqm7, iqm8, iqm9)
  Mode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }
  best <- Mode(iqms)
  move <- setdiff(subject$bids_name, best)
  for (x in 1:length(move)) {
    if (dir.exists(paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat")) == F) {
      icesTAF::mkdir(paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat"))
      file.rename(from = paste0("/Shared/tientong_scratch/abcd/rawdata/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".nii.gz"),
                  to   = paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".nii.gz"))
      file.rename(from = paste0("/Shared/tientong_scratch/abcd/rawdata/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".json"),
                  to   = paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".json"))}
    else {
      file.rename(from = paste0("/Shared/tientong_scratch/abcd/rawdata/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".nii.gz"),
                  to   = paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".nii.gz"))
      file.rename(from = paste0("/Shared/tientong_scratch/abcd/rawdata/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".json"),
                  to   = paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".json"))
    }}}

  
  
#############################################################################################################################
################################################# CHOOSING T2 ###############################################################
#############################################################################################################################

# read the data

t2qc <- read.table("/Shared/tientong_scratch/abcd/derivatives/mriqc/200129list_group/group_T2w.tsv", 
                   header = T, stringsAsFactors = F)

# filter out subjects with only 1 t2 (keep subjects with multiple t2s)
t2qc <- t2qc[grep("run", t2qc$bids_name),]

# get subject id
t2qc$sub <- 0
t2qc$ses <- 0
for (i in 1:length(t2qc$bids_name)) {
  t2qc$sub[i] <- strsplit(t2qc$bids_name[i], split = "_")[[1]][1]
  t2qc$ses[i] <- strsplit(t2qc$bids_name[i], split = "_")[[1]][2]
}
subt2 <- unique(t2qc$sub)

# choose the best t2
for (i in 1:length(subt2)) {
  subject <- t2qc %>% filter(sub == subt2[i])
  iqm1 <- subject$bids_name[which.min(subject$cjv)]
  iqm2 <- subject$bids_name[which.max(subject$cnr)]
  iqm3 <- subject$bids_name[which.max(subject$snr_total)]
  iqm4 <- subject$bids_name[which.min(subject$efc)]
  iqm5 <- subject$bids_name[which.max(subject$fber)]
  iqm6 <- subject$bids_name[which.min(subject$fwhm_avg)]
  iqm7 <- subject$bids_name[which.min(subject$rpve_csf)]
  iqm8 <- subject$bids_name[which.min(subject$rpve_gm)]
  iqm9 <- subject$bids_name[which.min(subject$rpve_wm)]
  iqms <- c(iqm1, iqm2, iqm3, iqm4, iqm5, iqm6, iqm7, iqm8, iqm9)
  Mode <- function(x) {
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
  }
  best <- Mode(iqms)
  move <- setdiff(subject$bids_name, best)
  for (x in 1:length(move)) {
    if (dir.exists(paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat")) == F) {
      icesTAF::mkdir(paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat"))
      file.rename(from = paste0("/Shared/tientong_scratch/abcd/rawdata/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".nii.gz"),
                  to   = paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".nii.gz"))
      file.rename(from = paste0("/Shared/tientong_scratch/abcd/rawdata/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".json"),
                  to   = paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".json"))}
    else {
      file.rename(from = paste0("/Shared/tientong_scratch/abcd/rawdata/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".nii.gz"),
                  to   = paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".nii.gz"))
      file.rename(from = paste0("/Shared/tientong_scratch/abcd/rawdata/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".json"),
                  to   = paste0("/Shared/tientong_scratch/abcd/rawdata_bad/",subject$sub[1],"/",subject$ses[1],"/anat/",move[x],".json"))
    }}}


