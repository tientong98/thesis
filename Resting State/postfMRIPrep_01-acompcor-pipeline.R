#!/usr/bin/env Rscript
suppressPackageStartupMessages(require(optparse))
suppressPackageStartupMessages(require(dplyr))
suppressPackageStartupMessages(require(jsonlite))

# Get confounds including:
#    - non-steady state volumes
#    - 5 CSF and 5 WF components
#    - cosine ts
#    - 6 MPs + their derivatives (12HMP)

option_list = list(
  optparse::make_option(c("-p", "--path_fmriprep"), action="store", default=NA, type='character'),
  optparse::make_option(c("-s", "--subject"), action="store", default=NA, type='character'),
  optparse::make_option(c("-v", "--visit"), action="store", default=NA, type='character'))

opt = parse_args(OptionParser(option_list=option_list))

fmriprep <- opt$p
subject <- opt$s
session <- opt$v

fmriprep <- '/Shared/tientong_scratch/abcd/derivatives/fmriprep/fmriprep/'
subject <- 'sub-NDARINVA3G711KJ'
session <- 'ses-baselineYear1Arm1'

subject_path=paste0(fmriprep,"/",subject,"/",session,"/func/")

tsv_list = Sys.glob(paste0(subject_path,"*_desc-confounds_regressors.tsv"))
json_list = Sys.glob(paste0(subject_path,"*_desc-confounds_regressors.json"))

for (i in 1:length(tsv_list)) {
  confound <- read.table(tsv_list[i], header = T)
  cosine <- names(confound)[grep(pattern = "cosine", x = names(confound))]
  dummy <- names(confound)[grep(pattern = "non_steady_state_outlier", x = names(confound))]
  HMP12 <- c("trans_x", "trans_x_derivative1", "rot_x", "rot_x_derivative1",
             "trans_y", "trans_y_derivative1", "rot_y", "rot_y_derivative1",
             "trans_z", "trans_z_derivative1", "rot_z", "rot_z_derivative1")
  
  # get 5 WM and 5 CSF acompcor
  list <-fromJSON(json_list[i])
  acompcorlist <- list[names(list)[grep("a_comp_cor", names(list))]]
  json <- data.frame(matrix(unlist(acompcorlist), nrow = 6, byrow = F),row.names = names(acompcorlist$a_comp_cor_00))
  names(json) <- names(acompcorlist)
  json.transpose <- as.data.frame(t(json), stringsAsFactors = F)
  json.transpose[c("CumulativeVarianceExplained","SingularValue","VarianceExplained")] <- sapply(json.transpose[c("CumulativeVarianceExplained","SingularValue","VarianceExplained")], as.numeric)
  
  WM <- json.transpose[json.transpose$Mask=="WM",]
  WM <- WM[order(WM$SingularValue,decreasing = T),]
  wm <- row.names(WM)[1:5]
  
  CSF <- json.transpose[json.transpose$Mask=="CSF",]
  CSF <- CSF[order(CSF$SingularValue,decreasing = T),]
  csf <- row.names(CSF)[1:5]
  
  confound_var <- c(cosine,dummy,HMP12, wm, csf)
  confound_final <-confound[confound_var]
  confound_final[confound_final[,] == "n/a"] <- ""
  
  output <- sub("_regressors.tsv", "_regressors_final.txt", tsv_list[i])
  write.table(confound_final, file = output, sep = '\t', row.names = F, 
col.names = F, quote = F, na = "")
}
