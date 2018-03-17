#!/bin/bash

## USER VARIABLES ##

# Remove or set a file hidden to exclude it from the list
#   active_file
#   .deactivated

# Comment out a line of a file to exclude a specific entry
#   activity1
#   #activity2

# Increase this to have longer sentences
NUM_THINGS=2

# Set this to 0 to remove the meta effects
USE_META=1

# Set to 1 to add duplicate lines (and skew the odds)
ALLOW_DUPE=0

## CONSTANTS ##

REL_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
DATA_DIR="data"
DATA="$REL_PATH/$DATA_DIR"
NUM_FILES=$(ls -1 $DATA | wc -l)

## ERROR CHECKS ##

if [ "$NUM_FILES" -eq "0" ] ; then
    echo "Error: no data files in '$DATA'"
    exit 1
fi


## FUNCTION DEFINITIONS

function get_file () {
    INDEX=$(($(($RANDOM % $NUM_FILES)) + 1))
    FILE=$(ls -1 $DATA | head -n $INDEX | tail -n 1

   echo "$FILE"
}

function get_line () {
    FILE=$1
    WORDS="$(cat $FILE | grep -v "^\s*#")"
    if [ "$ALLOW_DUPE" -eq "0" ] ; then
        WORDS="$(echo "$WORDS" | sort | uniq)"
    fi
    NUM_WORDS=$(echo $WORDS | 


}

## CODE ##




function getLine () {
	DOC=$1
	LEN=$(wc -l $DOC | sed 's/ *//' | cut -d' ' -f1)
	RND=$(($(($RANDOM % $LEN)) + 1))
	if [ $# -gt 1 ] ; then
		if [ $(($RND % 2)) -eq 0 ] ; then
			END="?"
		else
			END="."
		fi
		echo -n "$END#"
	fi
	TXT=$(head -n $RND $DOC | tail -1)
	echo $TXT
}


SRCS=txts
OPEN="1_opener.txt"
PLAT="2_platform.txt"
TRAN="3_transition.txt"
VERB="4_action.txt"
SUBJ="5_subject.txt"

UNO=$SRCS/$OPEN
DOS=$SRCS/$PLAT
TRE=$SRCS/$TRAN
QUA=$SRCS/$VERB
CIN=$SRCS/$SUBJ

END=""


UNO=$(getLine $UNO "1")
DOS=$(getLine $DOS)
TRE=$(getLine $TRE)
QUA=$(getLine $QUA)
CIN=$(getLine $CIN)

END=$(echo $UNO | cut -d'#' -f1)
UNO=$(echo $UNO | cut -d'#' -f2-)

echo "$UNO $DOS $TRE $QUA $CIN$END"
