#!/bin/bash

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
	echo "Програма ввыводит все записи за последние N минут к заданному моменту времени."
	echo "Далле добавляет их в новый файл с логами."
	exit 0
fi

if [ "$#" != 3 ]; then
	echo "Ошибка. Неверное количество параметров."
	exit 1
fi

inputfile=$1
timeper=$2
timeper2=$3
outputfile="answer.txt"

if [ ! -f "$inputfile" ]; then
	echo "Ошибка. Данного файла не существует."
	exit 1
fi

if [ "$timeper2" == 0 ]; then
	echo "За данный промежуток времени логи никак не могут поменяться."
	exit 1
fi

time_epoh=$(date -d "$timeper" +%s)
time_promez=$((time_epoh - timeper2 * 60))

awk -v start_time="$time_promez" -v end_time="$time_epoh" '
BEGIN { FS = "\\|" }
{
	split($2, dateTime, " ")
	split(dataTime[1], data, "-")
	split(dataTime[2], timee, ":")
	year = data[1]
	month = (length(data[2]) == 1 ? "0" data[2] : data[2])
	day = (length(data[3]) == 1 ? "0" data[3] : data[3])
	taimer = mktime(year " " month " " day " " timee[1] " " timee[2] " " timee[3])

	if (taimer >= start_time && taimer <= end_time) {
		print $0
	}
}' "$inputfile" | sort -t'|' -k5,5n -k4,4 > "$outputfile"
