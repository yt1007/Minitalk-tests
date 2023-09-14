# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    message_transmissions.sh                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/12 13:07:26 by yetay             #+#    #+#              #
#    Updated: 2023/09/14 16:48:24 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

## Initiate error code storage
EC=0;

## Message transmissions (Mandatory)
if [[ ${M} -eq 1 ]];
then
	make fclean >/dev/null 2>&1;
	make >/dev/null 2>&1;
	(set +m; nohup ./server >serv_pid 2>/dev/null &);
	ps x | grep -w "\.\/server" | awk '{print $1}' >serv_psid;
	export server=$(grep -owf serv_psid serv_pid);
	sort -R ${WD}/input/0.txt | head -n 5 > input.tmp;
	bash ${WD}/tests/send_lines_from_file.sh input.tmp;
	EC=$?;
	(set +m; kill -TERM ${server}) >/dev/null 2>&1;
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
   	rm input.tmp output.tmp serv_psid serv_pid;
fi;

## Goodbye
exit 0;
