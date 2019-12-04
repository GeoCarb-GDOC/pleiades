#PBS -S /bin/csh

# Select one node with 
#PBS -l select=1:ncpus=1:mpiprocs=1:model=bro
# Submit job to the devel queue
#PBS -q devel
# Send an e-mail on abort, begin, and end
#PBS -m abe
#PBS -M heather.cronk@colostate.edu,philip.partain@colostate.edu

# Load the compiler used to compile
module load comp-intel/2018.3.222 mpi-sgi/mpt

# By default, PBS executes your job from your home directory.
setenv PBS_O_WORKDIR ~/test-scripts
cd $PBS_O_WORKDIR

# Run the test
./run_l2_fp.csh /nobackup/hcronk/test-config/geocarb_test.with_aerosol-with_brdf.lua ~/"RtRetrievalFramework/input/geocarb/config/?.lua" /nobackup/hcronk/simulator_testing/data/scene_definition/output-geocarb-20160321_20x10.bak/geocarb_meteorology_rx_intensity_20160321_first_3.hdf /nobackup/hcronk/simulator_testing/data/scene_definition/output-geocarb-20160321_20x10.bak/geocarb_scene_rx_intensity_20160321_first_3.hdf /nobackup/hcronk/simulator_testing/data/radiative_transfer/output-geocarb-20160321_20x10-with_aerosol-with_brdf.bak/geocarb_l1b_rx_intensity_20160321_first_3.hdf /nobackup/hcronk/data/l2_output/l2_2016032114454250001.with_aerosol-with_brdf.h5 2016032114454250001 > ~/ditl_1/benchmark_test.log
