#!/bin/sh
# Approve the release waiting on the protected `release` environment.
#
# Usage: approve.sh [--status] [--yes]
#
# A merged release PR does not ship on its own. Two runs wait on the `release`
# environment in turn: release-tag.yml, which mints the signed tag, and then
# release-publish.yml, which Release Tag dispatches once the tag is pushed and
# which publishes the signed artifacts. Nothing times out and nothing sends a
# reminder, so a prepared release can sit indefinitely while Release PR's own
# guard refuses to prepare the next one. Finding those runs in the Actions UI
# is the only step between a merged PR and a published release; this turns it
# into one command.
#
# --status reports where a release stands and changes nothing.
#
# Approving mints a GPG-signed tag, so a bare run prints the tag it would create
# and the commit that tag would point at, then asks for confirmation. --yes
# skips the prompt and is required when stdin is not a terminal. The one
# confirmation covers both runs: once Release Tag is approved, this waits for
# the Release Publish run that names the same tag and approves it as well.
# RELEASE_APPROVE_TIMEOUT bounds that wait (seconds, default 300) and
# RELEASE_APPROVE_INTERVAL sets how often it looks (seconds, default 5).
#
# A Release Publish run that is already waiting is approved first, on its own
# confirmation. That is the run left behind when the wait above timed out or
# Release Tag was approved on GitHub, and the run a manual dispatch creates.
#
# The publish job also holds the release key, and a run's name is set by the
# run's own workflow file, read from whichever ref the run started on. So a
# publish run is approved only when it started from a file already on main or
# in the tag: the dispatch on main that Release Tag makes or a maintainer
# repeats by hand, or a push of the tag itself. The run that follows a Release
# Tag approval must be that dispatch.
#
# The branch name is parsed through parse-version.sh for the same reason the
# workflows do it: it decides what gets tagged, so a `case` glob that also
# matches `v1.0.0; rm -rf /` is not good enough. The tag a Release Publish run
# names is parsed the same way.
#
# Requires an authenticated `gh` and `jq`. Exits 1 when nothing is waiting.

set -eu

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
TAG_WORKFLOW="release-tag.yml"
PUBLISH_WORKFLOW="release-publish.yml"
# release-publish.yml sets its run name to this prefix followed by the tag.
PUBLISH_PREFIX="Release Publish "

timeout="${RELEASE_APPROVE_TIMEOUT:-300}"
interval="${RELEASE_APPROVE_INTERVAL:-5}"

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

# A leading zero is refused because $((...)) would read the value as octal.
case "$timeout" in
  '' | *[!0-9]* | 0?*) die "RELEASE_APPROVE_TIMEOUT must be a whole number of seconds." ;;
esac
case "$interval" in
  '' | *[!0-9]* | 0?*) die "RELEASE_APPROVE_INTERVAL must be a whole number of seconds." ;;
esac
[ "$interval" -gt 0 ] || die "RELEASE_APPROVE_INTERVAL must be at least 1."

for tool in gh jq; do
  command -v "$tool" > /dev/null 2>&1 ||
    die "$tool is required but not installed."
done

repo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)" ||
  die "Could not resolve the repository. Is gh authenticated?"

# waiting_run <workflow> -- prints the workflow's newest run awaiting approval,
# as a JSON array of at most one. Both release workflows set a concurrency
# group without cancel-in-progress, so at most one run of each that uses main's
# workflow file is ever awaiting approval. A run started from another ref can
# be the newest instead; the origin checks below refuse it rather than look
# past it.
waiting_run() {
  gh run list --workflow="$1" --status waiting --limit 1 \
    --json databaseId,displayTitle,event,headBranch,headSha,url ||
    die "Could not list $1 runs."
}

# publish_tag <waiting-json> -- prints the tag a waiting Release Publish run
# names, or fails when its run name does not end in a clean vX.Y.Z.
publish_tag() {
  title="$(printf '%s' "$1" | jq -r '.[0].displayTitle')"
  "$SCRIPT_DIR/parse-version.sh" "${title#"$PUBLISH_PREFIX"}" --require-v \
    2> /dev/null
}

# publish_origin <waiting-json> -- prints "<event> <branch>" for the run: what
# started it, and the name of the ref its workflow file was read from.
publish_origin() {
  printf '%s' "$1" | jq -r '.[0] | "\(.event) \(.headBranch)"'
}

# require_trusted_commit <origin> <tag> <tag-commit> <waiting-json> <run-url> --
# refuses unless the run started on a commit its origin vouches for. The origin
# checks compare bare ref names, so a tag named main, or a branch named like the
# release tag, reads the same as the real ref, and its workflow file is whatever
# that ref carries. A push of the tag has to start on the commit the tag points
# at. A dispatch on main has to start on a commit in main's history; main can
# move on between the dispatch and the approval.
require_trusted_commit() {
  run_commit="$(printf '%s' "$4" | jq -r '.[0].headSha // empty')"
  [ -n "$run_commit" ] ||
    die "Release Publish for $2 reports no head commit: $5. Reject it on GitHub, then run this again."
  if [ "$1" = "workflow_dispatch main" ]; then
    # refs/heads/ because a bare name also matches a tag.
    relation="$(gh api "repos/$repo/compare/$run_commit...refs/heads/main" --jq .status)" ||
      die "Could not compare commit $run_commit with main: $5. Reject it on GitHub, then run this again."
    case "$relation" in
      identical | ahead) ;;
      *)
        die "Release Publish for $2 started on commit $run_commit, which is not in main's history: $5. Reject it on GitHub, then run this again."
        ;;
    esac
  else
    [ "$run_commit" = "$3" ] ||
      die "Release Publish for $2 started on commit $run_commit, not on $3, which the tag points at: $5. Reject it on GitHub, then run this again."
  fi
}

# check_pending <run-id> -- refuses unless the caller can approve every
# deployment the run waits on, then sets env_ids and env_names for approve.
check_pending() {
  pending="$(gh api "repos/$repo/actions/runs/$1/pending_deployments")" ||
    die "Could not read pending deployments for run $1."

  env_count="$(printf '%s' "$pending" | jq 'length')"
  [ "$env_count" -gt 0 ] ||
    die "Run $1 is waiting, but no deployment is pending your approval."

  can_approve="$(printf '%s' "$pending" | jq -r 'all(.current_user_can_approve)')"
  [ "$can_approve" = "true" ] ||
    die "You are not an approver for the environment gating run $1."

  env_ids="$(printf '%s' "$pending" | jq -c '[.[].environment.id]')"
  env_names="$(printf '%s' "$pending" | jq -r '[.[].environment.name] | join(", ")')"

  # Both release workflows declare `release` and nothing else.
  [ "$env_names" = "release" ] ||
    die "Run $1 waits on '$env_names', not on the release environment alone."
}

# approve <run-id> -- approves the deployments check_pending found.
approve() {
  jq -nc --argjson ids "$env_ids" \
    '{environment_ids: $ids, state: "approved",
		  comment: "Approved via scripts/release/approve.sh"}' |
    gh api "repos/$repo/actions/runs/$1/pending_deployments" \
      --method POST --input - > /dev/null ||
    die "Approval failed for run $1."
}

# confirm <what> -- asks before approving, unless --yes was given.
confirm() {
  [ "$assume_yes" -eq 0 ] || return 0

  [ -t 0 ] ||
    die "stdin is not a terminal; pass --yes to approve without a prompt."

  printf 'Approve %s? [y/N] ' "$1"
  read -r reply
  case "$reply" in
    [yY] | [yY][eE][sS]) ;;
    *)
      echo "Aborted. Nothing was approved." >&2
      exit 0
      ;;
  esac
}

# wait_for_publish <tag> <tag-run-id> -- waits for the Release Publish run the
# approved Release Tag run dispatches, then sets publish_id and publish_url.
# Release Tag dispatches it only after pushing the tag, so it typically appears
# within a minute. Stops early when Release Tag ends without success, since no
# publish run will follow, and refuses a waiting run that names another tag.
wait_for_publish() {
  waited=0
  while :; do
    found="$(waiting_run "$PUBLISH_WORKFLOW")" || exit 1
    publish_id="$(printf '%s' "$found" | jq -r '.[0].databaseId // empty')"
    if [ -n "$publish_id" ]; then
      publish_url="$(printf '%s' "$found" | jq -r '.[0].url')"
      found_tag="$(publish_tag "$found")" ||
        die "A Release Publish run is waiting, but its name gives no vX.Y.Z tag: $publish_url"
      [ "$found_tag" = "$1" ] ||
        die "Release Publish for $found_tag is waiting ahead of $1: $publish_url. Approve or reject it, then run this again."
      [ "$(publish_origin "$found")" = "workflow_dispatch main" ] ||
        die "Release Publish for $1 is waiting, but it was not dispatched on main as Release Tag does: $publish_url. Reject it on GitHub, then run this again."
      require_trusted_commit "workflow_dispatch main" "$1" "" "$found" "$publish_url"
      return 0
    fi

    state="$(gh run view "$2" --json status,conclusion \
      --jq '"\(.status) \(.conclusion)"')" ||
      die "Could not read the state of run $2."
    case "$state" in
      "completed success") ;;
      completed*)
        die "Release Tag run $2 ended without success (${state#completed }). Nothing was approved for publishing; if the tag was pushed anyway, publish it with the manual fallback in RELEASING.md."
        ;;
    esac

    [ "$waited" -lt "$timeout" ] ||
      die "Release Publish for $1 has not reached its approval after ${timeout}s; run this again once it has."
    sleep "$interval"
    waited=$((waited + interval))
  done
}

tag_waiting="$(waiting_run "$TAG_WORKFLOW")" || exit 1
tag_run="$(printf '%s' "$tag_waiting" | jq -r '.[0].databaseId // empty')"

publish_waiting="$(waiting_run "$PUBLISH_WORKFLOW")" || exit 1
publish_id="$(printf '%s' "$publish_waiting" | jq -r '.[0].databaseId // empty')"

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

  if [ -n "$tag_run" ]; then
    branch="$(printf '%s' "$tag_waiting" | jq -r '.[0].headBranch')"
    url="$(printf '%s' "$tag_waiting" | jq -r '.[0].url')"
    echo "Awaiting approval: ${branch#release/} tag — $url"
  fi
  if [ -n "$publish_id" ]; then
    url="$(printf '%s' "$publish_waiting" | jq -r '.[0].url')"
    tag="$(publish_tag "$publish_waiting")" || tag="(unnamed)"
    echo "Awaiting approval: $tag publish — $url"
  fi

  if [ -n "$tag_run$publish_id" ]; then
    echo
    echo "Run 'make release-approve' to approve."
  else
    echo "Awaiting approval: none"
  fi

  exit 0
fi

if [ -n "$publish_id" ]; then
  publish_url="$(printf '%s' "$publish_waiting" | jq -r '.[0].url')"
  tag="$(publish_tag "$publish_waiting")" ||
    die "A Release Publish run is waiting, but its name gives no vX.Y.Z tag: $publish_url. Reject it on GitHub, then run this again."

  origin="$(publish_origin "$publish_waiting")"
  case "$origin" in
    "workflow_dispatch main" | "push $tag") ;;
    *)
      die "Release Publish for $tag is waiting, but it started from '$origin' rather than a dispatch on main or a push of the tag: $publish_url. Reject it on GitHub, then run this again."
      ;;
  esac

  # refs/tags/ because a bare name also matches a branch, whose tip is not
  # what the run checks out.
  commit="$(gh api "repos/$repo/commits/refs/tags/$tag" --jq .sha)" ||
    die "Tag $tag does not resolve to a commit, so Release Publish would fail: $publish_url. Reject it on GitHub, then run this again."
  require_trusted_commit "$origin" "$tag" "$commit" "$publish_waiting" "$publish_url"

  check_pending "$publish_id"

  cat << SUMMARY
Release Publish awaiting approval
  Tag:          $tag
  Commit:       $commit
  Started by:   ${origin%% *} on ${origin#* }
  Environment:  $env_names
  Run:          $publish_url

Approving builds signed artifacts from $tag and uploads them to its release.
SUMMARY

  confirm "publishing $tag"
  approve "$publish_id"

  echo "Approved. $tag will be published."
  echo "Watch it: gh run watch $publish_id"
  if [ -n "$tag_run" ]; then
    echo "A Release Tag run is waiting as well; run this again for it."
  fi
  exit 0
fi

[ -n "$tag_run" ] ||
  die "No release run is awaiting approval. Nothing to release."

branch="$(printf '%s' "$tag_waiting" | jq -r '.[0].headBranch')"
run_url="$(printf '%s' "$tag_waiting" | jq -r '.[0].url')"

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

check_pending "$tag_run"

cat << SUMMARY
Release awaiting approval
  Tag to mint:  $tag
  Commit:       $merge_sha
  From PR:      #$pr_number ($branch)
  Environment:  $env_names
  Run:          $run_url

Approving creates and pushes a GPG-signed tag, then approves the Release Publish
run that tag dispatches, which publishes signed artifacts.
SUMMARY

confirm "$tag"
approve "$tag_run"

echo "Approved Release Tag for $tag. Waiting for Release Publish to ask for approval..."
wait_for_publish "$tag" "$tag_run"

check_pending "$publish_id"
approve "$publish_id"

echo "Approved Release Publish. $tag is tagged and will be published."
echo "Watch it: gh run watch $publish_id"
exit 0
