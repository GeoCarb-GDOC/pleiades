#PBS -S /bin/bash

# Select one Broadwell node and use all 28 cores
#PBS -l select=1:ncpus=28:model=bro
# Submit job to the devel queue
#PBS -q devel
# Send an e-mail on abort
#PBS -m a
#PBS -M heather.cronk@colostate.edu

# Load the compiler used to compile
# module load comp-intel/2018.3.222

# By default, PBS executes your job from your home directory.
# export PBS_O_WORKDIR=~/test-scripts
export PBS_O_WORKDIR=~/ditl_1/submit_jobs
cd $PBS_O_WORKDIR

####################################
### Start GeoCarb Specific Stuff ###
####################################

### Declare Variables ###
# Eventually make this a command line option with a default value
base_data_dir="/nobackup/hcronk/data/process"
# Eventually loop over the granule dirs and get gran from there
# NTS: When you add that capability, add a check to make sure all the data is there before starting
gran="20160324_box1_sa2_chunk001"

#Get sounding selection file for the given granule
ls ${base_data_dir}/${gran}/geocarb_L2SEL*.txt &> /dev/null
ret=$?

if [ $ret -eq 0 ]; then
    sel_file=($(ls ${base_data_dir}/${gran}/geocarb_L2SEL*.txt))
else
    echo "Sounding selection file not found"
    ls ${base_data_dir}/${gran}/geocarb_L2SEL*.txt
    exit
fi

### Set Up Retrieval and Log Directories ###
ret_dir=${base_data_dir}/${gran}/l2fp_retrievals
log_dir=${base_data_dir}/${gran}/l2fp_logs

mkdir -p ${ret_dir}
mkdir -p ${log_dir}

cat ${sel_file} | parallel -j 28 --sshloginfile $PBS_NODEFILE "cd $PWD;./process_granule_soundings.sh ${base_data_dir} ${gran} {}"
