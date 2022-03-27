#!/bin/bash
function listTable(){
    if [[ $(ls $currentDatabase) ]]
    then
        echo "========================"
        echo "Table list"
        echo "========================"
        
        for table in $(ls $currentDatabase)
        do
            if [[ $table =~ ^[A-Za-z]+$ ]]
            then
                
                echo "$table"
            fi
        done;
        echo "========================"
    else 
        echo "========================"
        echo "Sorry no table found"
        echo "========================"
        return 1
    fi
}
listTable