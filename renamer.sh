#!/bin/bash
function ctrl_c(){
    echo -e "\n\n Saliendo... \n"
    exit 1
}

trap ctrl_c INT


helpPanel(){
  echo -e "\n Usage : $0 -d <Folder With Image> -e <Extension - jpg - png> \n Example: $0 -d /Download -e jpg" 1>&2 
  exit 1
}

while getopts ":d:e:h" o; do
    case "${o}" in
        d)
            d=${OPTARG}
            ;;
        e)
            e=${OPTARG}
            ;;
        h)
            helpPanel
            ;;
    esac
done

shift $((OPTIND-1))

if [ -z "${d}" ] || [ -z "${e}" ]; then
    helpPanel
fi

filename="files.txt"
numbers="numbers.txt"
scriptName=$0

route=$d

rm -rf $filename

ls $route > $filename
cat $filename | grep -vE "$filename" | sort | sponge $filename

i=0

while IFS= read -r line
do
  ini=$route/$line
  fin=$route/$i.$e
  mv "$ini" "$fin"
  i=$((i+1))
done < $filename

rm -rf $filename

