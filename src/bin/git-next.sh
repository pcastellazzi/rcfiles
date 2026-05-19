#!/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

abort() {
	local message="$*"
	2>&1 echo "${message}"
	exit 1
}

SOURCE_BRANCH=${1:-next}
if ! git show-ref --verify --quiet refs/heads/"${SOURCE_BRANCH}"; then
	abort "Branch ${SOURCE_BRANCH} does not exist."
fi

CURRENT_BRANCH=$(git branch --show-current)
if [[ "${CURRENT_BRANCH}" != "master" ]]; then
	abort "Current branch is ${CURRENT_BRANCH}, not master. Switch to master first."
fi

LOG_MESSAGES=$(
    git log master.."${SOURCE_BRANCH}" \
        --pretty=format:"* %s" \
        --reverse \
        --not "$(git rev-list -n 1 master)"
)

CALENDAR_VERSION=v$(date +%Y%m%d)

git merge -X theirs --squash "${SOURCE_BRANCH}"
git commit -m "$(printf "${CALENDAR_VERSION}\n\n${LOG_MESSAGES}")"
