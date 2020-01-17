#!/bin/bash
##############################
### GeoCarb Specific Stuff ###
##############################

### Declare Variables ###
# Eventually make this a command line option with a default value
base_data_dir="/nobackup/hcronk/data/process"
# Eventually loop over the granule dirs and get gran from there
# NTS: When you add that capability, add a check to make sure all the data is there before starting
gran="20160324_box1_sa2_chunk001"
njobs=100

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

nsoundings=($(wc -l ${sel_file}))
nnodes=$(((${nsoundings} / ${njobs}) + (${nsoundings} % ${njobs} > 0)))

### cat ${sel_file} | parallel -j ${njobs} --sshloginfile $PBS_NODEFILE "cd $PWD;./process_granule_soundings.sh ${base_data_dir} ${gran} ${ret_dir} ${log_dir} {}"

qsub -l select=${nnodes}:model=bro -v sel_file=${sel_file},njobs=${njobs},base_data_dir=${base_data_dir},gran=${gran},ret_dir=${ret_dir},log_dir=${log_dir} ~/ditl_1/submit_jobs/submit_jobs.sh 
