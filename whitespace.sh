#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2016-01-09 18:50:56 +0000 (Sat, 09 Jan 2016)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help improve or steer this or other code I publish
#
#  http://www.linkedin.com/in/harisekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$srcdir/utils.sh"

section "Checking Whitespace"

start_time="$(start_timer)"

. "$srcdir/excluded.sh"

progress_char='.'
[ -n "${DEBUG:-}" ] && progress_char=''

whitespace_only_files_found=0
trailing_whitespace_files_found=0
trailing_whitespace_bar_files_found=0
for filename in $(find "${1:-.}" -type f | egrep -vf "$srcdir/whitespace_ignore.txt"); do
    isExcluded "$filename" && continue
    printf "%s" "$progress_char"
    # TODO: [[:space:]] matches \r in Windows files which we don't want, try explicit character class instead
    grep -Hn '^[[:space:]]\+$' "$filename" && let whitespace_only_files_found+=1 || :
    grep -Hn '[[:space:]]\+$' "$filename" && let trailing_whitespace_files_found+=1 || :
    egrep -Hn '[[:space:]]{4}\|[[:space:]]*$' "$filename" && let trailing_whitespace_bar_files_found+=1 || :
done
if [ $whitespace_only_files_found -gt 0 ]; then
    echo "$whitespace_only_files_found files with whitespace only lines detected!"
fi
if [ $trailing_whitespace_files_found -gt 0 ]; then
    echo "$trailing_whitespace_files_found files with trailing whitespace lines detected!"
fi
if [ $trailing_whitespace_bar_files_found -gt 0 ]; then
    echo "$trailing_whitespace_bar_files_found files with trailing whitespace bar lines detected!"
fi
if [ $whitespace_only_files_found -gt 0 -o $trailing_whitespace_files_found -gt 0 -o  $trailing_whitespace_bar_files_found -gt 0 ]; then
    return 1 &>/dev/null || :
    exit 1
fi

time_taken "$start_time"
section2 "Whitespace only checks passed"
echo
