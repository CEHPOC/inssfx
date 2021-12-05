#!/bin/bash

fh=0
fv=0
fd=0
f=0
sfx=""
dir=""
masks=()
arg=()
#проверка опций
for opt in "$@"
do
if [[ $f = 0 && ${opt:0:1} = "-" ]]
then
    if [[ $opt = "-h" ]]
    then
	fh=1
    elif [[ $opt = "-v" ]]
    then
	fv=1
    elif [[ $opt = "-d" ]]
    then
	fd=1
    elif [[ $opt = "--" ]]
    then
	f=1
    else
	echo "нет опции $opt" >&2
	exit 2
    fi
elif [[ $f = 1 ]]
then
    if [[ $sfx = "" ]]
    then
	sfx=$opt
    elif [[ $dir = "" ]]
    then
	dir=$opt
    else
	masks+=($opt)
    fi
fi
done

if [[ $fh = 1 ]]
then
    echo "inssfx [-h] [-v|-d] [--] sfx dir mask1 [mask2...]"
    exit 0
fi

#проверка параметров
if [[ $sfx = "" ]]
    then
	echo "не указан суффикс" >&2
	exit 2
    elif [[ $dir = "" ]]
    then
	echo "не указана директория" >&2
	exit 2
    elif ! [[ -d $dir ]]
    then
	echo "такой директории нет" >&2
	exit 2
    elif [[ ${masks[0]} = "" ]]
    then
	echo "не указана маска"
	exit 2
fi
#обработка
arg[0]=find
arg[1]=$dir
arg[2]="-name"
arg[3]=${mask[0]}
i=3
for mask in "$masks"
do
i=$(($i+1))
arg[$i]="-o"
i=$(($i+1))
arg[$i]="-name"
i=$(($i+1))
arg[$i]=$mask
done
"${arg[@]}" | while read file
    do
	filename="${file%.*}"
	ext="${file#$filename}"
	if [[ $fd = 1 ]]
	then
		echo "$file -> $filename$sfx$ext"
	elif [[ $fv = 1 ]]
	then
		echo "$file -> $filename$sfx$ext"
		mv $file $filename$sfx$ext
	else
		mv $file $filename$sfx$ext
	fi
    done

