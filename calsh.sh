#!/bin/bash

function is_whole_num {
    # Returns zero if argument has only digits
    # Otherwise non-zero value is returned
    if (( "$#" == 0 ))
    then
        echo "Error: is_whole_num (function): No arguments" >&2
        return 1
    fi

    case "$1" in
        ("" | *[!0-9]*)
            return 1
    esac
    return 0
}

function parse_month {
    # Check if argument is a valid month name or number
    # Write parsed month's number to STDOUT
    # Write -1 to STDOUT on error
    if (( "$#" == 0 ))
    then
        echo "Error: parse_month (function): No arguments" >&2
        echo "-1"
    fi

    if is_whole_num "$1" && (( "$1" > 0 )) && (( "$1" < 13 ))
    then
        echo "Debug: month_arg is a valid month num" >&2
        month_num=$1
    else
        echo "Debug: month_arg is not a valid month num" >&2
        
        month_num=$(date --date="28 $1 2020" +"%m")
        if (( "$?" == 1 ))
        then
            echo "Debug: month_arg is not a valid month name as well" >&2
            echo "-1"   # rv
        fi
    fi
    echo "Debug: month_arg is a valid month name" >&2
    echo "$month_num"   # rv
}

function parse_year {
    # Checks if argument is a natural number less than 9999 
    # Write -1 to STDOUT on error
    # Returns parsed year
    if (( "$#" == 0 ))
    then
        echo "Error: parse_year (function): No arguments" >&2
        echo "-1"   # rv
    fi
    
    if is_whole_num "$1" && (( "$1" > 0 )) && (( "$1" < 10000 ))
    then
        echo "Debug: year_arg is a valid year" >&2
        echo "check: year $1" >&2
        echo "$1"   # rv
    else
        echo "Debug: year_arg is not a valid year" >&2
        echo "-1"   # rv
    fi
}

# Configure keys
n_century=$'\6'  # C-f
p_century=$'\2'  # C-b
n_decade='L'
p_decade='H'
n_year='l'
p_year='h'
n_month='j'
p_month='k'


# Obtain required arguments
if (( "$#" > 2 ))
then
    echo "Error: Too many arguments"
    exit 1
elif (( "$#" == 2 ))
then
    month_arg=$1
    year_arg=$2
elif (( "$#" == 1 ))
then
    month_arg=$(date +%m)
    year_arg=$1
elif (( "$#" == 0 ))
then
    month_arg=$(date +%m)
    year_arg=$(date +%Y)
fi

echo "$month_arg, $year_arg" >&2

# Parse month
month=$(parse_month "$month_arg")
if (( month == -1 ))
then
    echo "Error: $month_arg is neither a month number (1..12) nor a name"
    exit 1
fi

# Parse year
year=$(parse_year "$year_arg")
if (( year == 0 ))
then
    echo "Error: year $year not in range 1..9999"
    exit 1
fi

echo "$month, $year" >&2

# The event loop
response='a'
while [ "$response" != $'\E' ] && [ "$response" != "q" ]
do
    clear
    cal "$month" "$year"
    read -rn1 response
    # printf '\n%q\n' "$response" >&2

    case "$response" in
        "$n_century")
            # Increment century
            if (( year < 9900 ))
            then
                year=$((year + 100))
            fi;;

        "$p_century")
            # Decrement century
            if (( year > 100 ))
            then
                year=$((year - 100))
            fi;;

        "$n_decade")
            # Increment decade
            if (( year < 9990 ))
            then
                year=$((year + 10))
            fi;;

        "$p_decade")
            # Decrement decade
            if (( year > 10 ))
            then
                year=$((year - 10))
            fi;;

        "$n_year")
            # Increment year
            if (( year < 9999 ))
            then
                year=$((year + 1))
            fi;;

        "$p_year")
            # Decrement year
            if (( year > 1 ))
            then
                year=$((year - 1))
            fi;;

        "$n_month")
            # Increment month
            if (( "$month" == 12 )) && (( "$year" < 9999 ))
            then
                month=1
                year=$((year + 1))
            else
                month=$((month + 1))
            fi;;

        "$p_month")
            # Decrement month
            if (( "$month" == 1 )) && (( "$year" > 1 ))
            then
                month=12
                year=$((year - 1))
            else
                month=$((month - 1))
            fi;;
    esac
done
clear

# Todo:
#  - config file to customize key bindings
#  - add number modifier
#  - use getopt to accept other options of cal
