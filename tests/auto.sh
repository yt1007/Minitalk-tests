# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    auto.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yetay <yetay@student.42kl.edu.my>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/11 14:27:43 by yetay             #+#    #+#              #
#    Updated: 2023/09/15 09:19:30 by yetay            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

## The Minitalk submission directory
MT_DIR=../minitalk

## Export the colours
export RD='\033[0;31m';
export GR='\033[0;32m';
export BL='\033[1;34m';
export NC='\033[0m';

## Initiate error code store
EC=0;

## Setup and test the paths
export WD=$(pwd);
if [[ ! -r "${MT_DIR}" ]];
then
	echo -e "${RD}MT_DIR: ${MT_DIR}, not available";
fi;
cd ${MT_DIR};
EC=$?;
if [[ ${EC} -ne 0 ]];
then
	echo -e "${RD}MT_DIR: ${MT_DIR}, not available";
fi;
export MT_DIR=$(pwd);
cd ${WD};

## Configure the test sets (mandatory/bonus)
M=0;
B=0;
if [[ "$1" ]];
then
	if [[ "$1" == "M" ]];
	then
		M=1;
	elif [[ "$1" == "B" ]];
	then
		B=1;
	fi;
else
	M=1;
	B=1;
fi;
export M;
export B;

## Norminette
cd ${MT_DIR};
echo -ne "${BL}Running norminette on *.h and *.c files${NC}... ";
bash ${WD}/tests/auto_norm.sh > norminette.out;
EC=$?;
if [[ ${EC} -eq 0 && $(cat ${MT_DIR}/norminette.out | grep -c -v ": OK!") -eq 0 ]];
then
	echo -e "${GR}OK${NC}.";
	rm ${MT_DIR}/norminette.out;
else
	echo -e "${RD}KO${NC}.";
fi;

## Compilation
echo -ne "${BL}Checking if program compiles and Makefile relinking${NC}... "
bash ${WD}/tests/compilation.sh;
EC=$?;
if [[ ${EC} -eq 0 ]];
then
	echo -e "${GR}OK${NC}.";
else
	echo -e "${RD}KO${NC}.";
fi;

## General Instructions
echo -e "${BL}Checking general functionality${NC}... ";
bash ${WD}/tests/general_instructions.sh;
EC=$?;
if [[ ${EC} -eq 0 ]];
then
	echo -e "${GR}OK${NC}.";
else
	echo -e "${RD}KO${NC}.";
fi;

## Message transmission
echo -ne "${BL}Checking message transmissions${NC}... ";
bash ${WD}/tests/message_transmissions.sh;
EC=$?;
if [[ ${EC} -eq 0 ]];
then
	echo -e "${GR}OK${NC}.";
else
	echo -e "${RD}KO${NC}.";
fi;

## Simple setup
echo -e "${BL}Checking simple setup${NC}... ";
bash ${WD}/tests/simple_setup.sh;
EC=$?;
if [[ ${EC} -eq 0 ]];
then
	echo -e "${GR}OK${NC}.";
else
	echo -e "${RD}KO${NC}.";
fi;

## Unicode character support
echo -ne "${BL}Checking unicode support${NC}... ";
bash ${WD}/tests/unicode.sh
EC=$?;
if [[ ${EC} -eq 0 ]];
then
	echo -e "${GR}OK${NC}.";
else
	echo -e "${RD}KO${NC}.";
fi;

exit $EC;
