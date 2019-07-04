#!/bin/bash
#############################################################################################################################
#  File Name   : sync.sh
#  Purpose     : This Script is the main Shell script.
#############################################################################################################################
# Import the required files
source ws.sh     

# Declare Parameters
l_operation="$1"
l_component="$2"
l_name="$3"
if [ -n "${l_operation}" ]
then
   if [ ${l_operation} = "add" -a ${l_operation} = "ws" ] 
   then
       add_ws $l_name
   fi
   
else
   echo "No value passed."
fi

