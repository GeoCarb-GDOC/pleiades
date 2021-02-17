#!/bin/csh -f

# Checks
if ($#argv != 5) then
    echo -e $0 "Script usage:\n"$0 "base_data_directory granule_id sounding_id.\nEx: "$0 "/nobackup/hcronk/data/process" "20160324_box1_sa2_chunk001" "2016032414010006716" "/retrieval_dir_no_trailing_slash" "/log_dir_no_trailing_slash"
    exit 1
endif

# Load the compiler used to compile
source ~/.cshrc
#module load comp-intel/2018.3.222
module use -a /nasa/modulefiles/testing
module load singularity

### Get Variables ###
set base_data_dir=$argv[1]
set gran=$argv[2]
set ret_dir=$argv[3]
set log_dir=$argv[4]
set sid=$argv[5]

### Set Up Retrieval and Log Directories ###
# set ret_dir=${base_data_dir}/${gran}/l2fp_retrievals
# set log_dir=${base_data_dir}/${gran}/l2fp_logs_56jobs

set output_filename=${ret_dir}/geocarb_L2FPRet_${sid}_${gran}.h5
set log_filename=${log_dir}/geocarb_L2FPlog_${sid}_${gran}.log

singularity exec -B /usr/local/lib:/usr/local/lib -B /nobackup/hcronk:/nobackup/hcronk /nobackup/hcronk/singularity/geocarb_l2fp_exec ./run_l2_fp.csh /nobackup/hcronk/test-config/geocarb_test.with_aerosol-with_brdf-ch4_co_profiles.lua ~/"RtRetrievalFramework/input/geocarb/config/?.lua" ${base_data_dir}/${gran}/geocarb_L2Met*.h5 "" ${base_data_dir}/${gran}/geocarb_L1bSc*.h5 ${output_filename} ${sid}> $log_filename

