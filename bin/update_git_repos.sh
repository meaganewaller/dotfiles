#!/bin/bash

CUR_DIR=$(pwd)

echo -e "\n\033[1mPulling in latest changes for all repos...\033[0m\n"

# Find all Git repositories and update master to latest rev
for i in $(find . -name ".git" | cut -c 3-); do
  echo "";
  echo -e "\033[33m"+$i+"\033[0m";

  # We have to go to the .git parent dir to pull
  cd "$i";
  cd ..;

  git pull --rebase origin master

  cd $CUR_DIR
done

echo -e "\n\033[32mComplete!\033[0m\n"
