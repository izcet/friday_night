#!/bin/bash

# Author: Isaac Rhett <isaacjrhett@gmail.com>
################################################################################

CONFIG="config"
if [ -f "$CONFIG" ] ; then
	source "$CONFIG"
else
	echo "Error: no config file located"
fi

if [ "$1" == "bulk" ] ; then
	NUM_OUTPUT=$BULK_OUTPUT
fi

REL_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
DATA="$REL_PATH/$DATA_DIR"
NUM_FILES="$(ls -1 $DATA | wc -l)"

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
	#RAND="$(($RANDOM % $1))"
	
	RAND="$(($(openssl rand 2 | od -DAn | tr -d '[:space:]') % $1))"
	RAND="$(increment $RAND)"
	echo "$RAND"
}

function get_file () {
	local FILE=""

	while [ ! -f "$DATA/$FILE" ] ; do
		local INDEX="$(get_rand "$NUM_FILES")"
		local FILE="$(ls -1 "$DATA" | head -n "$INDEX" | tail -n 1 )"

		if (( "$NO_META" )) && [ "$FILE" == "$META_FILE" ] ; then
			local FILE=""
		fi
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
	local DUP_FLAG=0
	local NOT_FLAG=0

	if (( "$IN_ORDER" )) ; then
		FIRST_FILE="$DATA/$(get_line "$REL_PATH/$FIRST")"
		STR="$(append "$STR" "$(get_line "$FIRST_FILE")")"
		NUM_OUTPUT="$(increment $NUM_OUTPUT)"
	fi

	while [ "$NUM_OUTPUT" -lt "$NUM_THINGS" ] ; do

		if (( "$NUM_OUTPUT" )) ; then
			STR="$(append "$STR" " and " )"
		fi

		NEXT_FILE="$DATA/$(get_file)"
		NEXT_LINE="$(get_line "$NEXT_FILE")"

		while [ "$NEXT_FILE" == "$DATA/$META_FILE" ] ; do
			case "$NEXT_LINE" in
				"end")
					STR="$(append "$STR" "nothing")"
					if (( "$NUM_OUTPUT" )) ; then
						STR="$(append "$STR" " else")"
					fi
					echo "$STR"
					return 
					;;
				"and")
					NUM_THINGS="$(increment "$NUM_THINGS")"
					;;
				"not")
					NOT_FLAG=1
					;;
				"dup")
					DUP_FLAG=1
					;;
				*)
					echo "{ERR: $NEXT_LINE is not valid in $META_FILE}"
					return
					;;
			esac
			NEXT_FILE="$DATA/$(get_file)"
			NEXT_LINE="$(get_line "$NEXT_FILE")"
		done
		if (( "$NOT_FLAG" )) ; then
			STR="$(append "$STR" "not ")"
			NOT_FLAG=0
		fi

		if [ "$NUM_OUTPUT" -eq "$(($NUM_THINGS - 1))" ] && (( "$IN_ORDER" )) ; then
			LAST_FILE="$DATA/$(get_line "$REL_PATH/$LAST")"
			STR="$(append "$STR" "$(get_line "$LAST_FILE")")"
			echo "$STR"
			return
		fi

		STR="$(append "$STR" "$NEXT_LINE")"
		NUM_OUTPUT="$(increment "$NUM_OUTPUT")"

		if (( "$DUP_FLAG" )) && [ "$NUM_OUTPUT" -lt "$(($NUM_THINGS - 1))" ] ; then
			STR="$(append "$STR and " "$NEXT_LINE")"
			NUM_OUTPUT="$(increment "$NUM_OUTPUT")"
			DUP_FLAG=0
		fi
	done

	echo "$STR"
}

I=0
while [ "$I" -lt "$NUM_OUTPUT" ] ; do
	main
	I=$(($I + 1))
done

