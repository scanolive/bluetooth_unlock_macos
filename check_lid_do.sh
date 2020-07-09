#!/bin/bash

CHECK_INTERVAL=2		#检测间隔时间,单位秒
WORK_DIR="$( cd "$( dirname "$0"  )" && pwd  )/"
export LAST_LIP_STATUS=$(/usr/sbin/ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState  | grep Yes|wc -l)
open_lip()
{
	"${WORK_DIR}"bluetooth_unlock.sh  
}
close_lip()
{
	/usr/bin/pmset displaysleepnow
}
while true
do
	sleep ${CHECK_INTERVAL}
	NOW_LIP_STATUS=$(/usr/sbin/ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState  | grep Yes|wc -l)
	if [[ $LAST_LIP_STATUS -ne $NOW_LIP_STATUS ]];then
		if [[ $NOW_LIP_STATUS -eq 0 ]];then
			open_lip
		else
			close_lip
		fi
	fi
	export LAST_LIP_STATUS=$NOW_LIP_STATUS
done
