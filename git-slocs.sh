#!/bin/sh
# @file: git-slocs.sh
# @auth: Sprax Lines
# @date: 2019.12.23
#
# Count all source lines of code (SLOCS) under the current directory,
# attribute each one (including blanks) to an author, group them,
# sort by slocs/week since each author's first commit, and output:
# slocs/week    author  total   first-date  first-commit-hash

default_code='*.cc *.h *.md *.sh *.txt *.yaml */*.cc */*.h */*.hpp */*.md */*.py */*.sh */*.yml .*/*.yml .circleci/*/*/Dockerfile */*.txt */*/*.cc */*/*.h'
code_pattern=${1:-$default_code}

if [[ $# -gt 1 ]] ; then
  echo "Usage: git-slocs.sh code-glob-pattern"
  exit 0
fi

git ls-tree -r -z --name-only HEAD -- $code_pattern \
    | xargs -0 -n1 git blame -t --name-only \
    | gawk '{ \
        if (gsub(/^\(/, "", $2 )) \
            printf "%d %s %s %s\n", $4, $1, $2, $3; \
        else if (gsub(/^\(/, "", $3 )) \
            printf "%d %s %s %s\n", $5, $1, $3, $4; \
        else
            print "BAD LINE: " $0; \
    }' \
    | sort -k3,4 | uniq -c -f2 \
    | gawk '{printf "%8.3f slocs/week %10s %12-s %7d source lines since %s (first commit %s)\n" \
    , $1*7*86400.0/(systime() - $2), $4, $5, $1, strftime("%c", $2), $3}' | sort -gr | head -20


# DEBUG:
# For debugging a small sample, insert this line after the xargs line:
#   | grep 'states_manager.h' | head -7 \

# CRUFT:
#     | gawk '{printf "%d %s %s %s\n", $4, $1, gensub(/^\(/, "", 1, $2), $3}' \
#     | sort -k3,4 | uniq -c -f2 \
#     | gawk '{printf "%8.3f lines/week %10s %12-s %7d total since %s (first commit %s)\n" \
#     , $1*7*86400.0/(systime() - $2), $4, $5, $1, strftime("%c", $2), $3}' | sort -gr | head -20
#
# #    | grep -v '^0' \
