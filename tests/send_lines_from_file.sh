#!/bin/bash

# Define exit code store
EC=0;

# Send every line to server, and quit on error
cat $1 | while read l;
do
	./client $server "$l";
	EC=$?;
	if [[ $EC -ne 0 ]];
	then
		exit $EC;
	fi;
	len=1000;
	while [[ $(echo "$l" | wc -c) -gt $len ]];
	do
		sleep 1;
		len=$[$len - 100];
	done;
done;

exit $EC;
