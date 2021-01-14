#! /bin/bash 

trap '(( "$?" == 0 )) || echo -e "\e[31m[ ERROR ]: Error occurred!\e[0m"' EXIT

source /software/scripts/init_msim6.2g

# check if at least 2 arguments are passed. More than 2 are ignored
if [[ "$#" > 1 ]] && [[ -e "$2" ]]; then
	[ -e work/_info ] || vlib work
	for hdl_file in $(cat "$2") # iterate over the strings in the file
	do
		if [[ "$hdl_file" == "%"* ]]; then
			continue
		fi
		filename=$(basename "$hdl_file") # get filename.extension from the string which contains also the path
		if [[ "${filename##*.}" == "vhd" ]]; then
			echo -e "\e[32mCompiling $filename ...\e[0m"
			vcom -93 -work ./work "$hdl_file" || exit -1
		elif [[ "${filename##*.}" == "v" ]]; then
			echo -e "\e[32mCompiling $filename ...\e[0m"
			vlog -work ./work "$hdl_file" || exit -1
		else
			echo -e "\e[31m[ ERROR ] : source hdl file ( $filename ) not found!\e[0m"
		fi
	done
	postfix="${2##*_}"
	if [[ "$postfix" = "pos" ]]; then
		# do we really have to delete EVERYTHING inside these directories?
		[ -d ../vcd ] && rm -rf ../vcd/* || mkdir ../vcd
		[ -d ../saif ] && rm -rf ../saif/* || mkdir ../saif
	fi
	if [[ "$1" == "-dbg" ]]; then
		vsim -do "simulate_$postfix.do" || exit -1
	elif [[ "$1" == "-nogui" ]]; then
		vsim -c -do "simulate_$postfix.do" || exit -1
	elif [[ "$1" == "-nosim" ]]; then
		echo -e "\e[1m\nNO SIMULATION WILL START!\n\e[0m"
		exit 0
	else
		echo "no arguments passed, nothing to do"
		exit -1
	fi
	#mv ./results.txt "./results_$postfix.txt"
else
	echo -e "\e[31m[ SYNTAX ERROR ]: Not enough arguments or inexistent file. Syntax is $0 <opt> <compile_order_filename>\e[0m"
	exit -1
fi

exit 0


