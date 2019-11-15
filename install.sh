#!/bin/bash
# -- ############################################################################
# -- #      Copyright (C) 2018-2019 Vivek Kumar <vivekkumar.xda@gmail.com>      #               #
# -- #                All rights reserved.                                      #
# -- #              Proprietary and confidential                                #
# -- # Unauthorized copying of this file, via any medium is strictly prohibited #
# -- ############################################################################
# -- #
# -- # Project          : erlftpsync
# -- # Application      : erlftpsync
# -- # File Name        : install.sh
# -- # Exec Method      : Linux Shell Script
# -- # Description      : Project Installation Script
# -- #
# -- # Change History
# -- # -----------------------------------------------------------------------
# -- # Version     Date             Author           Remarks
# -- # =======  ===========     =============    ============================
# -- # 1.0      25-Aug-2019     Vivek Kumar        Initial Version
# -- #
# -- ############################################################################

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
