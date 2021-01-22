#! /bin/bash

trap '(( "$?" == 0 )) || echo -e "\e[31m[ ERROR ]: Error occurred!\e[0m"' EXIT

if [[ "$#" = 1 ]]; then
	postfix="${1##*_}" # a check on postfix should be done, i am lazy
	echo -e "\e[32m[ INFO ]: modifying the definespack.vhd constant definitions\e[0m"
	#awk -f awk_cmd_$postfix < ../src/definespack.vhd > ../src/tmp; mv ../src/tmp ../src/definespack.vhd
	./comp_and_sim.sh -nogui "$1" <<EOF
quit -f         
EOF
else
	echo -e "\e[31m[ SYNTAX ERROR ]: Not enugh arguments. One argument is required.\e[0m"
fi
