#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2022-07-15 11:16:44 +0100 (Fri, 15 Jul 2022)
#
#  https://github.com/HariSekhon/DevOps-Bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
. "$srcdir/lib/github.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Opens a GitHub Pull Request preview page from the current local branch to the default branch

Useful to call from aliases/functions to quickly push a new branch, preview and raise a PR with a mere couple keystrokes
See .bash.d/git.sh for where this is used

Prints the Pull Request URL, and if on Mac or if \$BROWSER is set then opens it for you in your default browser

Assumes that GitHub is the remote origin, and checks for this for safety
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#min_args 1 "$@"

check_github_origin

owner_repo="$(github_origin_owner_repo)"

# checks are done inside github_origin_owner_repo() now
#if [ -z "$owner_repo" ]; then
#    die 'Failed to find origin remote pointing to github.com! Are we in a github checkout?'
#fi

current_branch="$(current_branch)"

default_branch="$(default_branch)"

#url="https://github.com/$owner_repo/pull/new/$branch"
# from your current branch to the default branch by default
url="https://github.com/$owner_repo/compare/$default_branch...$current_branch"

echo
echo "Pull Request URL:"
echo
printf '\t%s\n' "$url"

if is_mac; then
    echo
    echo "Opening Pull Request"
    open "$url"
elif [ -n "${BROWSER:-}" ]; then
    echo
    echo "Opening Pull Request using \$BROWSER"
    "$BROWSER" "$url"
else
    echo
    echo "\$BROWSER environment variable not set and not on Mac to use default browser, not opening browser"
fi
