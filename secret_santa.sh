#!/bin/bash

print_help() {
echo -e "$(basename $0): Usage:
\t-h\tprint this help
\t-f\tfile containing particpating emails
\t\trequired
\t-v\tverbose output" 1>&2
}

V=false
verbose() {
$V && echo $(date +%y/%m/%d' '%H:%M:%S): $(basename $0): $* 1>&2
}

fname(){
name=$(echo $1 | cut -d@ -f1 | cut -d. -f1)
echo ${name^}
}

lname() {
name=$(echo $1 | cut -d@ -f1 | cut -d. -f2)
echo ${name^}
}

while getopts ":hf:v" opt; do
  case $opt in
    f)
      emails=$OPTARG
    ;;
    h)
      print_help
      exit 0
    ;;
    v)
      V=true
    ;;
    \?)
      echo "Undefined option."
      print_help
      exit 1
    ;;
  esac
done

[ -z "$emails" ] && echo "Enter -f otion with file of emails." 1>&2 && exit 2

test -f $emails || exit 3

shuf $emails > .emails.temp

cnt=$(wc -l $emails | cut -d' ' -f1)
[ $((cnt%2)) -eq 1 ] && verbose "Odd number" && until [ "$(tail -1 $emails)" != "$(tail -1 .emails.temp)" ]; do
  shuf $emails > .emails.temp
done

while read email; do
  while read victim; do
    if [[ "${email}" == "${victim}" ]]; then
      continue
    else
      echo -e "Hello $(fname ${email}). Your victim is $(fname ${victim}) $(lname ${victim}) (${victim}).\n\nLet us all gather on the 8th, full of christmas cheer and a love of Jesus in our hearts to exchange these wondrous holiday gifts!\n\nRemember, limit is Â£10.\n\nLots of love,\nSanta's Little Server\nxoxoxox" | \
      mailx -s "Clandestine Festive Gifts" ${email}
      sed -i /${victim}/d .emails.temp
      break
    fi
  done < .emails.temp
done < $emails

rm .emails.temp
