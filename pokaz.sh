#!/bin/bash

directory="."

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
	echo "Программа выводит список каталогов первого уровня, в которых не открыт ни один файл, из выбранной директории. Если не указать никакую директорию, то используется текущая. "
            exit 0
            ;;
        -d|--directory)
            directory=$2
	    shift 2
            ;;
        *)
            echo "Ошибка. Некоректный параметр." 
            exit 1
            ;;
    esac
done

if [[ ! -d "$directory" ]]; then
    echo "Ошибка. Переданной директории не существует."
    exit 1
fi

subdirs=$(find "$directory" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)

result=()
for subdir in $subdirs; do
    if ! lsof "$subdir" >/dev/null; then
        result+=("$subdir")
        continue
    fi
done

if [[ ${#result[@]} -eq 0 ]]; then
  exit 1
else
  for dir in "${result[@]}"; do
    echo "$dir"
  done
  exit 0
fi

