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

# Function to return Invalid Workspace message
function invalid_ws_msg() {
    echo "$1 : Workspace does not exists. Please refer $g_ws_cfg file to view existing Workspaces."
}

# Function to return Invalid Workspace message
function valid_ws_msg() {
    echo "$1 : Workspace already $g_ws_status. Please refer $g_ws_cfg file to view existing Workspaces."
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

# Function to add Workspace
function add_ws(){
    # Check if Workspace name is passed, if not then ask user
    l_ws=$1
    if [ -z "$l_ws" ]; then
        l_ws=$( uread "Enter Workspace to Add : " )
    fi

    # Check if Workspace already exists
    if [ "$( get_ws_status $l_ws )" != 'INVALID' ]; then # Display error if WorkSpcae already present
        echo "$l_ws : Workspace already exists. Please refer $g_ws_cfg file to view existing Workspaces."
    else # Add new WorkSpcae
        # If folder already exists display issue
        if [ -d "$g_cfg_dir/$l_ws" ]
        then
            echo "Workspace Directory already present but missing in Configuration file."
        else
            mkdir $g_cfg_dir/$l_ws
            chmod 755 $g_cfg_dir/$l_ws
        fi

        # Make configuration entry
        echo "$l_ws,ENABLED">>$g_ws_cfg
        sort $g_ws_cfg | uniq > $g_ws_cfg_test
        mv $g_ws_cfg_test $g_ws_cfg
        # Create  mapping file for new Workspace
        create_map_cfg "$g_cfg_dir/$l_ws/mapping.cfg"
        echo "$l_ws : Workspace created Successfully."
    fi
}

# Function to delete a Workspace
function delete_ws(){
    # Check if Workspace name is passed, if not then ask user
    l_ws=$1
    if [ -z "$l_ws" ]; then
        l_ws=$( uread "Enter Workspace Name to Delete : " )
    fi

    # Check if Workspace already exists
    if [ "$( get_ws_status $l_ws )" != "INVALID" ]; then
        # Delete the folder for Workspace
        rm -r "$g_cfg_dir/$l_ws"
        # Check the command status
        # Delete entry form Workspace configuration file
        grep -iwv  "$l_ws" $g_ws_cfg > ${g_ws_cfg_test}
        mv $g_ws_cfg_test $g_ws_cfg
        echo "$l_ws : WorkSpcae deleted Successfully."
    else # Add new WorkSpcae
        invalid_ws_msg $l_ws 
    fi
}

# Function to disable a Workspace
function disable_ws(){
    l_ws=$1
    if [ -z "$l_ws" ]; then
        l_ws=$( uread "Enter Workspace Name to Disable : " )
    fi

    # Set WorkSpcae status
    set_ws_status $l_ws
    if [ "$g_ws_status" = "ENABLED" ]; then # Disable WorkSpcae
        # Rename the Workspace folder with Disabled added
        mv "$g_cfg_dir/$l_ws" "$g_cfg_dir/${l_ws}-DISABLED"
        # Check the command status
        if [ $? -eq 0 ] 
        then
            # Comment entry form WorkSpcae configuration file 
            grep -iwv  "$l_ws" $g_ws_cfg > ${g_ws_cfg_test}
            echo "$l_ws,DISABLED">>${g_ws_cfg_test}
            mv $g_ws_cfg_test $g_ws_cfg
        fi
        echo "$l_ws : Workspace Disabled Successfully."
    elif [ "$g_ws_status" = "DISABLED" ]; then
        valid_ws_msg $l_ws
    else 
        invalid_ws_msg $l_ws
    fi
}

# Function to enable a Workspace
function enable_ws(){
    l_ws=$1
    if [ -z "$l_ws" ]; then
        l_ws=$( uread "Enter Workspace Name to Enable : " )
    fi

    # Set WorkSpcae status
    set_ws_status $l_ws
    if [ "$g_ws_status" = "ENABLED" ]; then # Disable WorkSpcae
        valid_ws_msg $l_ws
    elif [ "$g_ws_status" = "DISABLED" ]; then
        # Rename the Workspace folder with Disabled added
        mv "$g_cfg_dir/$l_ws-DISABLED" "$g_cfg_dir/${l_ws}"
        # Check the command status
        if [ $? -eq 0 ] 
        then
            # Comment entry form WorkSpcae configuration file
            grep -ivw  "$l_ws" $g_ws_cfg > ${g_ws_cfg_test}
            echo "$l_ws,ENABLED">>${g_ws_cfg_test}
            mv $g_ws_cfg_test $g_ws_cfg
        fi
        echo "$l_ws : WorkSpcae Enabled Successfully" 
    else 
        invalid_ws_msg $l_ws 
    fi
}
