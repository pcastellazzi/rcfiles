#!/usr/bin/env bash
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

CALENDAR_VERSION=v$(date +%Y%m%d)
LAST_MASTER_COMMIT=$(git rev-list -n 1 master)
LOG_MESSAGES=$(
	git log master.."${SOURCE_BRANCH}" \
		--pretty=format:"* %s" \
		--reverse \
		--not "${LAST_MASTER_COMMIT}"
)

git merge -X theirs --squash "${SOURCE_BRANCH}"
git commit -m "$(printf "%s\n\n%s" "${CALENDAR_VERSION}" "${LOG_MESSAGES}")"
