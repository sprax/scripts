#!/bin/sh
# file: git-com-date.sh

if [[ $# -ne 2 ]] ; then
  echo 'Usage:   git-dated-commit.sh date message'
  echo 'Example: git-dated-commit.sh 2019-10-11T12:34:56 "fixed and dated merge"'
  exit 0
fi

GIT_AUTHOR_DATE=$1 GIT_COMMITTER_DATE=$1 git commit -am "$2"
