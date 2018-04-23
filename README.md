# Overview
In many scenarios we need to pull the Files from the various other servers. 
For Instance in Telecommunication sector Event Record (ER) files are the log files having all the event details like CALL, SMS, Data details. 
The ER files are generated at a given interval of time or triggered by an event. These files are generated in a remote server and were pulled via Secure Transfer to another central server( Data-warehouse ) for Loading of Information or processing. 

ERLFTPSYNC uses LFTP Utility to pull the log files from the remote server to the Data-warehouse server.

#Terminology
Workspace - A workspace is collection of Mappings, the mappings can be grouped into a Workspaces based on Host server or a specific geography.
Mapping - A mapping is a record having information such as Remote Host IP address, UserName, password, Remote server directory, Local directory
Filters - A Filter is a file naming convention or pattern which will be pulled from the remote server(in a directory). 

Below is the hierarchy defined. 
Workspace --> Mapping --> Filter

Consider a Scenario where you have 3 remote servers(x,y,z) from where files are to pulled. You have different remote directories in each server from where files are to be pulled. Consider you have 10 unique directories in each host server from where you want to pull the files. From each directory you have to pull different kind of files. So you can create 3 Workspaces (WS1, WS2, WS3) having 10 mapping(M1...M10) each and then you can create Filters to specify the naming conventions of the files you want to pull. If you want to pull all the files from a Mapping you don't need to create any filter for that.
Suppose you want to pull all *.log files from Mapping M1 of WS1 then you can make an entry in filter 

#Usage
Run install.sh to setup the Utility. It will create a configuration folder in your home directory ~/.erlftpsync
Once configuration folder has been setup you can create Workspace


                