#!/bin/sh
# file: git-dated-commit.sh
message=${1:-'"fixed and dated merge"'}

def_date=2020-08-29T06:54:32
date_str=${2:-$def_date}

if [[ $# -lt 1 ]] ; then
  echo "Usage: git-dated-commit.sh message date"
  echo "Example: $0 $message $date_str"
  exit 0
fi

GIT_AUTHOR_DATE=$date_str GIT_COMMITTER_DATE=$date_str git commit -m "$message"
