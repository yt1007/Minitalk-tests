# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    message_transmissions.sh                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/12 13:07:26 by yetay             #+#    #+#              #
#    Updated: 2023/09/14 14:29:36 by yetay            ###   ########.fr        #
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
	bash ${WD}/tests/send_lines_from_file.sh ${WD}/input/1.txt;
	EC=$?;
	(set +m; kill -TERM ${server}) >/dev/null 2>&1;
	cat -e serv_pid | sed "s/\$$//" | sed "s/\^@$//" | grep -vw "$server" > tmp;
	if [[ ${EC} -ne 0 || "$(diff ${WD}/input/1.txt tmp)" ]];
	then
		echo -ne "Message not identical ";
		echo;
		echo "Input";
		cat ${WD}/input/1.txt;
		echo;
		echo "Output";
		cat tmp;
		exit 1;
	fi;
   	rm tmp serv_psid serv_pid;
fi;

## Goodbye
exit 0;
