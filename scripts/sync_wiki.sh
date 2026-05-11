#!/usr/bin/env bash
# sync_wiki.sh - push wiki/ contents up to the GitHub Wiki repo.
#
# GitHub doesn't actually allocate the wiki git repo until at least one
# page has been created via the web UI.  So before this script can work,
# do this once:
#
#   1. Go to https://github.com/JonCYeh/peter-weyl-lean/wiki
#   2. Click "Create the first page"
#   3. Save (the title and content don't matter - we overwrite immediately).
#
# After that, every push to main can run this script (or you can run it
# manually) to keep the wiki in sync with wiki/ in this repo.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WIKI_SRC="$REPO_ROOT/wiki"
WIKI_REMOTE="https://github.com/JonCYeh/peter-weyl-lean.wiki.git"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if [ ! -d "$WIKI_SRC" ]; then
  echo "error: $WIKI_SRC does not exist" >&2
  exit 1
fi

echo "Cloning wiki repo into $WORK ..."
if ! git clone --quiet "$WIKI_REMOTE" "$WORK/wiki" 2>/dev/null; then
  cat >&2 <<EOF
error: could not clone $WIKI_REMOTE

The wiki repo doesn't exist yet.  GitHub only allocates it after the
first wiki page is created.  To bootstrap:

  1. Open https://github.com/JonCYeh/peter-weyl-lean/wiki in a browser
  2. Click "Create the first page"
  3. Save any placeholder content
  4. Re-run this script
EOF
  exit 1
fi

cd "$WORK/wiki"

# Wipe everything except .git, then copy wiki/ source over the top.
find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
cp -R "$WIKI_SRC"/. .

if git diff --quiet && git diff --staged --quiet && [ -z "$(git status --porcelain)" ]; then
  echo "Wiki is already up to date."
  exit 0
fi

git add -A
git -c user.email="${GIT_AUTHOR_EMAIL:-j.conrad1005@gmail.com}" \
    -c user.name="${GIT_AUTHOR_NAME:-JonCYeh}" \
    commit -m "Sync wiki from main repo $(git -C "$REPO_ROOT" rev-parse --short HEAD)"

echo "Pushing wiki ..."
git push origin HEAD

echo "Wiki updated: https://github.com/JonCYeh/peter-weyl-lean/wiki"
