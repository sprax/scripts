#!/bin/sh
# file: git-authors.sh:
# @auth: Sprax Lines
# @date: 2019.10.04
#
# Count all source lines of code (SLOCS) in files under the current directory
# that match the (default) code_pattern,
# attribute each one (including blanks) to an author,
# group them by author [or the given 'search_field'],
# and output in descending order:
#
#   total-slocs    author
#
# Example usage:
# $ ./git-authors.sh author-mail '*.*sh *.py'

# single-quoted "source code"-matching pattern:
default_code='*.cc *.h *.md *.sh *.txt *.yaml */*.cc */*.h */*.hpp */*.md */*.py */*.sh */*.yml .*/*.yml .circleci/*/*/Dockerfile */*.txt */*/*.cc */*/*.h'

# command line arguments with defaults:
search_field=${1:-$author}          # Example: author-mail
code_pattern=${2:-$default_code}    # Example: '*.h*'

if [[ $# -gt 2 ]] ; then
  echo "Usage: git-authors.sh search-field 'code-glob-pattern'"
  exit 0
fi

git ls-tree -r -z --name-only HEAD -- $code_pattern \
    | xargs -0 -n1 git blame --line-porcelain \
    | grep  "^$search_field " \
    | cut -d' ' -f 2- \
    | sort | uniq -c | sort -nr
