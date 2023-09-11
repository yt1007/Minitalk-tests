# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    compilation.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/12 07:46:38 by yetay             #+#    #+#              #
#    Updated: 2023/09/12 07:53:46 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

## Initiate error code storage
EC=0;

## Compilation (Mandatory)
if [[ ${M} -eq 1 ]];
then
	make fclean 2>&1 > /dev/null;
	make 2>&1 > /dev/null;
	EC=$?;
	if [[ ${EC} -ne 0 ]];
	then
		echo -e "Program does not compile with make. ";
		exit ${EC};
	fi;
fi;

## Compilation (Bonus)
if [[ ${B} -eq 1 ]];
then
	make fclean 2>&1 > /dev/null;
	make bonus 2>&1 > /dev/null;
	EC=$?;
	if [[ ${EC} -ne 0 ]];
	then
		echo -e "Program does not compile with make bonus. ";
		exit ${EC};
	fi;
fi;

## Goodbye
exit $EC;
