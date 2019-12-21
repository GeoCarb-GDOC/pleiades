#PBS -S /bin/bash

# Select one node with 
#PBS -l select=1:ncpus=1:mpiprocs=1:model=bro
# Submit job to the devel queue
#PBS -q devel
# Send an e-mail on abort
#PBS -m a
#PBS -M heather.cronk@colostate.edu

# Load the compiler used to compile
module load comp-intel/2018.3.222 mpi-sgi/mpt

# By default, PBS executes your job from your home directory.
export PBS_O_WORKDIR=~/test-scripts
cd $PBS_O_WORKDIR

# Run the test
./run_l2_fp.csh /nobackup/hcronk/test-config/geocarb_test.with_aerosol-with_brdf.lua ~/"RtRetrievalFramework/input/geocarb/config/?.lua" /nobackup/hcronk/data/20160324_box1_sa2_chunk001/geocarb_meteorology_rx_intensity_20160324_box1_sa2_1x1_chunk001.h5 "" /nobackup/hcronk/data/20160324_box1_sa2_chunk001/geocarb_l1b_rx_intensity_20160324_1x1_box1_sa2-with_aerosol-brdf_3_chunk001.h5 /nobackup/hcronk/data/20160324_box1_sa2_chunk001/geocarb_L2Ret_2016032414010006716_20160324_1x1_box1_sa2-with_aerosol-brdf_3_chunk001.h5 2016032414010006716> ~/ditl_1/test_run_real_data.log
