# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    unicode.sh                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/15 09:19:39 by yetay             #+#    #+#              #
#    Updated: 2023/09/15 10:40:05 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

## Initiate error code storage
EC=0;

## Unicode support (bonus)
if [[ ${B} -ne 1 ]];
then
	exit 0;
fi;

## Preparation
make fclean >/dev/null 2>&1;
make bonus >/dev/null 2>&1;
if [[ !(-e server && -e client) ]];
then
	echo -ne "Compilation error (make bonus) ";
	exit 1;
fi;

## It should be able to pass messages containing unicode characters

# Start server & get server PID
(set +m; nohup ./server >serv_pid 2>/dev/null &);
ps x | grep -w "\.\/server" | awk '{print $1}' > serv_psid;
export server=$(grep -owf serv_psid serv_pid);

# Send messages containing unicode characters
bash ${WD}/tests/send_lines_from_file.sh ${WD}/input/5.txt;
EC=$?;

# Kill server
(set +m; kill -TERM ${server}) >/dev/null 2>&1;

# Compare server output with the client output
cat serv_pid | grep -vw "$server" > output.tmp;
if [[ ${EC} -ne 0 ]];
then
	echo -ne " ";
fi;
if [[ "$(diff ${WD}/input/5.txt output.tmp)" ]];
then
	echo -ne "Message not identical ";
	echo;
	echo "Input";
	cat ${WD}/input/5.txt;
	echo;
	echo "Output";
	cat output.tmp;
	EC=1;
fi;

# Clean-up
rm output.tmp serv_psid serv_pid;

## Goodbye
exit ${EC};
