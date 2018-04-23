#!/bin/bash

#############################################################################################################################
#  File Name   : install.sh
#  Purpose     : This script will create the required the folders in the home directory of user. 
#                Subsequent folders will be created where required configuration files will be stored. 
#############################################################################################################################
# Import the required files
source ws.sh

#Create the Market folder 
create_ws_dir
# Check the command status
if [ $? -ne 0 ] 
then
    exit 1
fi

#create the configuration file
create_ws_cfg
