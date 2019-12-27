#!/bin/csh -f

# Checks
if ($#argv != 3) then
    echo -e $0 "Script usage:\n"$0 "base_data_directory granule_id sounding_id.\nEx: "$0 "/nobackup/hcronk/data/process" "20160324_box1_sa2_chunk001" "2016032414010006716"
    exit 1
endif

# Load the compiler used to compile
source ~/.cshrc
module load comp-intel/2018.3.222

### Get Variables ###
set base_data_dir=$argv[1]
set gran=$argv[2]
set sid=$argv[3]

### Set Up Retrieval and Log Directories ###
set ret_dir=${base_data_dir}/${gran}/l2fp_retrievals
set log_dir=${base_data_dir}/${gran}/l2fp_logs

set output_filename=${ret_dir}/geocarb_L2FPRet_${sid}_${gran}.h5
set log_filename=${log_dir}/geocarb_L2FPlog_${sid}_${gran}.log

cd ~/test-scripts
./run_l2_fp.csh /nobackup/hcronk/test-config/geocarb_test.with_aerosol-with_brdf.lua ~/"RtRetrievalFramework/input/geocarb/config/?.lua" ${base_data_dir}/${gran}/geocarb_meteorology*.h5 "" ${base_data_dir}/${gran}/geocarb_l1b*.h5 ${output_filename} ${sid}> $log_filename

