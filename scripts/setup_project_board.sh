#!/usr/bin/env bash
# setup_project_board.sh - create a GitHub Projects v2 board for this
# repo and add every open issue to it, grouping by priority/chapter.
#
# Prerequisites:
#   - gh CLI authenticated
#   - the gh token must have the `project` scope.  If you see
#     "Your token has not been granted the required scopes", run:
#         gh auth refresh -s project,read:project
#
# Idempotent: re-running adds any new issues without duplicating items
# already on the board.

set -euo pipefail

OWNER="JonCYeh"
REPO="peter-weyl-lean"
BOARD_TITLE="Peter-Weyl Formalization"

# 1. Find or create the user-owned Project v2.
echo "Looking for existing project '$BOARD_TITLE' ..."
PROJECT_NUMBER=$(gh project list --owner "$OWNER" --format json 2>/dev/null \
  | jq -r --arg t "$BOARD_TITLE" '.projects[] | select(.title==$t) | .number' | head -1 || true)

if [ -z "$PROJECT_NUMBER" ]; then
  echo "Creating project '$BOARD_TITLE' ..."
  PROJECT_NUMBER=$(gh project create --owner "$OWNER" --title "$BOARD_TITLE" --format json | jq -r '.number')
fi
echo "Project number: $PROJECT_NUMBER"
PROJECT_URL=$(gh project view "$PROJECT_NUMBER" --owner "$OWNER" --format json | jq -r '.url')

# 2. Add every open issue from the repo to the project (idempotent: gh
#    surfaces a friendly "already in project" message that we ignore).
echo "Adding open issues from $OWNER/$REPO ..."
gh issue list --repo "$OWNER/$REPO" --state open --limit 500 --json number,url \
  | jq -r '.[].url' \
  | while read -r URL; do
      if gh project item-add "$PROJECT_NUMBER" --owner "$OWNER" --url "$URL" >/dev/null 2>&1; then
        echo "  added $URL"
      else
        : # already on board
      fi
    done

echo "Done.  Open: $PROJECT_URL"
echo
echo "Suggested next step: in the board UI, group by Labels (filter to"
echo "priority:p1/p2/p3 or chapter:*) or by Status to get kanban columns."
