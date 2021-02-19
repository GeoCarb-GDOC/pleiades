#!/bin/bash
##############################
### GeoCarb Specific Stuff ###
##############################

### Declare Variables ###
# Eventually make this a command line option with a default value
base_data_dir="/nobackup/hcronk/data/process"
input_data_products=("L1bSc" "L2Met" "L2Sel")
###grans=($(ls -d ${base_data_dir}/*))
###grans=("20160324_box3_sa1_chunk009" "20160324_box3_sa1_chunk012" "20160324_box4_na_chunk019" "20160324_box4_na_chunk021" "20160324_box5_ca_chunk013" "20160324_box5_ca_chunk015" "20160324_box5_ca_chunk017") 
grans=("023-011-027_20160729133048")
njobs=100

user=""
verbose="false"
while getopts "u:v" flag
do
  case "${flag}" in
    u) user="${OPTARG}" ;;
    v) verbose="true" ;;
    *) echo "Unrecognized flag. Only -v (verbose) is available"
       exit ;;
  esac
done

if [ ! ${user} ]; then
    echo "Please provide NAS username for checking PBS jobs using -u flag"
    exit
fi


for gran in ${grans[@]}
do
    
    check_current_pbs_jobs=($(qstat -u ${user} | awk "/^[0-9]{8}/" | wc -l ))
    while [[ ${check_current_pbs_jobs} > 0 ]]
    do
        #while there is a job running, wait
        sleep 1m
        check_current_pbs_jobs=($(qstat -u ${user} | awk "/^[0-9]{8}/" | wc -l ))
    done
    
    gran=$(basename ${gran})
    if [ "$verbose" == "true" ]; then
        echo "Checking input data for ${gran}"
    fi
    
    #Check/create lockfile here eventually
    
    for input_product in ${input_data_products[@]}
    do
        ls ${base_data_dir}/${gran}/geocarb_${input_product}_${gran}*  &> /dev/null
        ret=$?
        if [ $ret -ne 0 ]; then
            echo "Input file for ${input_product} DNE."
            continue 2
    done
    
    #Get sounding selection file for the given granule   
    sel_file=($(ls ${base_data_dir}/${gran}/geocarb_L2Sel*.txt))
    
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

    #capture jobID from qsub from stdout
    #qstat to see that the job is in PBS queue or running
    #if error or DNE, note in lockfile (record of having tried it) but 
    #do something with lockfile such that the granule will be tried again
done 
