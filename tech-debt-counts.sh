#!/bin/sh
# @file: tech-debt-counts.sh
# Counts tech-debt markers grouped by author-tag.
# Searches recursively from the directory where it is invoked.
# By default, it matches lines such as these:
#     /// TODO @user1/@sprax: #document.
#     if (utensil_type.find("tongs") != string::npos) { // FIXME @user1, @user2 dumb hack
# But only the first author-tag is counted; in these examples: user1 and user2
# Btw, if you run this script on itself, it *might* count the above examples.

debt_regex=${1:-"(FIXME|TODO):?\\s+"}           # technical-debt marker up to the @-sign.
name_regex=${2:-"(@\\w+)"}                      # author tag-name: begins with @, ends with WS/punctuation
re_pattern=${3:-"${debt_regex}${name_regex}"}   # combined pattern -- Caution: $3 does not replace $1 & $2

if [[ $# -gt 3 ]] ; then
  echo "Usage: $0 [todo-regex [name-regex [combo-regex]]]"
  exit 0
fi

exclude_dirs='--exclude-dir=build* --exclude-dir=external*'

# NOTE: Don't use '--include=.*\.c*', because that would include "doh.cc.bak", "duh.crap", etc.
include_source='--include=.*\.c --include=.*\.cc --include=.*\.cpp'
include_header='--include=.*\.h --include=.*\.hh --include=.*\.hpp'
include_all_cc="$include_source $include_header"

include_script='--include=.*\.bash --include=.*\.sh'
include_python='--include=.*\.py' # but not *.pyc

include_srcs="$include_all_cc $include_script $include_python"

# Try (sorta) to exclude this script from its own counts.
egrep -IRi --exclude="$0" $exclude_dirs $include_srcs "$re_pattern" . 2>&1 \
| grep -v "No such file" \
| gsed -E "s/^.*${debt_regex}${name_regex}/\\2 /I" \
| awk '{print $1}' \
| tr '[:upper:]' '[:lower:]' \
| sort | uniq -c | sort -nr

echo "---- -----"
egrep -IRSi $exclude_dirs $include_srcs "$debt_regex" . 2>&1 \
| grep -v "No such file" \
| gsed -E "s/^.*(${debt_regex})/\\2 /I" \
| awk '{print $1}' \
| tr '[:lower:]' '[:upper:]' \
| sort | uniq -c | sort -nr
