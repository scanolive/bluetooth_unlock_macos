#!/bin/bash

BLUE_MAC='00-00-00-00-00-00' 	#用你的蓝牙设备的蓝牙地址替换'00-00-00-00-00-00'
ALL_DAY='YES'					#全天有效此值设为YES,否则为NO,设为YES时,START_TIME和END_TIME无效
START_TIME=8					#生效时间开始时间,8等于8:00
END_TIME=19						#生效时间结束时间,19等于19:00
CHECK_INTERVAL=10				#检测间隔时间,单位秒
WORK_DIR="$( cd "$( dirname "$0"  )" && pwd  )/"
INPUT_SCRIPT="input_passwd.applescript"
arg_arr=($@)

if [[ -x "${WORK_DIR}"check_bluetooth  ]];then
	CHECK_BLUE_CMD="${WORK_DIR}"check_bluetooth
else
	CHECK_BLUE_CMD="${WORK_DIR}"check_bluetooth.swift
fi
function check_blue()
{
		"${CHECK_BLUE_CMD}" "${BLUE_MAC}"  2>/dev/null
}

function check_lock()
{
	/usr/bin/python -c 'import Quartz;d=Quartz.CGSessionCopyCurrentDictionary();print d'|grep CGSSessionScreenIsLocked|wc -l
}
function inputpasswd()
{
	/usr/bin/osascript "${WORK_DIR}"input_passwd.applescript	
	/usr/bin/caffeinate -u -t 10 
}
function unlock()	
{
	ISLOCK=$(check_lock)
	LIP_STATUS=$(/usr/sbin/ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState  | grep Yes|wc -l)
	if [ ${ISLOCK} -eq 1 ] && [[ $LIP_STATUS -eq 0 ]];then
		BLUE_STATUS_1=$(check_blue)
		if [ ${BLUE_STATUS_1} -eq 1 ];then
			inputpasswd
		else
			sleep 5
			BLUE_STATUS_2=$(check_blue)
			if [ ${BLUE_STATUS_2} -eq 1 ];then
				inputpasswd
			fi
		fi
	fi
}


function lock()
{
	ISLOCK=$(check_lock)
	if [ ${ISLOCK} -eq 0 ];then	
		BLUE_STATUS=$(check_blue)
		if [ ${BLUE_STATUS} -eq 0 ];then
			sleep 10
			BLUE_STATUS=$(check_blue)
			if [ ${BLUE_STATUS} -eq 0 ];then
				/usr/bin/pmset displaysleepnow
			fi
		fi
	fi
}


function unlock_now()	
{
	ISLOCK=$(check_lock)
	if [ ${ISLOCK} -eq 1 ];then
		BLUE_STATUS_1=$(check_blue)
		if [ ${BLUE_STATUS_1} -eq 1 ];then
			inputpasswd
		else
			sleep 5
			BLUE_STATUS_2=$(check_blue)
			if [ ${BLUE_STATUS_2} -eq 1 ];then
				inputpasswd
			fi
		fi
	fi
}

if [[ "${arg_arr[@]}" =~ "-l" ]];then
	function main()
	{
		lock
		unlock
	}
else
	function main()
	{
		unlock
	}
fi

if [[ "${arg_arr[@]}" =~ "-D" ]];then
	if [ "${ALL_DAY}" == "YES" ];then
		while true
		do
			main
			sleep ${CHECK_INTERVAL}
		done
	else
		while true
		do
			time_now=$(date '+%k')
			if  [ "${time_now}" -gt ${START_TIME} ] && [ "${time_now}" -lt "${END_TIME}" ];then
				main
				sleep ${CHECK_INTERVAL}
			else
				sleep 300
			fi
		done
	fi
else
	unlock_now
fi
