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
    init_map $1
    #echo "Checking if file exists ... $g_map_cfg"
    if [ -f "$g_map_cfg" ]; then
       # File exists
       list=`awk -F"," '{ if($0 !~ /#/) print $1 }' "$g_map_cfg"`
       # Check if any Mapping exists or empty Workspace
       if [ -z "$list" ]
       then
          echo "Nothing to list, No Mapping configured for the Workspace."
       else
            printf "%15s - %8s - %20s - %30s - %30s\n" "Mapping" "Status" "Host"  "Remote Directory" "Local Directory"
            for record in `grep -v "#" $g_map_cfg`; do
                mapName=`echo $record | cut -d"," -f1`
                mapStatus=`echo $record | cut -d"," -f2`
                mapHost=`echo $record | cut -d"," -f3`
                mapRemoteDir=`echo $record | cut -d"," -f4`
                mapLocalDir=`echo $record | cut -d"," -f5`
                printf "%15s - %8s - %20s - %30s - %30s\n" "$mapName" "$mapStatus" "$mapHost" "$mapRemoteDir" "$mapLocalDir"
            done
       fi
    else
       # File not Present."
       echo "Nothing to list, No Mapping configuration found."
    fi
}

# Function to get new mapping Id
# Format : <Workspace>_map_<id>
function get_mapping_id() {
    # Check the highest mapping id availabe
    max_id=`grep -v "#" $g_map_cfg | cut -d "," -f1 | cut -d "_" -f3 | uniq | sort -nr | head -n1| tr -s " "`
    if [ -z "$max_id" ]
    then
       max_id=1
    else
       max_id=$[max_id+1]
    fi
    echo "${g_map_ws}_MAP_$max_id"
}

# Function to check the existence of a Mapping Id
function get_map_id_status(){
    l_map_id=$( get_upper "$1" ) # Mapping
    l_map_status=`grep -iw "$l_map_id" "${g_map_cfg}" | cut -d"," -f2`
    if [ -z "$l_map_status" ]
    then
       l_map_status='INVALID'
    fi
    # Return value
    echo $l_map_status
}

# Function to return the mapping status based on attributes
# 1. Host 2. Remote Directory 3. Local Directory
function get_map_status() {
    l_map_status=""
    list=`grep -iw "$1,$2,$3" $g_map_cfg`

    if [ -z "$list" ]; then # if no value retrieved
       l_map_status='INVALID'
    else
       # get the status
       l_map_status=`echo $list| cut -d "," -f2`
    fi
    echo $l_map_status
}

# Function to add new Mapping
function add_mapping() {
    init_map $1
    echo "Mapping Workspace directory : $g_map_ws_dir"
    l_host=$( uread "Enter host" )                          # Host
    l_remote_dir=$( uread "Enter Remote directory" )        # Remote Directory
    l_local_dir=$( uread "Enter Local directory" )          # Local Directory
    l_user=$( uread "Enter Host User" )                     # Host Password
    l_pass=$( uread "Enter Host Password" )                 # Host Password

    # Check if Mapping attributes already exists
    echo "Checking Mapping attributes for $l_host,$l_remote_dir,$l_local_dir"
    #get_map_status $l_host $l_remote_dir $l_local_dir
    if [ "$( get_map_status $l_host $l_remote_dir $l_local_dir )" = "INVALID" ] # Add the new mapping
    then
        # Generate the mapping id
        l_map_id=$( get_mapping_id )
        g_map_dir="$g_map_ws_dir/$l_map_id"

        # Check if Directory exists
        if [ -d "$g_map_dir" ]
        then
           echo "$l_map_id : Mapping Directory already present but missing in Configuration file."
        else
           # Directory does not exists # Create mapping directory
           mkdir $g_map_dir
           chmod 755 $g_map_dir
        fi

        # Make entry in mapping.sh
        echo "$l_map_id,ENABLED,$l_host,$l_remote_dir,$l_local_dir,$l_user,$l_pass">>$g_map_cfg
        sort $g_map_cfg | uniq > $g_map_cfg_tmp
        mv $g_map_cfg_tmp $g_map_cfg
        echo "$l_map_id : New mapping added Successfully."
    else # Display error if Mapping already present
       echo "Mapping already exists, Please list to view the existing mappings and its attributes."
    fi
}

