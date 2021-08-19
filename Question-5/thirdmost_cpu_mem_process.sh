#!/bin/bash

PORT_NUMBER=$(sudo netstat -nap | egrep -w "Local Address|LISTEN" | grep $(ps --no-headers -eo pid,ppid,%mem,%cpu,cmd --sort=-%mem | head -3 | tail -1 | awk '{if( $2 != 1) print $2; else print $1}') | head -1 | awk '{print $4}' | awk -F ":" '{print $2}')

PROCESS_NAME=$(ps --no-headers -eo cmd --sort=-%mem | head -3 | tail -1)

CPU=$(ps --no-headers -eo %cpu --sort=-%mem | head -3 | tail -1)

MEM=$(ps --no-headers -eo %mem --sort=-%mem | head -3 | tail -1)

PID=$(ps --no-headers -eo pid --sort=-%mem | head -3 | tail -1)


printf "PROCESS_NAME\t\tCPU\tMEM\tPORT\tPID\n"
pritnf "${PROCESS_NAME}\t${CPU}\t${MEM}\t${PORT_NUMBER}\t${PID}\n" 
