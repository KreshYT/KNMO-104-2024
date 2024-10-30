#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Введите:"
    echo "Число изображений по горизонтали"
    echo "Число изображений по вертикали"
    echo "Путь к папке с изображениями"
    echo "Имя выходного файла"
    exit 0
fi

if [ "$#" != 4 ]; then
    echo "Ошибка: недостаточно параметров."
    exit 1
fi

N=$1
M=$2
input_dir=$3
output_file=$4

if ! [[ "$N" =~ ^[0-9]+$ ]] || ! [[ "$M" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: N и M должны быть положительными целыми числами."
    exit 1
fi

if ! [ -d "$input_dir" ]; then
    echo "Ошибка: директория не существует."
    exit 1
fi

images=($(ls "$input_dir"/* 2>/dev/null | sort))

if [ "${#images[@]}" == 0 ]; then
    echo "Ошибка: в директории нет файлов."
    exit 1
fi

valid_images=()
for img in "${images[@]}"; do
    mimetype=$(file --mime-type -b "$img")
    if [[ "$mimetype" == image/* ]]; then
        valid_images+=("$img")
    fi
done

required_images=$((N * M))

if [ "${#valid_images[@]}" -lt "$required_images" ]; then
    echo "Ошибка: недостаточно изображений"
    exit 1
fi

valid_images=("${valid_images[@]:0:$required_images}")

first_image="${valid_images[0]}"
size=$(identify -format "%wx%h" "$first_image")
width=$(echo $size | cut -d'x' -f1)
height=$(echo $size | cut -d'x' -f2)

for img in "${valid_images[@]}"; do
    mogrify -resize "${width}x${height}" "$img"
done

montage "${valid_images[@]}" -tile "${N}x${M}" -geometry "${width}x${height}" "$output_file"

echo "Все выполнено без ошибок"

