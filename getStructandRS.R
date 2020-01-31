df <- read.table("abcd_fastqc01_allmodals.txt", header = T, stringsAsFactors = F)
df <- df[-1,]

library(dplyr)
df <- df %>% filter(visit == "baseline_year_1_arm_1" &  ftq_usable == 1 & ftq_recalled == 0)

exclude <- df[grepl("MID-fMRI|SST-fMRI|nBack-fMRI|Diffusion|DTI", df$ftq_series_id),]

final <- setdiff(df, exclude)

write.table(final, "abcd_fastqc01.txt", sep = "\t", row.names = F, quote = F)
# have to add back the 2nd line that was excluded on line 2