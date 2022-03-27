#!/bin/bash
#!/bin/bash
function deleteTable() {
    ## read from user databasename
    echo "Enter table name"
    read tableName
    if [ -f "$currentDatabase/$tableName" ]
    then
        read -p "Are you sure you want to delete $tableName:(y|n):" confirm
        ## Check user answer
        case $confirm in 
            "y"|"Y") 
            rm  {$currentDatabase/$tableName,"$currentDatabase/$tableName.meta"} ;;
        esac       
    
    else
        echo "database not found"
    fi
}
deleteTable
