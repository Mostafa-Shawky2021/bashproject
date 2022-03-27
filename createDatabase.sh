#!/bin/bash

function createDatabase() {

    echo "Enter database name"
    read newDatabase
    ## check if database empty
    if [ -z "$newDatabase" ]
    then
        echo "Sorry database cannot be empty"
    ## Check if contain strange character
    elif [[ "$newDatabase" =~ [\&^%@\*\(\)] ]]
    then
        echo "Sorry database name must be valid"

    ## Check if database exist
    elif [ -d "$databasePath/$newDatabase" ] 
    then 
        echo "Sorry database already exist"
    else   
        mkdir $databasePath/$newDatabase
    fi
}

createDatabase



