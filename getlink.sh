#!/bin/sh

OPTIND=1
show_dylib=0
show_a=0
show_dll=0
dir=$PWD
new_line=0
ignore_version=0

directories=()

while [ ! -z $1 ]; do

    while getopts "h?adlni" opt; do
        case "$opt" in
        h|\?) #show_help
            echo "bitch"
            exit 1
            ;;
        a)  show_a=1
            ;;
        d)  show_dylib=1
            ;;
        l)  show_dll=1
            ;;
        n)  new_line=1
            ;;
        i)  ignore_version=1
			;;
        esac
    done

    shift $((OPTIND-1))


    while [ ! ${1:0:1} == "-" ]; do
        directories+=($1)
        shift 
    done

    count=$((count+1))

done

if [ $((show_dylib+show_dll+show_a)) == 0 ]; then
    show_dylib=1
    show_dll=1
    show_a=1
fi

if [ -z ${directories[0]} ]; then 
    directories+=($PWD)
fi

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

# echo "show_dylib=$show_dylib, show_a=$show_a, show_dll=$show_dll"


for dir in ${directories[@]}; do

	prev_filename=""

    for file in $dir/*; do

        if [ $show_a == 1 ] && [ ${file: -2} == ".a" ]; then
        	progname=$(f=${file##*/lib} ; echo "-l$f" | cut -f 1 -d '.')
        	# progname=$(f=${file##*/lib} ; echo "${f%*.a}")
        	if [ "$prev_filename" != "$progname" ]; then
        		printf -- "%s " $progname
        		prev_filename=$progname
        		if [ $new_line == 1 ]; then
        			printf "\n"
        		fi
        	fi

        elif [ $show_dylib == 1 ] && [ ${file: -6} == ".dylib" ]; then
        	progname=$(f=${file##*/lib} ; echo "-l$f" | cut -f 1 -d '.')
        	# progname=$(f=${file##*/lib} ; f=${f%.dylib} ; f=${f%*.*.*.*} ; echo "$f")
            # progname=$(f=${file%*.dylib} ; echo "${f##*/lib}")
            # printf -- "-l%s " $progname
            if [ "$prev_filename" != "$progname" ]; then
        		printf -- "%s " $progname
        		prev_filename=$progname
        		if [ $new_line == 1 ]; then
        			printf "\n"
        		fi
        	fi
       
       	elif [ $show_dll == 1 ] && [ ${file: -4} == ".dll" ]; then
        	progname=$(f=${file##*/lib} ; echo "-l$f" | cut -f 1 -d '.')
        	#progname=$(f=${file##*/lib} ; echo "${f%*.dll}")
            # printf -- "-l%s " $progname
            if [ "$prev_filename" != "$progname" ]; then
        		printf -- "%s " $progname
        		prev_filename=$progname
        		if [ $new_line == 1 ]; then
        			printf "\n"
        		fi
        	fi

        fi

    done

    printf "\n\n"

done

# name=$(echo "libtensorflow.1.15.0.dylib" | cut -f 1 -d '.')
# echo $name
