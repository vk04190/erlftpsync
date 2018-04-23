#!/bin/bash
#############################################################################################################################
#  File Name   : utility.sh
#  Purpose     : This Script contains all the utility functions. 
#
#############################################################################################################################
# Declare the File Headers
g_mapping_file_hdr="# Configuration file for Mapping, Script will refer this configuration file to know all the mappings in a Workspace
# To disable a Mapping comment it, add Hash at the starting of the line
# Mapping id,Status,Host,Remote Directory,Local Directory,UserName,Password
"
g_ws_cfg_file_hdr="# Configuration file for Workspace, Script will refer this
# To disable a Workspace comment it, add Hash at the starting of the line
"

# Valid ga_operations
declare -a ga_operations=('LIST' 'ADD' 'DELETE'  'ENABLE' 'DISABLE' 'EDIT');

# This function will return the passed string in UPPERCASE form
function get_upper() {
    echo `echo $1 | tr '[:lower:]' '[:upper:]'`
}

# This function will take a value from user and will return in UPPERCASE form
function uread(){
    read -p "$1 : " value 
    echo `echo $value | tr '[:lower:]' '[:upper:]'`  
}

# This function will check if passed value is a valid Operation
function check_valid_opr() {
    status=""
    for value in "${ga_operations[@]}"
    do
        if [ "$value" = "$1" ]; then
            status="0"
        fi
    done

    # Check if status is assigned
    if [ -z "$status" ]
    then
       echo "$1 : Invalid Operation, should be in [ ${ga_operations[@]}" ]
       exit 1
    fi
}

# Function to return Invalid Workspace message
function invalid_ws() {
    echo "$1 : Workspace does not exists. Please refer $2 file to view existing Workspaces."
}
