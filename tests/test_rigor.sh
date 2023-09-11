# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    test_rigor.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/11 13:42:40 by yetay             #+#    #+#              #
#    Updated: 2023/09/11 14:15:43 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

export server=$1;

# Loop through the 4 input files for 10 times
for i in $(seq 1 10);
do
	for f in $(seq 1 5);
	do
		./client $server "+------------------+";
		./client $server "|    input${f}.txt    |";
		./client $server "+------------------+";
		bash scripts/send_lines_from_file.sh input/${f}.txt;
		./client $server "";
	done;
done;

# Goodbye
exit;
