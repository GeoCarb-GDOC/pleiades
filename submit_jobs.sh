#PBS -S /bin/bash

#################
### PBS Stuff ###
#################

# Select one Broadwell node and use all 28 cores
###PBS -l select=${nnodes}:model=bro
# Submit job to the devel queue
#PBS -q devel
# Send an e-mail on abort
#PBS -m a
#PBS -M heather.cronk@colostate.edu

# By default, PBS executes your job from your home directory.
# export PBS_O_WORKDIR=~/test-scripts
export PBS_O_WORKDIR=~/ditl_1/submit_jobs
cd $PBS_O_WORKDIR

cat ${sel_file} | parallel -j ${njobs} --sshloginfile $PBS_NODEFILE "cd $PWD;./process_granule_soundings.csh ${base_data_dir} ${gran} ${ret_dir} ${log_dir} {}"
