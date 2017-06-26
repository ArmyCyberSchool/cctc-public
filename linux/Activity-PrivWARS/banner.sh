#!/bin/bash 
#usage: banner.sh <text 2B echoed to screen>
#get listing of color codes: ./banner.sh
declare INPUT_TXT=""
declare    ADD_LF="\n" 
declare -i DONE=0
declare -r COLOR_NUMBER="${1:-247}"
declare -r ASCII_FG="\\033[38;05;"
declare -r COLOR_OUT="${ASCII_FG}${COLOR_NUMBER}m"

function show_colors() { 
   ## perhaps will add bg 48 to first loop eventually 
 for fgbg in 38; do for color in {0..256} ; do 
 echo -en "\\033[${fgbg};5;${color}m ${color}\t\\033[0m"; 
 (($((${color}+1))%10==0)) && echo; done; echo; done
} 

if [[ ! $# -eq 1 || ${1} =~ ^-. ]]; then 
  show_colors 
  echo " Usage: ${0##*/} <color fg>" 
  echo "  E.g. echo \"Hello world!\" | figlet | ${0##*/} 54" 
else  
 while IFS= read -r PIPED_INPUT || { DONE=1; ADD_LF=""; }; do 
  PIPED_INPUT=$(sed 's#\\#\\\\#g' <<< "${PIPED_INPUT}")
  INPUT_TXT="${INPUT_TXT}${PIPED_INPUT}${ADD_LF}"
  ((${DONE})) && break; 
 done
 echo -en "${COLOR_OUT}${INPUT_TXT}\\033[00m"
fi
