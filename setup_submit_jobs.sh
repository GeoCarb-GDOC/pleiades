#!/bin/bash
##############################
### GeoCarb Specific Stuff ###
##############################

### Declare Variables ###
# Eventually make this a command line option with a default value
base_data_dir="/nobackup/hcronk/data/process"
# Eventually loop over the granule dirs and get gran from there
# NTS: When you add that capability, add a check to make sure all the data is there before starting
###grans=($(ls -d ${base_data_dir}/*))
###grans=("20160324_box3_sa1_chunk009" "20160324_box3_sa1_chunk012" "20160324_box4_na_chunk019" "20160324_box4_na_chunk021" "20160324_box5_ca_chunk013" "20160324_box5_ca_chunk015" "20160324_box5_ca_chunk017") 
grans=("023-011-027_20160729133048")
njobs=100
#eventually pull this keyword arg from the command line
verbose=true

for gran in ${grans[@]}
do
    #qstat to see if any jobs are running since right now we can only run one at a time
    #if so, wait 5 mins and try again
    if not, move along
    gran=$(basename ${gran})
    if verbose; then
        echo "Checking input data for ${gran}"
    
    #Check for L1b, L2Met, and L2Sel input files 
    #(leave easy mechanism to add other input files as needed)
    #once this is in place, can just pull the sel_file= line
    #from the section below...but probably the lockfile should be 
    #created checked and/or created right before the selection file is 
    #recorded
    
    #Get sounding selection file for the given granule
    ###ls ${base_data_dir}/${gran}/geocarb_L2Sel*.txt &> /dev/null
    ls ${base_data_dir}/${gran}/geocarb_L2Sel*.txt &> /dev/null
    ret=$?

    if [ $ret -eq 0 ]; then
        sel_file=($(ls ${base_data_dir}/${gran}/geocarb_L2Sel*.txt))
    else
        echo "Sounding selection file not found"
        ls ${base_data_dir}/${gran}/geocarb_L2Sel*.txt
        #exit
        continue
    fi
    
    ### Set Up Retrieval and Log Directories ###
    ret_dir=${base_data_dir}/${gran}/l2fp_retrievals
    log_dir=${base_data_dir}/${gran}/l2fp_logs

    mkdir -p ${ret_dir}
    mkdir -p ${log_dir}

    nsoundings=($(wc -l ${sel_file}))
    nnodes=$(((${nsoundings} / ${njobs}) + (${nsoundings} % ${njobs} > 0)))
    
    if [ $nnodes -gt 75 ]; then 
        nnodes=75
    fi
    ### cat ${sel_file} | parallel -j ${njobs} --sshloginfile $PBS_NODEFILE "cd $PWD;./process_granule_soundings.sh ${base_data_dir} ${gran} ${ret_dir} ${log_dir} {}"

    qsub -l select=${nnodes}:model=bro -v sel_file=${sel_file},njobs=${njobs},base_data_dir=${base_data_dir},gran=${gran},ret_dir=${ret_dir},log_dir=${log_dir} ~/ditl_1/submit_jobs/submit_jobs.sh
    sleep 50m
    #capture jobID from qsub from stdout
    #qstat to see that the job is in PBS queue or running
    #if error or DNE, note in lockfile (record of having tried it) but 
    #do something with lockfile such that the granule will be tried again
done 
