#!/bin/bash
#############################################################################################################################
#  File Name   : ws.sh
#  Purpose     : This Script contains all the required functions to manipulate a Workspace
#                You can list, add, delete, rename, disable a Workspace or can view all the existing Workspace
#############################################################################################################################
# Import the required files
source utility.sh

# Declare the variables
g_pwd=`pwd`                           # Current directory
g_home_dir=`echo ~`                   # Home Directory
g_cfg_dir="$g_home_dir/.erlftpsync"    # ERLFTPSYNC configuration Directory
g_ws_cfg="$g_cfg_dir/ws.cfg"           # WorkSpcae configuration file
g_ws_cfg_test="${g_ws_cfg}_test"
g_ws_status=""

# Function to check/create the configuration directory # Will be used by install.sh
create_ws_dir(){
    #echo "Checking if Directory exists : $g_cfg_dir"
    if [ ! -d "$g_cfg_dir" ] ; then
        echo "Creating configuration directory ......"
        mkdir "$g_cfg_dir"
        chmod 755 $g_cfg_dir
    fi
}

# Function to create ws configuration file # Will be used by install.sh
function create_ws_cfg(){
    if [ ! -f "$g_ws_cfg" ]; then
        echo "Creating configuration file"
        echo $g_ws_cfg_file_hdr>$g_ws_cfg
    fi
}
