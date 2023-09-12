# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    compilation.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/12 07:46:38 by yetay             #+#    #+#              #
#    Updated: 2023/09/12 08:45:08 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

## Initiate error code storage
EC=0;

## Compilation (Mandatory)
if [[ ${M} -eq 1 ]];
then
	make fclean >/dev/null 2>&1;
	make >/dev/null 2>&1;
	EC=$?;
	if [[ ${EC} -ne 0 ]];
	then
		echo -ne "Program does not compile with make. ";
		make fclean >/dev/null 2>&1;
		exit ${EC};
	fi;
	sha=$(shasum server client);
	make >/dev/null 2>&1;
	echo -e "${sha}" | shasum -c >/dev/null 2>&1;
	EC=$?;
	if [[ ${EC} -ne 0 ]];
	then
		echo -ne "Makefile relinks! ";
		echo -e "${ssha}\n${csha}";
		shasum server client;
		make fclean >/dev/null 2>&1;
		exit 1;
	fi;
	make fclean >/dev/null 2>&1;
fi;

## Compilation (Bonus)
if [[ ${B} -eq 1 ]];
then
	make fclean >/dev/null 2>&1;
	make bonus >/dev/null 2>&1;
	EC=$?;
	if [[ ${EC} -ne 0 ]];
	then
		echo -ne "Program does not compile with make bonus. ";
		make fclean >/dev/null 2>&1;
		exit ${EC};
	fi;
	sha=$(shasum server client);
	make bonus >/dev/null 2>&1;
	echo -e "${sha}" | shasum -c >/dev/null 2>&1;
	EC=$?;
	if [[ ${EC} -ne 0 ]];
	then
		echo -ne "Makefile for bonus relinks! ";
		echo -e "${ssha}\n${csha}";
		shasum server client;
		make fclean >/dev/null 2>&1;
		exit 1;
	fi;
	make fclean >/dev/null 2>&1;
fi;

## Goodbye
exit $EC;
