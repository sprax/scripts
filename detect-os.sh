#!/bin/sh
# @file: git-log-times.sh
# @auth: Sprax Lines
# @date: 2019.12.27
#
# Filter all log entries for the current repository
# to only those with both Author and Data fields,
# sort and group them by Author,
# count them (get the total for each author using `uniq`,
# sort again by date, and
# output columns formatted as:
#
# timestamp  author_first author_last  count  datetime(timestamp)

count_merges=${1:-0}    # default for whether to count merge commits is 0 = False.

if [[ $# -gt 1 ]] ; then
  echo "Usage: git-log-times.sh [1 = count merge commits, too]"
  exit 0
fi

# Detect the OS using `uname`; :
# export OS=`uname -s | tr [:upper:] [:lower:]`
case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
    OS_NAME=linux
    ;;
  darwin*)
    OS_NAME=darwin
    ;;
  msys*)
    OS_NAME=windows
    ;;
  *)
    OS_NAME=unknown
    ;;
esac

git log --use-mailmap --date=unix \
    | awk -v merges="$count_merges" 'RS="commit" { \
        if ($2 == "Author:" && $6 == "Date:")   # regular
            printf "%s\t%s %s\n", $7, $3, $4; \
        else if (merges && $5 == "Author:" && $9 == "Date:") # merge \
            printf "%s\t%s %s\n", $10, $6, $7;}' \
    | sort -k2,3 \
    | uniq -f1 -c \
    | awk '{printf "%d %10s %-12s %5d\n", $2, $3, $4, $1;}' \
    | sort
