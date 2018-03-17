#!/bin/bash



################################################################################
## USER VARIABLES ##

# Remove or set a file hidden to exclude it from the list
#   active_file
#   .deactivated

# Comment out a line of a file to exclude a specific entry
#   activity1
#   #activity2

NUM_THINGS=2  # Increase this to have longer sentences

USE_META=1  # Set this to 0 to remove the meta effects

ALLOW_DUPE=0  # Set to 1 to add duplicate lines (and skew the odds)




################################################################################
## CONSTANTS ##

REL_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
DATA_DIR="data"
DATA="$REL_PATH/$DATA_DIR"
NUM_FILES=$(ls -1 $DATA | wc -l)



################################################################################
## ERROR CHECKS ##

if [ "$NUM_FILES" -eq "0" ] ; then
    echo "Error: no data files in '$DATA'"
    exit 1
fi



################################################################################
## FUNCTION DEFINITIONS

function get_rand () {
    echo "$(($(($RANDOM % $1)) + 1))"
}

function get_file () {
    INDEX="$(get_rand "$NUM_FILES")"
    FILE=$(ls -1 $DATA | head -n $INDEX | tail -n 1 )

    echo "$FILE"
}

function get_line () {
    FILE=$DATA/$1
    WORDS="$(cat $FILE | grep -v "^\s*#")"
    if [ "$ALLOW_DUPE" -eq "0" ] ; then
        WORDS="$(echo "$WORDS" | sed 's/ /\n/g' | sort | uniq)"
    fi
    NUM_WORDS=$(echo $WORDS | sed 's/ /\n/g' | wc -l)
    INDEX="$(get_rand $NUM_WORDS)"
    echo "$(cat "$FILE" | head -n "$INDEX" | tail -n 1)"
}



################################################################################
## CODE ##

if [ "$1" == "bulk" ] ; then
    I=0
    while [ "$I" -lt "9" ] ; do
        echo "$(get_line $(get_file)) and $(get_line $(get_file))"
        I=$(($I + 1))
    done
fi

echo "$(get_line $(get_file)) and $(get_line $(get_file))"

