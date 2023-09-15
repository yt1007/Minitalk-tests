# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    simple_setup.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/14 17:22:28 by yetay             #+#    #+#              #
#    Updated: 2023/09/15 11:11:04 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

## Initiate error code storage
EC=0;

## General instructions (Mandatory)
if [[ ${M} -eq 1 ]];
then

	## Preparation
	SCORE=0;
	make fclean >/dev/null 2>&1;
	make >/dev/null 2>&1;
	if [[ !(-e server && -e client) ]];
	then
		echo -ne "Compilation error ";
		exit 1;
	fi;

	## Server should be able to receive multiple strings
	## without needing to be restarted

	# Start server & get server PID
	(set +m; nohup ./server >serv_pid 2>/dev/null &);
	ps x | grep -w "\.\/server" | awk '{print $1}' >serv_psid;
	export server=$(grep -owf serv_psid serv_pid);

	# Send 20 random lines to server
	sort -R ${WD}/input/0.txt | head -n 20 > input.tmp;
	bash ${WD}/tests/send_lines_from_file.sh input.tmp;
	EC=$?;

	# Kill server
	(set +m; kill -TERM ${server}) >/dev/null 2>&1;

	# Compare server output with the client output
	cat serv_pid | grep -vw "$server" > output.tmp;
	if [[ ${EC} -ne 0 ]];
	then
		echo -ne " ";
	else
		echo -ne "Server can receive multiple strings without restart, ";
		echo -e "${GR}+1${NC}";
		SCORE=$[${SCORE} + 1];
	fi;
	if [[ "$(diff input.tmp output.tmp)" ]];
	then
		echo -ne "Message not identical ";
		echo;
		echo "Input";
		cat input.tmp;
		echo;
		echo "Output";
		cat output.tmp;
		EC=1;
	fi;

	# Clean-up
   	rm input.tmp output.tmp serv_psid serv_pid;

	## Use norminette to check for global variables
	gvc=$(find * -type f -name "*.c" \
		-exec norminette -R CheckDorbiddenSourceHeader {} \; \
		| grep -c GLOBAL_VAR_DETECTED);
	if [[ $gvc -ne 0 ]];
	then
		echo -e "${gvc} global variables found, check the codes";
		EC=1;
	else
		echo -e "No global vars found, ${GR}+1${NC}. Ask why!";
	fi;

	## Check if communication is done only using signals SIGUSR1 and SIGUSR2
	# Get list of kill calls
	find * -type f -name "*.c" \
		-exec grep -o "kill([^,]\+, [^)]\+)" {} \; \
		| grep -v -e "SIGUSR1" -e "SIGUSR2" \
		| sort | uniq | sed "s/kill([^,]*, \(.*\))/\1/" \
		| while read v;
		do
			find * -type f -name "*.c" \
				-exec grep -o "${v} = [^;]\+" {} \; \
				| sed "s/${v} = //" | sort | uniq \
				| grep -v -e "SIGUSR1" -e "SIGUSR2";
		done | sort | uniq > kill_sig.lst;
	if [[ $(cat kill_sig.lst | wc -l) -ne 0 ]];
	then
		echo -e "Forbidden signals found: $(cat kill_sig.lst | tr "\n" " ")";
		EC=1;
	else
		echo -e "Only SIGUSR1 and SIGUSR2 were used with kill, ${GR}+3${NC}";
	fi;
fi;

## Goodbye
exit $EC;
