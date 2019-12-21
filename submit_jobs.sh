#PBS -S /bin/bash

# Select one node with 
#PBS -l select=1:ncpus=1:mpiprocs=1:model=bro
# Submit job to the devel queue
#PBS -q devel
# Send an e-mail on abort
#PBS -m a
#PBS -M heather.cronk@colostate.edu

# Load the compiler used to compile
module load comp-intel/2018.3.222

# By default, PBS executes your job from your home directory.
export PBS_O_WORKDIR=~/test-scripts
cd $PBS_O_WORKDIR

####################################
### Start GeoCarb Specific Stuff ###
####################################

### Declare Variables ###
# Eventually make this a command line option with a default value
base_data_dir="/nobackup/hcronk/data"
# Eventually loop over the granule dirs and get gran from there
# NTS: When you add that capability, add a check to make sure all the data is there before starting
gran="20160324_box1_sa2_chunk001"
# Eventually discover this in the granule directory with a regex
sel_file="sounding_selection_subset_for_testing.txt"

### Set Up Retrieval and Log Directories ###
ret_dir=${base_data_dir}/${gran}/l2fp_retrievals
log_dir=${base_data_dir}/${gran}/l2fp_logs

mkdir -p ${ret_dir}
mkdir -p ${log_dir}

### Get Info from the Sounding Selection File ###
while read line
do
    sid=${line}
    # To discuss with Phil: if we need to re-run a sounding, do we want to preserve the originally produced file and log?
    output_filename=${ret_dir}/geocarb_L2FPRet_${sid}_${gran}.h5
    log_filename=${log_dir}/geocarb_L2FPlog_${sid}_${gran}.log
    
    ./run_l2_fp.csh /nobackup/hcronk/test-config/geocarb_test.with_aerosol-with_brdf.lua ~/"RtRetrievalFramework/input/geocarb/config/?.lua" ${base_data_dir}/${gran}/geocarb_meteorology*.h5 "" ${base_data_dir}/${gran}/geocarb_l1b*.h5 ${output_filename} ${sid}> $log_filename
done<${base_data_dir}/${gran}/${sel_file}
