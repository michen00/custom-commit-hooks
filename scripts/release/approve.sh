#!/bin/sh
# Approve the release waiting on the protected `release` environment.
#
# Usage: approve.sh [--status] [--yes]
#
# A merged release PR does not ship on its own. release-tag.yml is gated on the
# `release` environment, so it sits in `waiting` until a maintainer approves it.
# Nothing times out and nothing sends a reminder, so a prepared release can sit
# indefinitely while Release PR's own guard refuses to prepare the next one.
# Finding that run in the Actions UI is the only step between a merged PR and a
# signed tag; this turns it into one command.
#
# --status reports where a release stands and changes nothing.
#
# Approving mints a GPG-signed tag, so a bare run prints the tag it would create
# and the commit that tag would point at, then asks for confirmation. --yes
# skips the prompt and is required when stdin is not a terminal.
#
# The branch name is parsed through parse-version.sh for the same reason the
# workflows do it: it decides what gets tagged, so a `case` glob that also
# matches `v1.0.0; rm -rf /` is not good enough.
#
# Requires an authenticated `gh` and `jq`. Exits 1 when nothing is waiting.

set -eu

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
WORKFLOW="release-tag.yml"

usage() {
	echo "Usage: $0 [--status] [--yes]" >&2
	exit 2
}

die() {
	echo "Error: $1" >&2
	exit 1
}

mode="approve"
assume_yes=0

while [ "$#" -gt 0 ]; do
	case "$1" in
	--status) mode="status" ;;
	--yes | -y) assume_yes=1 ;;
	-h | --help) usage ;;
	*) usage ;;
	esac
	shift
done

for tool in gh jq; do
	command -v "$tool" >/dev/null 2>&1 ||
		die "$tool is required but not installed."
done

repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)" ||
	die "Could not resolve the repository. Is gh authenticated?"

# --limit 1 is safe because release-tag.yml sets `concurrency: release-tag`
# without cancel-in-progress, so at most one of its runs is ever awaiting
# approval.
waiting="$(gh run list --workflow="$WORKFLOW" --status waiting --limit 1 \
	--json databaseId,headBranch,headSha,url)" ||
	die "Could not list $WORKFLOW runs."

run_id="$(printf '%s' "$waiting" | jq -r '.[0].databaseId // empty')"

if [ "$mode" = "status" ]; then
	# `gh release view` exits non-zero both when no release exists and when the
	# call fails, so a bare `|| echo none` reports an outage as an empty
	# repository. `list` returns `[]` for the first and still fails for the
	# second, which is the distinction a status command owes the reader.
	releases="$(gh release list --limit 1 --json tagName)" ||
		die "Could not read releases."
	latest="$(printf '%s' "$releases" | jq -r '.[0].tagName // "none"')"
	echo "Latest release:   $latest"

	# --limit because the default page is 30: a release PR sitting behind thirty
	# other open PRs would otherwise be reported as absent.
	open_pr="$(gh pr list --state open --limit 100 \
		--json number,title,headRefName \
		--jq '[.[] | select(.headRefName | startswith("release/"))]
		      | map("#\(.number) \(.title)") | join(", ") // empty')" ||
		die "Could not list open pull requests."
	echo "Open release PR:  ${open_pr:-none}"

	if [ -n "$run_id" ]; then
		branch="$(printf '%s' "$waiting" | jq -r '.[0].headBranch')"
		url="$(printf '%s' "$waiting" | jq -r '.[0].url')"
		echo "Awaiting approval: ${branch#release/} — $url"
		echo
		echo "Run 'make release-approve' to approve it."
	else
		echo "Awaiting approval: none"
	fi

	exit 0
fi

[ -n "$run_id" ] ||
	die "No $WORKFLOW run is awaiting approval. Nothing to release."

branch="$(printf '%s' "$waiting" | jq -r '.[0].headBranch')"
run_url="$(printf '%s' "$waiting" | jq -r '.[0].url')"

tag="$("$SCRIPT_DIR/parse-version.sh" "${branch#release/}" --require-v)" ||
	die "Branch '$branch' does not encode a vX.Y.Z tag."

# Deliberately not the run's headSha. That is the release branch tip, but
# release-tag.yml checks out `pull_request.merge_commit_sha` and tags whatever
# it finds there -- and this repository squash-merges, so the two always
# differ. v0.1.2's run reported 3179e83 while the tag landed on 62c098a.
# Naming a commit the tag will never point at is the one thing a confirmation
# prompt must not do.
pr_json="$(gh pr list --state merged --head "$branch" --limit 1 \
	--json number,mergeCommit)" ||
	die "Could not look up the merged pull request for '$branch'."

pr_number="$(printf '%s' "$pr_json" | jq -r '.[0].number // empty')"
merge_sha="$(printf '%s' "$pr_json" | jq -r '.[0].mergeCommit.oid // empty')"

[ -n "$merge_sha" ] ||
	die "No merged pull request with a merge commit found for '$branch'."

pending="$(gh api "repos/$repo/actions/runs/$run_id/pending_deployments")" ||
	die "Could not read pending deployments for run $run_id."

env_count="$(printf '%s' "$pending" | jq 'length')"
[ "$env_count" -gt 0 ] ||
	die "Run $run_id is waiting, but no deployment is pending your approval."

can_approve="$(printf '%s' "$pending" | jq -r 'all(.current_user_can_approve)')"
[ "$can_approve" = "true" ] ||
	die "You are not an approver for the environment gating run $run_id."

env_ids="$(printf '%s' "$pending" | jq -c '[.[].environment.id]')"
env_names="$(printf '%s' "$pending" | jq -r '[.[].environment.name] | join(", ")')"

cat <<SUMMARY
Release awaiting approval
  Tag to mint:  $tag
  Commit:       $merge_sha
  From PR:      #$pr_number ($branch)
  Environment:  $env_names
  Run:          $run_url

Approving creates and pushes a GPG-signed tag, then publishes signed artifacts.
SUMMARY

if [ "$assume_yes" -eq 0 ]; then
	[ -t 0 ] ||
		die "stdin is not a terminal; pass --yes to approve without a prompt."

	printf 'Approve %s? [y/N] ' "$tag"
	read -r reply
	case "$reply" in
	[yY] | [yY][eE][sS]) ;;
	*)
		echo "Aborted. Nothing was approved." >&2
		exit 0
		;;
	esac
fi

jq -nc --argjson ids "$env_ids" \
	'{environment_ids: $ids, state: "approved",
	  comment: "Approved via scripts/release/approve.sh"}' |
	gh api "repos/$repo/actions/runs/$run_id/pending_deployments" \
		--method POST --input - >/dev/null ||
	die "Approval failed for run $run_id."

echo "Approved. $tag will be tagged and published."
echo "Watch it: gh run watch $run_id"
exit 0
