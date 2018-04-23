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

# This function will return the passed string in UPPERCASE form
function get_upper() {
    echo `echo $1 | tr '[:lower:]' '[:upper:]'`
}

# This function will take a value from user and will return in UPPERCASE form
function uread(){
    read -p "$1 : " value 
    echo `echo $value | tr '[:lower:]' '[:upper:]'`  
}

