#!/bin/bash

function insertRecord() {
    ## $1 => tablename 
    ## $2 => record
    
    ## Append data into table 
    echo $2 >> $1
  
}

function checkContraint() {
    ## $1 => accept the user value
    ## $2 => accept the datatype
    ## $3 => accept pk
    ## $4 => accept init number to keep track num of column
    ## $5 => table name to insert data
    flag=0 
    ## check Column datatype
    if [[ $2 == "string" ]] 
    then
        ## check string datatype
        if ! [[ "$1" =~ ^[a-zA-Z[:space:]]+$ ]]
        then
             echo "Sorry the value must be string" 
             flag=1
        fi

    elif [[ $2 == "int" ]]
    then
        ## check int datatype  
        if ! [[ $1 =~ ^[0-9]+$ ]]  
        then 
            echo "Sorry the value must be int" 
            flag=1
        fi
        
    fi

    ## check primary key 
    
    if [[ $3 == "pk" ]]
    then

        ## read data from file to check if value exist
        while read line 
        do
            IFS=':' read -a tableValue <<< $line
            
            ## check if there are old value in table
            if [[ "${tableValue[$4]}" == "$1" ]]
            then
                echo "sorry this column is primary key and already exist in table "
                flag=1  
            fi
             
            
        done < $5
    fi
    
    return $flag


    
}

function readMetaData() {
    
    ## $1 => table name the user select 
    ## Get meta data for table and append to columns array
    IFS=$'\n' read  -d '' -a columns < "$1.meta"
    init=0;
    columnCount=${#columns[@]}
    columnName=""
    columnDatatype=""
    columnPK=""
    columnValue=""
    record=""
    
    
    ## make loop through each line in array
    while (( $init < $columnCount )) 
    do
        IFS=':'  read  columnName columnDatatype columnPK <<< ${columns[$init]}
        
        if ! [ -z $columnPK ] 
        then
            ## get data from user
            read -p "Enter $columnName($columnDatatype,$columnPK): " columnValue
        else
            read -p "Enter $columnName($columnDatatype): " columnValue
        fi
       
        
        ## call check constraint function
        checkContraint "$columnValue" "$columnDatatype" $columnPK $init $1
       
        ## if checkConstraint return 0 then value is valid
        if [ $? = 0 ] 
        then
            echo "this is first " $columnValue
            ## Append record data into array
            if [ $init = 0 ] 
            then 
                #echo "this is first $columnValue"
                record="$columnValue"
               
            else 
                record="$record:$columnValue"
            fi
            ((init = $init + 1))
            
        fi
        
    done

    ## call insert record function to insert data
    insertRecord $1 "$record"
   
    
}

function getTablename() {
    
    #list table
    source ./table/listtable.sh
    
    echo "Enter table name"
    read tableName
    #check if table exist
    if [ -f "$currentDatabase/$tableName" ]
    then
        selectedTable="$currentDatabase/$tableName"
        ## run function insert data
        readMetaData $selectedTable
    else
        echo 'sorry table you select not exist'
    fi
    
}



getTablename