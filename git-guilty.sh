#!/bin/sh
# @file: git-guilty.sh
# @auth: Sprax Lines
# @date: 2019.12.18
#
# Counts git guilt numbers for the last N weeks (default N is 4).
# Calls git guilt on logs in each top-level directory that contains a .git file.
#
# Usage: In any parent directory containing one or more repository directories
# (such as fullstack/src or rawks), do:
#   ./git-guilty.sh [num_weeks]

num_weeks=${1:-4}           # N for git guilt in the last N weeks.
# name_regex=${2:-"(@\\w+)"}                      # author tag-name: begins with @, ends with WS/punctuation
# re_pattern=${3:-"${debt_regex}${name_regex}"}   # combined pattern -- Caution: $3 does not replace $1 & $2

if [[ $# -gt 3 ]] ; then
  echo "Usage: $0 [todo-regex [name-regex [combo-regex]]]"
  exit 0
fi

# for tldr in `ls -d .`; do
for tldr in `ls -d */`; do
    if [[ -e $tldr/.git ]]; then
        echo "GIT GUILT for Top Level Directory with git file: $tldr";
        cd $tldr
        # Get most recent commit SHAH up to N weeks ago
        start_hash=`git log --until="$num_weeks weeks ago" --format="%H" -n 1`
        git_guilt=`git guilt --ignore-whitespace $start_hash`
        echo "$git_guilt"   # preserve whitespace here; eat it when parsing later.
        echo "==========================================================="
        ## Add tokens to name until token starts with + or -.
        ## if +- token ends with (number), get that number; else, number = token length * sign(+/-)
        ## Add number to total mapped to name.
        # for token in `echo "${git_guilt}"`; do
        #     echo $token
        #     # garr=(`echo "$line"`)
        #     # size=${#garr[@]}
        #     # echo "-------------------- $size"
        #     # printf '%s\n' "${garr[@]}"
        # done
        cd ..
    else
        echo "$tldr ain't GIT";
    fi;
done
