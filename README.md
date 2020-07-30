## Overview

This code sets up and spawns L2-FP jobs via PBS on Pleiades

## Code Components

**setup_submit_jobs.sh**: This script parses the sounding selection
text file for a given granule (or set of granules) and feeds the
sounding IDs to PBS jobs (njobs at a time on nnodes <=75) by calling
`submit_jobs.sh` (**this is the script you call at runtime**)

**submit_jobs.sh**: This script does the PBS setup to run
`process_granule_soundings.csh`

**process_granule_soundings.csh**: This script sets up the node-level
environment and runs `run_l2_fp.sh` for each sounding within a Singularity
container environment

**run_l2_fp.csh**: This is a wrapper script around the L2-FP executable
that feeds it the appropriate paths to the IO information

## Run instructions (WIP)
Update scripts as necessary and call `./setup_submit_jobs.sh`
