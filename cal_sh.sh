#!/bin/bash

#XXX: Change exit to return
#XXX: Change is_pos_int to is_whole_num

# Internal exit codes:
#
#  0: Success
#  -1: Value error
#  -2: Invalid number of arguments
#
# Exposed exit codes:
#
#  0: Success
#  1: Error

function is_pos_integer {
    # Returns zero if argument has only digits
    # Otherwise negative value is returned
    if (( "$#" == 0 ))
    then
        echo "Error: is_pos_integer (function): No arguments"
        exit -2
    fi

    case "$1" in
        ("" | *[!0-9]*)
            return -1
    esac
    return 0
}

function check_month {
    # Parse month name to month number
    # Return negative value on error
    # Returns a number
    if (( "$#" == 0 ))
    then
        echo "Error: check_month (function): No arguments"
        exit -2
    fi

    is_pos_integer "$1"
    if (( "$?" == 0 )) && (( "$1" > 0 )) && (( "$1" < 13 ))
    then
        echo "Debug: month_arg is a valid month num"
        month_num=$1
    else
        echo "Debug: month_arg is not a valid month num"
        month_num=$(date --date="$(printf "28 %s 2020" $1)" +"%m")
        if (( "$?" == 1 ))
        then
            echo "Debug: month_arg is not a valid month name as well"
            return -1
        fi
    fi
    echo "Debug: month_arg is a valid month name"
    return $month_num
}

function check_year {
    # Check if argument is a natural number less than 9999 
    # Return 0 on error
    # Returns zero number
    if (( "$#" == 0 ))
    then
        echo "Error: check_year (function): No arguments"
        return 0
    fi
    
    is_pos_integer "$1"
    if (( "$?" == 0 )) && (( "$1" > 0 )) && (( "$1" < 10000 ))
    then
        echo "Debug: year_arg is a valid year"
        echo "check: year $1"
        return "$1"
    else
        echo "Debug: year_arg is not a valid year"
        return 0
    fi
}

# Obtain required arguments
if (( "$#" > 2 ))
then
    echo "Error: Too many arguments"
    exit 1
elif (( "$#" == 2 ))
then
    month_arg=$1
    year_arg=$2
    #echo "two pos arg"
elif (( "$#" == 1 ))
then
    month_arg=$(date +%m)
    year_arg=$1
    #echo "one pos arg"
elif (( "$#" == 0 ))
then
    month_arg=$(date +%m)
    year_arg=$(date +%Y)
    #echo "No pos args"
fi

echo "$month_arg, $year_arg"

# Parse month
check_month "$month_arg"
month="$?"
if (( $month == -1 ))
then
    echo "Error: $month_arg is neither a month number (1..12) nor a name"
    exit 1
fi

# Parse year
check_year "$year_arg"
year="$?"
echo "check_year_rv: $year"
if (( $year == 0 ))
then
    echo "Error: year $year not in range 1..9999"
    exit 1
fi


echo "$month, $year"
read -n1

# The event loop
response='a'
while [ "$response" != $'\E' ] && [ "$response" != "q" ]
do
    clear
    cal "$month" "$year"
    read -n1 response
    printf '\n%q\n' "$response"

    # Increment century
    if [[ $response == $'\6' ]]
    then
        if (( $year < 9900 ))
        then
            year=$((year + 100))
        fi
        echo "C-f!"

    # Decrement century
    elif [[ $response == $'\2' ]]
    then
        if (( $year > 100 ))
        then
            year=$((year - 100))
        fi
        echo "C-b!"

    # Increment decade
    elif [[ $response == 'L' ]]
    then
        if (( $year < 9990 ))
        then
            year=$((year + 10))
        fi
        echo "L!"

    # Decrement decade
    elif [[ $response == 'H' ]]
    then
        if (( $year > 10 ))
        then
            year=$((year - 10))
        fi
        echo "H!"

    # Increment year
    elif [[ $response == 'l' ]]
    then
        if (( $year < 9999 ))
        then
            year=$((year + 1))
        fi
        echo "l!"

    # Decrement year
    elif [[ $response == 'h' ]]
    then
        if (( $year > 1 ))
        then
            year=$((year - 1))
        fi
        echo "h!"

    # Increment month
    elif [[ $response == 'j' ]]
    then
        if (( "$month" == 12 )) && (( "$year" < 9999 ))
        then
            month=1
            year=$((year + 1))
        else
            month=$((month + 1))
        fi
        echo "j!"

    # Decrement month
    elif [[ $response == 'k' ]]
    then
        if (( "$month" == 1 )) && (( "$year" > 1 ))
        then
            month=12
            year=$((year - 1))
        else
            month=$((month - 1))
        fi
        echo "k!"
    fi
done
#echo $response

#jk=>month
#hl=>year
#HL=>Decade
##C-f,C-b=>century


##################


## Obtain required arguments
#if (( "$#" > 2 ))
#then
#    echo "Error: Too many arguments"
#    exit 1
#elif (( "$#" == 2 ))
#then
#    month=$1
#    year=$2
#    echo "two pos arg"
#elif (( "$#" == 1 ))
#then
#    year=$1
#    echo "one pos arg"
#elif (( "$#" == 0 ))
#then
#    year=$(date +%Y)
#    month=$(date +%m)
#    echo "No pos args"
#fi
#
#
#echo $year
#echo $month


##################


# for arg in "$@"
# do
#     # if the quotes are dropped $arg would be
#     # executed as a command
#     echo "$arg"  
# done


##################


# one arg => year (num)
# two arg => 
#  - arg1: month (num)
#  - arg2: year (num)
