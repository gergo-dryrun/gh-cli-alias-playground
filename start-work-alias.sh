gh alias set --clobber start-work '!f() { \
  if [ "$1" = "--help" ]; then \
    echo "Usage: gh start-work <JIRA_TICKET> [ISSUE_TYPE]"; \
    echo ""; \
    echo "Start work on a new feature by creating a branch and PR"; \
    echo ""; \
    echo "Arguments:"; \
    echo "  JIRA_TICKET    Required. The Jira ticket number/ID"; \
    echo "  ISSUE_TYPE     Optional. Type of issue (default: feature)"; \
    echo "                 Valid values: feature, bug, maintenance"; \
    echo ""; \
    echo "Options:"; \
    echo "  --help         Show this help message"; \
    return 0; \
  fi; \
  JIRA_TICKET="$1"; \
  ISSUE_TYPE=${2:-feature}; \
  if [[ -z "$JIRA_TICKET" ]]; then echo "Error: JIRA_TICKET_NUMBER is required"; exit 1; fi; \
  if [[ ! "$ISSUE_TYPE" =~ ^(feature|bug|maintenance)$ ]]; then \
    echo "Error: ISSUE_TYPE must be feature, bug, or maintenance"; \
    exit 1; \
  fi; \
  if ! git remote get-url origin >/dev/null 2>&1; then \
    echo "Error: No origin remote found. Please set up your git remote first."; \
    echo "Use: git remote add origin <repository-url>"; \
    exit 1; \
  fi; \
  REPO=$(git config --get remote.origin.url | sed "s/.*github.com[:/]\(.*\)\.git/\1/"); \
  BRANCH_NAME="${ISSUE_TYPE}/${JIRA_TICKET// /_}"; \
  git checkout -b "$BRANCH_NAME" && \
  echo "# ${BRANCH_NAME}" > .changes.md && \
  git add .changes.md && \
  git commit -m "chore: initialize ${BRANCH_NAME}" && \
  git push -u origin "$BRANCH_NAME" && \
  gh pr create --repo "$REPO" --title "$BRANCH_NAME" --body "Work started on $BRANCH_NAME" --base main; \
}; f "$@"'