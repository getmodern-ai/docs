#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://docs.modern.com}"
OUT_DIR="${OUT_DIR:-integrations}"

usage() {
  cat <<'EOF'
Usage:
  scripts/pull-integrations.sh <sidebar-html-file>
  cat sidebar.html | scripts/pull-integrations.sh

Environment variables:
  BASE_URL  Base docs URL (default: https://docs.modern.com)
  OUT_DIR   Output directory for .mdx files (default: integrations)

Input can be any text that contains paths like:
  /sections/integrations/apple-business-manager
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -gt 1 ]]; then
  usage >&2
  exit 1
fi

input_text=""
if [[ $# -eq 1 ]]; then
  if [[ ! -f "$1" ]]; then
    echo "Input file not found: $1" >&2
    exit 1
  fi
  input_text="$(cat "$1")"
else
  if [[ -t 0 ]]; then
    echo "Pass an input file or pipe HTML/text via stdin." >&2
    usage >&2
    exit 1
  fi
  input_text="$(cat)"
fi

mkdir -p "$OUT_DIR"

paths=()
while IFS= read -r line; do
  [[ -n "$line" ]] && paths+=("$line")
done < <(
  printf '%s\n' "$input_text" \
    | grep -oE '/sections/integrations/[a-zA-Z0-9-]+' \
    | awk '!seen[$0]++'
)

if [[ ${#paths[@]} -eq 0 ]]; then
  echo "No /sections/integrations/... paths found in input." >&2
  exit 1
fi

ok=0
failed=0

for path in "${paths[@]}"; do
  slug="${path##*/}"
  source_url="${BASE_URL}${path}.md"
  target_file="${OUT_DIR}/${slug}.mdx"

  echo "Downloading ${source_url} -> ${target_file}"
  if curl --fail --silent --show-error --location "$source_url" --output "$target_file"; then
    ok=$((ok + 1))
  else
    echo "Failed: ${source_url}" >&2
    rm -f "$target_file"
    failed=$((failed + 1))
  fi
done

echo "Done. Downloaded: ${ok}, Failed: ${failed}"

if [[ $failed -gt 0 ]]; then
  exit 2
fi
