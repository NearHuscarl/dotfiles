#!/bin/bash

# ============================================================================
# File:        install.sh
# Description: This script create symlinks to the location of the dotfiles or
#              the folder containing it and point to the equivalent file/folder
#              in this repo
# Author:      Near Huscarl <near.huscarl@gmail.com>
# Last Change: Tue Sep 19 01:12:36 +07 2017
# Licence:     BSD 3-Clause license
# Note:        N/A
# ============================================================================

################# 
# misc function #
################# 

# copy from 
# https://github.com/paulirish/dotfiles/blob/master/symlink-setup.sh

# print output in red
print_error() {
   printf "\e[0;31m  [ ✖ ] $1 $2\e[0m\n"
}

# print output in blue
print_info() {
   printf "\e[0;34m  [ i ] $1\e[0m\n"
}

# print output in yellow
print_question() {
   printf "\e[0;33m  [ ? ] $1\e[0m"
}

# print output in green
print_success() {
   printf "\e[0;32m  [ ✔ ] $1\e[0m\n"
}

# arg 1: command to execute as normal but in format text
# arg 2: optional string for extra information
execute() {
   $1 &> /dev/null

   if [[ $? -eq 0 ]]; then
      print_success "$1"
      if [[ $# -eq 2 ]]; then
         print_success "$2"
      fi
      return 1
   else
      print_error "$1"
      if [[ $# -eq 2 ]]; then
         print_error "$2"
      fi
      return 0
   fi
}

print_option_for_exist_file () {
   print_question "path $1 already exists\n \
      1 - backup and replace\n \
      2 - overwrite\n \
      3 - skip\n \
      4 - skip all\n \
 Choice: "
}

#############
# Variables #
#############

# current working dir
pwd=$(pwd)

# config directory
config=$HOME/.config

# old dotfiles backup directory
dotfilesOld=$HOME/dotfilesOld

# list of files/folders to symlink (start from $HOME)
declare -a targetFiles=(\
   "bin"\
   ".config/compton.conf"\
   ".config/i3"\
   ".config/git"\
   ".config/ncmpcpp"\
   ".config/neofetch"\
   ".config/polybar"\
   ".config/ranger"\
   ".config/rofi"\
   ".config/xfce4"\
   ".config/zathura"\
   ".vim"\
   ".bashrc"\
   ".inputrc"\
   )

# skip all the exist files
isSkipAll=0

# option to choose when detect exist files
option="" 

# store a list of strings to be execute as commands
declare -a result=()

#############################
# symlink script start here #
#############################

# loop through all files/folders to symlink to proper location, if files/folders
# already exists ask whether to overwrite, backup, or skip to the next files/folders

for file in "${targetFiles[@]}"; do

   source="$pwd/$file"
   target="$HOME/$file"

   if [[ -e "$target" ]]; then 

      if [[ "$isSkipAll" == 1 ]]; then 
         print_info "Skip moving $source to $target"
         result+=("print_error '$source → $target'")
         continue
      fi

      # find existed $file in $config, ask for confirmation:
      #  -backup
      #  -overwrite
      #  -skip
      #  -skip all

      # repeat the question if detect wrong input
      while [[ ! "$option" =~ [1234] ]]; do
         print_option_for_exist_file $target
         read option

         if [[ "$option" == "1" ]]; then
            execute "cp $target $target.gitsave"
            execute "mv -f $source $target"
            [[ $? -eq 1 ]] \
               && result+=("print_success '$source → $target'") \
               || result+=("print_error '$source → $target'")
         elif [[ "$option" == "2" ]]; then
            print_question "Are you sure? (y/n)"
            read -n 1

            if [[ $REPLY =~ ^[yY]$ ]]; then
               execute "rm -rf $target"
               execute "mv -f $source $target"
               [[ $? -eq 1 ]] \
                  && result+=("print_success '$source → $target'") \
                  || result+=("print_error '$source → $target'")
            else
               print_info "Canceled overwrite operation"
               continue
            fi
         elif [[ "$option" == "3" ]]; then
            print_info "Skip moving "$source" to "$target""
            result+=("print_error '$source → $target'")
            break
         elif [[ "$option" == "4" ]]; then
            isSkipAll=1
            print_info "Skip moving "$source" to "$target""
            result+=("print_error '$source → $target'")
            break
         else
            print_error "$option is an invalid option"
         fi
      done
      option=0

   else
      execute "ln -fs $source $target"
      [[ $? -eq 1 ]] \
         && result+=("print_success '$source → $target'") \
         || result+=("print_error '$source → $target'")
   fi

done

# print result about symlink operation
if [[ ! -z "$result" ]]; then
   print_info "--RESULT--"
   for cmd in "${result[@]}"; do
      eval $cmd
   done
fi
