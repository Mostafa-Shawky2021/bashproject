## TODO
## when user choose select all and not table fount return to table menu again
## user can show data with more than one column

function checkTableexit() {
    ## $1 => table to check if exist or not
    if ! [ -f $currentDatabase/$1 ] 
    then
        echo "Sorry this table not exist"
        return 1
    fi
     
}
function checkColumnexit() {
    ## $1 => tablename 
    ## $2 => column name

    ## get metadata to compare it with user column
    columns=($( awk -F ':' '{ print $1 }' "$1"  ))

    for column in ${columns[@]} 
    do
        #echo "column in array $column || and this is $2 passed"
         if  [[ "$column" == "$2" ]]
         then 
            return 0
         fi
           
    done  
      return 1
}
function selectBycolumn() {
    
    #list table
    source ./table/listtable.sh
    ## if no table exist terminate select all function
    if [ $? = 1 ]; then return; fi
    
    ## get table name
    echo "Plz enter table name"
    read tableName

    ## check if table exist
    checkTableexit $tableName

    ## if function return 1 then table not exist terminte function
    if [ $? = 1 ] ; then return ; fi 

    ## show exists column  so user can select with column name
    awk -F ':' ' BEGIN { printf "======================================\nthe column in this table\n" }  { printf $1 " " } END { printf "\n===========================\n" }'  "$currentDatabase/$tableName.meta"

    ## get column name
    echo "Plz enter column name"
    read columnName
    
    ## call function to check if the column is exist
    checkColumnexit $currentDatabase/$tableName.meta $columnName    

    ## if column not found in table
    if [ $? != 0 ] 
    then 
        echo "sorry column not found" 
        return
    fi

    ## read line in table meta data
    IFS=$'\n' read -d '' -a lines < $currentDatabase/$tableName.meta
    
    ## extract columns name and append them into array
    columns=( $( awk -F ':' '{ print $1 }' "$currentDatabase/$tableName.meta" )) 

    ## get column index to print required field 
    for columnIndex in ${!columns[@]} ## => this get the index for each element in array
    do
        if [[ ${columns[$columnIndex]} == "$columnName" ]]
        then
            index=$columnIndex
            break
        fi
    done
    
        printf "\n=================================\n"
        printf "%-2s $columnName"
        printf "\n=================================\n"
    
    ## read data from table 
    while IFS=":" read -a tableData
    do
     
        printf "%-2s ${tableData[$index]} \n"
    done < $currentDatabase/$tableName
        printf "=================================\n"

}

function selectAll() {

    #list table
    source ./table/listtable.sh

    ## if no table exist terminate select all function
    if [ $? = 1 ]; then return; fi
    echo "Plz enter table name"
    read tableName

    ## check if table exist
    checkTableexit $tableName
    
    ## if function return 1 then table not exist terminte function
    if [ $? = 1 ] ; then return ; fi 
  
    ## read column metadata
    awk -F ':' 'BEGIN {
                         ORS="";
                         printf "==============================================================\n" 
                      } 
                      { 
                          
                          printf "\t%-22s",$1
                      }
                 END {
                          printf "\n==============================================================\n" 
                      }
                      ' "$currentDatabase/$tableName.meta"
    printf "\n"

    ## read table data
    IFS=$'\n' read -d '' -a lines < "$currentDatabase/$tableName"

    for ((line = 0; line < ${#lines[@]}; line++)); do
        IFS=":" read -a columns <<< ${lines[$line]}

        for ((column = 0; column < ${#columns[@]}; column++)); do

            printf "\t%-22s" "${columns[$column]}"
        done
        printf "\n"
    done

}

function showSelectedmenu() {

    selectMenu=("select all" "select by column" "table menu")
    while [[ true ]]; do
        ## show select menu list
        select menu in "${selectMenu[@]}"; do
            case $menu in
            ## call select all function
            "select all")
                selectAll
                break
                ;;
            "select by column") 
                selectBycolumn
                 break
                 ;;
                ## skip to loop to get table menu
            "table menu") break 2 ;;
            esac
        done

    done
}

showSelectedmenu
