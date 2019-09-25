# Overview
In many scenarios we need to pull the Files from the various other servers. :computer:
For Instance in Telecommunication sector Event Record (ER) files are the log files having all the event details like CALL, SMS, Data details. 
The ER files are generated at a given interval of time or triggered by an event. These files are generated in a remote server and were pulled via Secure Transfer to another central server( Data-warehouse ) for Loading of Information or processing. 

**ERSFTPSYNC** works with the SFTP Protocol and requires a passwordless connection established between Remote Host and Destination Server.

# Terminologies
**Workspace**  
A workspace is a collection of Mappings, the mappings can be grouped into a Workspaces based on a Host server or a specific geography. A workspace directory will be created in ~/.erlftpsync folder for each workspace.


**Mapping**  
A mapping is a record having details to fetch the files from Remote to Host server and requires below information.
1. Remote Host IP address
2. SFTP UserName 
3. Remote server directory
4. Local Destination directory
5. Filter - File Pattern e.g.<br> 
    * Single pattern : *.log 
    * Multiple patterns : *.log *.md

*User will be prompted to enter the Workspace and other required details*
For each mapping a folder will be created inside the respective workspace directory having the mapping information, session transfer log files along with a temp directory to place downloaded files temporarily.  


Below is the hierarchy of files and folders. 
```
~/.ersftpsync
    ├── ws.cfg
    ├── Workspace1
    │   ├── mapping1
    │       ├──mapping1.cfg 
    │       ├──tmp 
    │   └── mapping2    
    │       ├──mapping2.cfg
    │       ├──tmp
    ├── Workspace2
    │   ├── mapping1    
    │       ├──mapping1.cfg
    │       ├──tmp
    │   ├── mapping2  
    │       ├──mapping2.cfg
    │       ├──tmp
    │   └── mapping3  
    │       ├──mapping3.cfg
    │       ├──tmp
```
+ .ersftpsync :arrow_forward: Main Configuration directory
+ ws.cfg :arrow_forward: Workspace Configuration File
+ <mapping>.cfg :arrow_forward: Mapping Configuration File)
+ tmp :arrow_forward: Temporary directory to save partial downloaded file
### Usecase
Consider a Scenario where you have 3 remote servers(x,y,z) from where files are to pulled. You have different remote directories in each server from where files are to be pulled. Consider you have 10 unique directories in each host server from where you want to pull the files. From each directory you have to pull different kind of files. So you can create 3 Workspaces (WS1, WS2, WS3) having 10 mapping(M1...M10) each and then you can create Filters to specify the naming conventions of the files you want to pull. If you want to pull all the files from a Mapping you don't need to create any filter for that.
Suppose you want to pull all *.log files from Mapping M1 of WS1 then you can make an entry in filter 

# Usage
Run install.sh to setup the Utility. It will create a configuration folder in your home directory ~/.erlftpsync

Once configuration folder has been setup you can create new Workspace and Mappings.
### Workspace commands
```sh
sync.sh list --ws                           # List all Workspaces
sync.sh add --ws "<Workspace Name>"         # Add a new workspace
sync.sh rm --ws "<Workspace Name>"          # Delete a workspace
sync.sh disable --ws "<Workspace Name>"     # Disable a workspace
sync.sh enable --ws "<Workspace Name>"      # Enable a disabled workspace
sync.sh run --ws "<Workspace Name>"         # Run all Mappings of the workspace
```

### Mapping commands
```sh
sync.sh list --map "<Workspace>"                            # List all Mapping
sync.sh add --map "<Workspace>"                             # Add a new Mapping
sync.sh rm --map "<Workspace>" "Mapping_Code"               # Delete a mapping
sync.sh disable --map "<Workspace Name>" "Mapping_Code"     # Disable a Mapping in the workspace
sync.sh enable --map "<Workspace Name>" "Mapping_Code"      # Enable a disabled Mapping in the workspace
sync.sh run --ws "<Workspace Name>" "Mapping_Code"          # Run a Mappings in the workspace
```