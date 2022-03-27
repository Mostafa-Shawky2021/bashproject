#!/bin/bash
function listDatabae()
{
    if [[ $(ls $databasePath) ]] 
    then
       echo "Database list"
       echo "======================================"
       for databs in $(ls $databasePath)
       do
            echo $databs
       done
       echo "======================================"

     
    else 
        echo "no database found" 
    fi
}
listDatabae


