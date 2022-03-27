### Main script
### Show database menu

## variables
PS3="Choose option>> "
databasePath="./database"
## check if there exist database folder 

## Functions
function checkDatabasefolder() {
    if [ ! -d database ] ; then mkdir database ;fi
    
}

function showDbmenu() {
    menuOption=("List database" "Create database" "Connect to database" "Drop database" "Quit")
    while [[ $menu != "Quit"  ]]
    do
        select menu in "${menuOption[@]}"
        do 
            case $menu in 

                "List database") source ./listdatabase.sh  
                break 
                ;;
                
                "Create database") source ./createDatabase.sh
                break
                ;;

                "Connect to database") source ./connectDatabase.sh
                break
                ;;

                "Drop database") source ./dropdatabase.sh
                break
                ;;

                "Quit") exit
                ;;

                *) echo "invalid choose"

            esac
        done
    done
}

checkDatabasefolder;
showDbmenu;

