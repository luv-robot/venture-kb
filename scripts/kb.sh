#!/usr/bin/env bash
set -euo pipefail

KB_ROOT="${KB_ROOT:-$HOME/knowledge/venture-kb}"

cd "$KB_ROOT"

cmd="${1:-}"

slugify() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/[^a-z0-9._-]/-/g' \
    | sed 's/-\+/-/g' \
    | sed 's/^-//' \
    | sed 's/-$//'
}

ensure_git_clean_warning() {
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "[kb] warning: repo has uncommitted changes."
  fi
}

update_index() {
  cat > INDEX.md <<'EOF'
# Knowledge Base Index

Generated automatically by `scripts/kb.sh index`.

EOF

  {
    echo "## Projects"
    echo
    find 10-projects -name "*.md" | sort | while read -r file; do
      title="$(basename "$file" .md)"
      echo "- [${title}](${file})"
    done

    echo
    echo "## Playbooks"
    echo
    find 20-playbooks -name "*.md" | sort | while read -r file; do
      title="$(basename "$file" .md)"
      echo "- [${title}](${file})"
    done

    echo
    echo "## Decisions"
    echo
    find 30-decisions -name "*.md" | sort | while read -r file; do
      title="$(basename "$file" .md)"
      echo "- [${title}](${file})"
    done

    echo
    echo "## Research"
    echo
    find 50-research -name "*.md" | sort | while read -r file; do
      title="$(basename "$file" .md)"
      echo "- [${title}](${file})"
    done

    echo
    echo "## Inbox"
    echo
    find 00-inbox -name "*.md" | sort | while read -r file; do
      title="$(basename "$file" .md)"
      echo "- [${title}](${file})"
    done
  } >> INDEX.md

  echo "[kb] INDEX.md updated."
}

sync_repo() {
  msg="${1:-Update knowledge base}"
  git add .
  if git diff --cached --quiet; then
    echo "[kb] nothing to commit."
  else
    git commit -m "$msg"
  fi
  git push
}

capture_clipboard() {
  area="${1:-inbox}"
  name="${2:-note-$(date +%Y-%m-%d-%H%M%S)}"

  slug="$(slugify "$name")"

  case "$area" in
    inbox)
      dir="00-inbox"
      ;;
    playbook)
      dir="20-playbooks"
      ;;
    decision)
      dir="30-decisions"
      ;;
    research)
      dir="50-research"
      ;;
    project:*)
      project="${area#project:}"
      project_slug="$(slugify "$project")"
      dir="10-projects/$project_slug"
      ;;
    *)
      echo "Unknown area: $area"
      echo "Use: inbox | playbook | decision | research | project:<name>"
      exit 1
      ;;
  esac

  mkdir -p "$dir"
  file="$dir/$slug.md"

  if [ -f "$file" ]; then
    echo "[kb] file already exists: $file"
    exit 1
  fi

  {
    echo "---"
    echo "type: draft"
    echo "project: $area"
    echo "status: draft"
    echo "updated: $(date +%F)"
    echo "tags: []"
    echo "---"
    echo
    pbpaste
  } > "$file"

  echo "[kb] captured clipboard to $file"
}

new_project() {
  project="${1:?Project name required}"
  project_slug="$(slugify "$project")"
  dir="10-projects/$project_slug"

  mkdir -p "$dir"

  cat > "$dir/product-brief.md" <<EOF
---
type: project
project: $project_slug
status: active
updated: $(date +%F)
tags: []
---

# $project Product Brief

## One-line Summary

TODO

## Core Thesis

TODO

## Target Users

TODO

## Core Problem

TODO

## Product Direction

TODO

## Current Working Assumptions

TODO

## Open Questions

- TODO

## Related Notes

- 
EOF

  cat > "$dir/open-questions.md" <<EOF
---
type: question
project: $project_slug
status: active
updated: $(date +%F)
tags: [open-questions]
---

# $project Open Questions

## Product

- TODO

## Technical

- TODO

## Business

- TODO

## Risks

- TODO

## Related Notes

- [[10-projects/$project_slug/product-brief]]
EOF

  echo "[kb] project created: $dir"
}

case "$cmd" in
  index)
    update_index
    ;;

  sync)
    update_index
    sync_repo "${2:-Update knowledge base}"
    ;;

  capture)
    capture_clipboard "${2:-inbox}" "${3:-note-$(date +%Y-%m-%d-%H%M%S)}"
    update_index
    ;;

  new-project)
    new_project "${2:?Project name required}"
    update_index
    ;;

  *)
    cat <<'EOF'
Usage:

  scripts/kb.sh index
    Update INDEX.md.

  scripts/kb.sh sync "commit message"
    Update INDEX.md, git commit, and push.

  scripts/kb.sh capture inbox "note title"
    Save clipboard content into 00-inbox/.

  scripts/kb.sh capture playbook "macos proxy"
    Save clipboard content into 20-playbooks/.

  scripts/kb.sh capture decision "agent tooling roles"
    Save clipboard content into 30-decisions/.

  scripts/kb.sh capture research "crypto event strategy"
    Save clipboard content into 50-research/.

  scripts/kb.sh capture project:quant-odyssey "product brief"
    Save clipboard content into 10-projects/quant-odyssey/.

  scripts/kb.sh new-project "Quant Odyssey"
    Create project directory with product-brief.md and open-questions.md.
EOF
    ;;
esac
