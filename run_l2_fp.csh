#!/bin/tcsh
#scene file isn't required operationally, it's a diagnostic tool (put empty string in positional arg)
set l2_config_file_ = "$1"
set lua_path        = "$2"
set met_file_       = "$3"
set scene_file_     = "$4"
set spectrum_file_  = "$5"
set output_file     = "$6"
set sounding_id_    = "$7"

setenv aband_file         ""
setenv imap_file          ""
setenv input_file_mapping ""
setenv met_file           $met_file_
setenv scene_file         $scene_file_
setenv rrv_file           ""
setenv spectrum_file      $spectrum_file_
setenv abscodir           /nobackup/hcronk/data/absco
setenv merradir           /nobackup/hcronk/data/MERRA
setenv l2_config_file     $l2_config_file_
setenv LUA_PATH           "?.lua;${HOME}/RtRetrievalFramework/input/common/config/?.lua;${lua_path}"
setenv group_size         1
setenv sounding_id        $sounding_id_

# the l2_fp code adds a .generating tag to output files as they are being written
#gdb --args \
${HOME}/RtRetrievalFramework/build_optimized/l2_fp ${l2_config_file} ${output_file}
