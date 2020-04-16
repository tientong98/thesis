#!/bin/bash
#$ -pe smp 20
#$ -q UI
#$ -m e
#$ -M tien-tong@uiowa.edu
#$ -o /Users/tientong/logs/abcd/abcd2bids/out
#$ -e /Users/tientong/logs/abcd/abcd2bids/err

log=/Shared/tientong_scratch/abcd/code/00abcd2bids_convert/abcd2bids_github/abcd2bids_log.txt

echo '#--------------------------------------------------------------------------------' >> ${log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${log}

export PATH=$PATH:/Shared/pinc/sharedopt/apps/anaconda3/Linux/x86_64/5.3.0/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/Shared/tientong_scratch/abcd/code/00abcd2bids_convert/R2016b/v91/runtime/glnxa64:/Shared/tientong_scratch/abcd/code/00abcd2bids_convert/R2016b/v91/bin/glnxa64:/Shared/tientong_scratch/abcd/code/00abcd2bids_convert/R2016b/v91/sys/os/glnxa64/
source activate dcm2bids
export PATH=$PATH:/Shared/pinc/sharedopt/apps/dcm2niix/Linux/x86_64/1.0.20180622/
export PATH=$PATH:/Shared/tientong_scratch/abcd/code/00abcd2bids_convert/pigz-2.4
export PATH=$PATH:~/bin

python /Shared/tientong_scratch/abcd/code/00abcd2bids_convert/abcd2bids_github/abcd2bids.py /Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.8 /Shared/tientong_scratch/abcd/code/00abcd2bids_convert/R2016b/v91 --username tientong --password <your_password> 2>&1 | tee ${log}

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${log}
echo '' >> ${log}
