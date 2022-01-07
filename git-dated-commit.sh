#!/bin/sh
# @file: git-dated-commit.sh
# @auth: Sprax Lines
# @date: 2019-12-24 17:42:09 Tue 24 Dec

message=${1:-'"fixed and dated merge"'}

def_date=2020-11-25T06:54:32
date_str=${2:-$def_date}

def_mins=5
mins_str=${3:-$def_mins}

if [[ $# -lt 1 ]] ; then
  echo "Usage: git-dated-commit.sh message date"
  echo "Example: $0 $message $date_str"
  exit 0
elif [[ $# -gt 2 ]] ; then
  # echo "The default date string ($def_date) is ${#def_date} chars."

  case "$3" in ("" | *[!0-9]*)
    echo "Error: $3 is not a natural number" >&2
    exit 1
  esac

  if [ "$3" -lt 1 ] || [ "$3" -gt 1024 ]; then
    echo "Error: $3 is outside range [1, 1024]" >&2
    exit 1
  fi
  date_str=`date -j -v+${mins_str}M -f "%Y-%m-%dT%H:%M:%S" $def_date "+%Y-%m-%dT%H:%M:%S"`
  # echo "The revised date string ($date_str) is ${#date_str} chars."
  # exit 0
fi

GIT_AUTHOR_DATE=$date_str GIT_COMMITTER_DATE=$date_str git commit -m "$message"
