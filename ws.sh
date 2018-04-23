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

# Function to create WorkSpcae Mapping file
function create_map_cfg(){
    echo "$g_mapping_file_hdr">$1
}

# Getter Function : Return status of passed Workspace, if not exists will return INVALID
function get_ws_status(){
    l_ws_status=`grep -iw "$1" "${g_ws_cfg}" | cut -d"," -f2`
    if [ -z "$l_ws_status" ]
    then
       l_ws_status="INVALID"
    fi
    echo $l_ws_status
}

# Setter Function : set Workspace status
function set_ws_status(){
    g_ws_status=`grep -iw "$1" "${g_ws_cfg}" | cut -d"," -f2`
    if [ -z "$g_ws_status" ]
    then
       g_ws_status="INVALID"
    fi
    #echo $g_ws_status
}


# Function to list the Workspace
function list_ws(){
    #echo "Checking if file exists : $g_ws_cfg"
    if [ -f "$g_ws_cfg" ]
    then
        list=`awk -F"," '{ if($0 !~ /#/) print $1" - "$2 }' "$g_ws_cfg"`
        # Check if any Workspace exists or empty
        if [ -z "$list" ]
        then
           echo "No Workspace configured yet."
        else
            printf "%15s - %s\n" "Workspace" "Status"
            for record in `grep -v "#" $g_ws_cfg`; do
                wsName=`echo $record | cut -d"," -f1`
                wsStatus=`echo $record | cut -d"," -f2`
                #echo "$wsName - $wsStatus"
                printf "%15s - %s\n" "$wsName" "$wsStatus"
            done
        fi
    else
        echo "$g_ws_cfg : Configuration File does not exists."
    fi
}
