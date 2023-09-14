# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    message_transmissions.sh                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/12 13:07:26 by yetay             #+#    #+#              #
#    Updated: 2023/09/14 17:45:25 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

## Initiate error code storage
EC=0;

## Message transmissions (Mandatory)
if [[ ${M} -eq 1 ]];
then

	## Preparation
	make fclean >/dev/null 2>&1;
	make >/dev/null 2>&1;
	if [[ !(-e server && -e client) ]];
	then
		echo -ne "Compilation error ";
		exit 1;
	fi;

	## It should be possible to pass a message of any size.
	## Using a for loop, pass 5 messages of random lengths
	## and verify that the transmission is successful.

	for i in $(seq 1 5);
	do
		# Start server & get server PID
		(set +m; nohup ./server >serv_pid 2>/dev/null &);
		ps x | grep -w "\.\/server" | awk '{print $1}' >serv_psid;
		export server=$(grep -owf serv_psid serv_pid);

		# Send a message of random length
		head -n $[$RANDOM * 100 / 32767] ${WD}/input/0.txt \
			| tail -n 1 > input.tmp;
		./client ${server} "$(cat input.tmp)";
		EC=$?;

		# Kill server
		(set +m; kill -TERM ${server}) >/dev/null 2>&1;

		# Compare server output with the client output
		cat -e serv_pid | sed "s/\$$//" | sed "s/\^@$//" \
			| grep -vw "$server" > output.tmp;
		if [[ ${EC} -ne 0 || "$(diff input.tmp output.tmp)" ]];
		then
			echo -ne "Message not identical ";
			echo;
			echo "Input";
			cat input.tmp;
			echo;
			echo "Output";
			cat output.tmp;
			exit 1;
		fi;

		# Clean-up
		rm input.tmp output.tmp serv_psid serv_pid;
	done;
fi;

## Goodbye
exit 0;
