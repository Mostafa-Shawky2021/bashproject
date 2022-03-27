#!/bin/bash

function selectDatabase() {
    source ./listdatabase.sh
    printf "\nEnter database name\n"
    read databaseName
    currentDatabase=$databasePath/$databaseName
    if [ -d $currentDatabase ]
    then
        PS3="$databaseName >> "
        printf "Database $databaseName selected\n\n"
        
     
        # show table menu in this database
        databaseMenu

    else
        echo "Database not found"
    fi

}
function databaseMenu() {
    databaseOptions=("Create table" "List table" "Drop table" "Insert Data" "Select table" "Delete from table" "Updata table", "Quit")
    ## while loop is to show the list repeatly
    while [[ true ]]
    do
        select option in "${databaseOptions[@]}"
        do
            case $option in 
                "Create table") source ./table/createtable.sh
                 break
                  ;;    
                "List table") source ./table/listtable.sh 
                 break
                  ;; 
                "Drop table") source ./table/droptable.sh
                 break 
                  ;; 
                "Insert Data") source ./table/inserttable.sh 
                 break 
                ;; 
                "Select table") source ./table/selecttable.sh 
                 break 
                 ;;  
                "Delete from table") source ./table/deletefromtable.sh  
                 break 
                 ;; 
                "Quit") exit
            esac
        done 
    done
}
selectDatabase