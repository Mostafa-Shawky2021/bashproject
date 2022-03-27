#!/bin/bash
function validate(){

    ## check if empty 
    if [ -z $2 ] 
    then 
        echo "$1 can not be empty choose another option"
        return 1
    ## check if contain special character
    elif [[ "$2" =~ [\&^%@\*\(\)] ]] 
    then 
        echo "$1 must be valid choose another option"
        return 1
    ## check if contain digits
    elif [[ "$2" =~ [0-9] ]]
    then
        echo "$1 must only string value choose another option"
        return 1
    fi
    return 0
}


function createColumn() {
    metaData=""
    init=0
    pkStatus="false"
    read -p "Plz enter number of column:" colNum
    ## Check if number of column is integer
    if [[ $colNum =~ ^[1-9]+$ ]] 
    then
        
        while (( $init < $colNum )) 
        do
            ## reset metadata var
            metaData=""
            echo "Enter columnName"
            read colName
           
            ## run function valdiate to validate column
            validate "column" $colName

             # valid column name
            if [ $? = 0 ]
            then
                
                ## get datatype of column
                ## Append column name to metadata var
                metaData="$colName" 
                read -p "Enter column datatype String(s) Number(N):(s\n)" colDatatype
                ## get data type of column
                if [[ "$colDatatype" = "s" || "$colDatatype" = "S" ]] 
                then
                    init=$((init+1))
                    ## Append column meta data to varaible
                    metaData="$metaData:string"
              
                elif [[ "$colDatatype" = "n" || "$colDatatype" = "N" ]]
                then
                    init=$((init+1))
                    metaData="$metaData:int"
                  
                else
                    ## if there is error in datatype skip this this step
                    echo "Plz enter valid datatype"
                    continue
                fi

                ## Check if user dosen't enter pk field
                if [ "$pkStatus" == false ] 
                then
                    ## Ask for priamry key
                    read -p "IsColumn pk?:yes(y) no(n):" pk 
                    if [[ "$pk" = "y" || "$pk" = "Y" ]]
                    then
                        
                        metaData="$metaData:pk"
                        pkStatus="true"
                    fi
                fi     
            else
             ## not valid columnname
             echo "Enter valid columnName"
            fi
            ## if there is no error append this meta data to meta table file
            echo $metaData >> "$currentDatabase/$1.meta"
        done
    
    ## not valid number of columns
    else 
        echo "Enter valid number"
    fi

}

function createTable() {
    
    echo "Enter table name:"   
    read tableName 

    validate "table" $tableName

    ## no problem in validation 
    if [ $? = 0 ]
    then
        ## check if table exist
        if [ -f "$currentDatabase/$tableName.meta" ] 
        then
            echo "Sorry table already exist"
        else 
            echo "table create succefully"
            touch $currentDatabase/{$tableName.meta,$tableName} 
            
            ## Create table columns
            createColumn $tableName 
        fi
    fi
    
}


createTable




