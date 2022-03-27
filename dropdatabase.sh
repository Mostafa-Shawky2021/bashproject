#!/bin/bash
function deleteDb() {
    ## read from user databasename
    echo "Enter database name"
    read databaseName
    if [ -d $databasePath/$databaseName ]
    then
        read -p "Are you sure you want to delete $databaseName:(y|n):" confirm
        ## Check user answer
        case $confirm in 
            "y"|"Y") rm -r $databasePath/$databaseName ;;
        esac       
    
    else
        echo "database not found"
    fi
}
deleteDb
