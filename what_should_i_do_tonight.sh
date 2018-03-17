#!/bin/bash

# Author: Isaac Rhett <isaacjrhett@gmail.com>
################################################################################
## USER VARIABLES ##

# Remove or set a file hidden to exclude it from the list
#   active_file
#   .deactivated

# Comment out a line of a file to exclude a specific entry
#   activity1
#   #activity2

NUM_THINGS=2  # Increase this to have longer sentences

ALLOW_DUPE=0  # Set to 1 to add duplicate lines (and skew the odds)

USE_META=1  # Set this to 0 to remove the meta effects

IN_ORDER=1  # Set to 1 to force usage of 'start' and 'end'.
# Otherwise order is random in addition to constants.

NUM_OUTPUT=1  # Only print out one humorous line

# But if you so choose, use the "bulk parameter"
if [ "$1" == "bulk" ] ; then

	# You're going to have a lot of options
	NUM_OUTPUT=10
fi


################################################################################
## CONSTANTS ##

REL_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
FIRST="first"
LAST="last"
DATA_DIR="data"

DATA="$REL_PATH/$DATA_DIR"
NUM_FILES="$(ls -1 $DATA | wc -l)"


################################################################################
## ERROR CHECKS ##

if [ "$NUM_FILES" -eq "0" ] ; then
	echo "Error: no data files in '$DATA'"
	exit 1
fi


################################################################################
## FUNCTION DEFINITIONS

function increment () {
	echo "$(($1 + 1))"
}

function get_rand () {
	RAND="$(($RANDOM % $1))"
	RAND="$(increment $RAND)"
	echo "$RAND"
}

function get_file () {
	FILE=""

	while [ ! -f "$DATA/$FILE" ] ; do
		local INDEX="$(get_rand "$NUM_FILES")"
		local  FILE="$DATA/$(ls -1 "$DATA" | head -n "$INDEX" | tail -n 1 )"
	done
	echo "$FILE"
}

function get_line () {
	local FILE="$1"

	local WORDS="$(cat "$FILE" | grep -v "^\s*#")"
	if [ "$ALLOW_DUPE" -eq "0" ] ; then
		WORDS="$(echo "$WORDS" | sed 's/ /\n/g' | sort | uniq)"
	fi

	local NUM_WORDS="$(echo "$WORDS" | sed 's/ /\n/g' | wc -l)"
	local INDEX="$(get_rand $NUM_WORDS)"

	echo "$(cat "$FILE" | head -n "$INDEX" | tail -n 1)"
}

function append () {
	local STR="$1"
	local NEW="$2"

	echo "$STR$NEW"
}

################################################################################
## CODE ##

function main () {
	local NUM_OUTPUT=0
	local STR=""

	if (( "$IN_ORDER" )) ; then
		FIRST_FILE="$DATA/$(get_line "$REL_PATH/$FIRST")"
		STR="$(append "$STR" "$(get_line "$FIRST_FILE")")"
		NUM_OUTPUT="$(increment $NUM_OUTPUT)"
	fi

	while [ "$NUM_OUTPUT" -lt "$NUM_THINGS" ] ; do
		if (( "$NUM_OUTPUT" )) ; then
			STR="$(append "$STR" " and " )"
		fi

		if [ "$NUM_OUTPUT" -eq "$(($NUM_THINGS - 1))" ] && (( "$IN_ORDER" )) ; then
			LAST_FILE="$DATA/$(get_line "$REL_PATH/$LAST")"
			STR="$(append "$STR" "$(get_line "$LAST_FILE")")"
			echo "$STR"
			return
		else
			STR="$(append "$STR" "$(get_line "$(get_file)")")"
			NUM_OUTPUT="$(increment $NUM_OUTPUT)"
		fi
	done

	echo "$STR"
}

I=0
while [ "$I" -lt "$NUM_OUTPUT" ] ; do
	main
	I=$(($I + 1))
done

