#!/bin/sh
# file: git-authors.sh:

default_code='*.cc *.h *.md *.sh *.txt *.yaml */*.cc */*.h */*.hpp */*.md */*.py */*.sh */*.yml .*/*.yml .circleci/*/*/Dockerfile */*.txt */*/*.cc */*/*.h'
code_pattern=${1:-$default_code}

if [[ $# -gt 1 ]] ; then
  echo "Usage: git-authors.sh code-glob-pattern"
  exit 0
fi

git ls-tree -r -z --name-only HEAD -- $code_pattern|xargs -0 -n1 git blame --line-porcelain|grep  "^author "|sort|uniq -c|sort -nr

