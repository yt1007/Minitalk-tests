# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    general_instructions.sh                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/12 08:22:11 by yetay             #+#    #+#              #
#    Updated: 2023/09/14 14:30:06 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

## Initiate error code storage
EC=0;

## General instructions (Mandatory)
if [[ ${M} -eq 1 ]];
then
	SCORE=0;
	make fclean >/dev/null 2>&1;
	make >/dev/null 2>&1;
	if [[ -e server && -e client ]];
	then
		SCORE=$[${SCORE} + 1];
		echo -e "Makefile compiles both executables, M${GR}+1${NC} ";
	else
		echo -ne "Makefile does not compile ";
		if [[ ! -e server ]];
		then
			echo -ne "server ";
		fi;
		if [[ ! -e server && ! -e client ]];
		then
			echo -ne "and ";
		fi;
		if [[ ! -e client ]];
		then
			echo -ne "client ";
		fi;
		echo;
		EC=1;
	fi;
	(set +m; nohup ./server >serv_pid 2>/dev/null &);
	ps x | grep -w "\.\/server" | awk '{print $1}' >serv_psid;
	if [[ $(grep -cwf serv_psid serv_pid) -ne 0 ]];
	then
		SCORE=$[${SCORE} + 2];
		echo -e "Server is server, and prints PID, M${GR}+2${NC} ";
		EC=0;
	else
		echo -e "Server does not print PID";
		EC=1;
	fi;
	serv=$(grep -owf serv_psid serv_pid);
	./client ${serv} "General instructions test";
	EC=$?;
	(set +m; kill -TERM ${serv}) >/dev/null 2>&1;
	if [[ ${EC} -eq 0  && $(grep -c "General instructions test" serv_pid) -eq 1 ]];
	then
		SCORE=$[${SCORE} + 2];
		echo -e "Client is client, and takes 2 params, M${GR}+2${NC} ";
	else
		echo -e "Client does not work expectedly";
	fi;
	rm serv_psid serv_pid;
	echo -e "                                           Mandatory Score=${SCORE}";
fi;

## General instructions (Bonus)
if [[ ${B} -eq 1 ]];
then
	SCORE=0;
	make fclean >/dev/null 2>&1;
	make bonus >/dev/null 2>&1;
	if [[ -e server && -e client ]];
	then
		SCORE=$[${SCORE} + 1];
		echo -e "Makefile compiles both executables, B${GR}+1${NC} ";
	else
		echo -ne "Makefile does not compile ";
		if [[ ! -e server ]];
		then
			echo -ne "server ";
		fi;
		if [[ ! -e server && ! -e client ]];
		then
			echo -ne "and ";
		fi;
		if [[ ! -e client ]];
		then
			echo -ne "client ";
		fi;
		echo
		EC=1;
	fi;
	(set +m; nohup ./server >serv_pid 2>/dev/null &);
	ps x | grep -w "\.\/server" | awk '{print $1}' >serv_psid;
	if [[ $(grep -cwf serv_psid serv_pid) -ne 0 ]];
	then
		SCORE=$[${SCORE} + 2];
		echo -e "Server is server, and prints PID, B${GR}+2${NC} ";
		EC=0;
	else
		echo -e "Server does not print PID";
		EC=1;
	fi;
	serv=$(grep -owf serv_psid serv_pid);
	./client ${serv} "General instructions test";
	EC=$?;
	(set +m; kill -TERM ${serv}) >/dev/null 2>&1;
	if [[ ${EC} -eq 0  && $(grep -c "General instructions test" serv_pid) -eq 1 ]];
	then
		SCORE=$[${SCORE} + 2];
		echo -e "Client is client, and takes 2 params, B${GR}+2${NC} ";
	else
		echo -e "Client does not work expectedly";
	fi;
	rm serv_psid serv_pid;
	echo -e "                                               Bonus Score=${SCORE}";
fi;

## Goodbye
exit $EC;
