#!/bin/bash

set -e

if [ "x$1" != "x--" ]; then
  $0 -- &> ~/.scan_startup_files.log &
  disown
  exit 0
fi

MAIL=richard.holland@virginmedia.co.uk

EPOCH_TIME=$(date +%s)

while true; do
  PROFILE_MOD=$(stat -c %Y ~/.bash_profile)
  RC_MOD=$(stat -c %Y ~/.bashrc)

  if [ $PROFILE_MOD -gt $EPOCH_TIME ]; then
    if [ $RC_MOD -gt $EPOCH_TIME ]; then
      echo -e "$(date) WARNING\n\nChanges have been made to both .bash_profile and .bashrc" |\
         mailx -s "Changes to .bash_profile and .bashrc" $MAIL
    else
      echo -e "$(date) WARNING\n\nChanges have been made to .bash_profile" |\
         mailx -s "Changes to .bash_profile" $MAIL
    fi
  else
    if [ $RC_MOD -gt $EPOCH_TIME ]; then
      echo -e "$(date) WARNING\n\nChanges have been made to .bashrc" |\
         mailx -s "Changes to .bashrc" $MAIL
    fi
  fi
  EPOCH_TIME=$(date +%s)
  sleep 300
done
