#!/usr/bin/env Rscript
suppressPackageStartupMessages(require(optparse))
suppressPackageStartupMessages(require(dplyr))

option_list = list(
  optparse::make_option(c("-p", "--path_fmriprep"), action="store", default=NA, type='character'),
  optparse::make_option(c("-s", "--subject"), action="store", default=NA, type='character'),
  optparse::make_option(c("-v", "--visit"), action="store", default=NA, type='character'),
  optparse::make_option(c("-o", "--output"), action="store", default=NA, type='character'))

opt = parse_args(OptionParser(option_list=option_list))

fmriprep <- opt$p
subject <- opt$s
session <- opt$v
output <- opt$o

#fmriprep <- "/Shared/tientong_scratch/abcd/derivatives/fmriprep/fmriprep/" 
#subject <- "sub-NDARINVT345WWLE" 
#session <- "ses-baselineYear1Arm1"
#output <- "/Shared/tientong_scratch/abcd/derivatives/fmriprep/count_nonsteady.txt"

subject_path=paste0(fmriprep,"/",subject,"/",session,"/func/")

tsv_list = Sys.glob(paste0(subject_path,"*_desc-confounds_regressors.tsv"))

for (i in 1:length(tsv_list)) {
  confound <- read.table(tsv_list[i], header = T)
  dummy <- names(confound)[grep(pattern = "non_steady_state_outlier", x = names(confound))]
  run <- i
  non_steady <- ncol(confound[dummy])
  
  save_df <- data.frame(subject,run,non_steady)

  write.table(save_df, file = output, sep = '\t', row.names = F, 
              col.names != file.exists(output), quote = F, na = "", append = T)
}
