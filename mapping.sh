#!/bin/bash
#############################################################################################################################
#  File Name   : mapping.sh
#  Purpose     : This Script contains all the required functions to manipulate a Mapping
#                You can list, add, delete, rename, disable a Mapping or can view all the existing Mapping.
#############################################################################################################################
# Import the required files
source ws.sh     

# Declare the variables
g_map_ws=""         # Mapping's Workspace name
g_map_ws_dir=""     # Mapping's Workspace directory
g_map_status=""     # Mapping's Status
g_map_cfg=""        # Mapping's configuration file
g_map_cfg_tmp=""    # Temp file name

# Function to check/create the Mapping directory
create_map_dir(){
    l_map
    #echo "Checking if Directory exists : $l_ws_dir"
    if [ ! -d "$l_ws_dir" ] ; then
        echo "Creating Mapping directory ......"
        mkdir "$l_ws_dir"
        chmod 755 $l_ws_dir
    fi
}

# This function will initialize the required parameters, Always run it first
function init_map() {
    # Get Workspace name from User if not passed
    if [ -z "$value1" ]; then
        g_map_ws=$( uread "Enter Workspace name for Mapping" )
    else
        g_map_ws=$( get_upper $1 )
    fi

    #check Workspace status
    set_ws_status $g_map_ws
    if [ "$g_ws_status" = "INVALID" ]
    then
       echo "$g_map_ws : Invalid Workspace passed, Please LIST Workspace to view existing Workspaces."
       exit 1
    elif [ "$g_ws_status" = 'DISABLED' ]; then
        g_map_ws_dir="$g_cfg_dir/$g_map_ws-DISABLED"
    else
        g_map_ws_dir="$g_cfg_dir/$g_map_ws"
    fi
    g_map_cfg="$g_map_ws_dir/mapping.cfg" #Set Mapping configuration
    g_map_cfg_tmp="${g_map_cfg}_tmp.cfg" #Set Mapping configuration
}

# Function to list the Mapping
function list_mapping(){
    init_map
    #echo "Checking if file exists ... $g_map_cfg"
    if [ -f "$g_map_cfg" ]; then
       # File exists
       list=`awk -F"," '{ if($0 !~ /#/) print $1 }' "$g_map_cfg"`
       # Check if any Mapping exists or empty Workspace
       if [ -z "$list" ]
       then
          echo "Nothing to list, No Mapping configured for the Workspace."
       else
            printf "%15s - %s\n" "Mapping" "Status"
            for record in `grep -v "#" $g_map_cfg`; do
                mapName=`echo $record | cut -d"," -f1`
                mapStatus=`echo $record | cut -d"," -f2`
                printf "%15s - %s\n" "$mapName" "$mapStatus"
            done
       fi
    else
       # File not Present."
       echo "Nothing to list, No Mapping configuration found."
    fi
}

