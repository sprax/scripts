#!/bin/sh
# @file: git-guilt.sh
# @auth: Sprax Lines
# @date: 2019.12.18
#
# Displays git guilt numbers for the last N weeks (default N is 4).
# Usage (anywhere in a repository)
#
#   ./git-guilt.sh [num_weeks]

num_weeks=${1:-4}           # N for git guilt in the last N weeks.

if [ $# -gt 1 ]; then
  echo "Usage: $0 [num_weeks]"
  exit 0
fi

# Get most recent commit SHAH up to N weeks ago
start_hash=`git log --until="$num_weeks weeks ago" --format="%H" -n 1`
git_guilt=`git guilt --ignore-whitespace $start_hash`
echo "$git_guilt"   # preserve whitespace here; eat it when parsing later.
echo "================================================================================"
