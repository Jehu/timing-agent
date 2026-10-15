#!/bin/bash
# Install timing-agent for the current user. macOS only: it uses TimingHelper.
# Run locally after a clone, or pipe the raw GitHub file to bash with GITHUB_TOKEN.
set -euo pipefail

repository="${TIMING_AGENT_REPOSITORY:-Jehu/timing-agent}"
branch="${TIMING_AGENT_BRANCH:-main}"
script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
bin_dir="${HOME}/.local/bin"
skill_dir="${HOME}/.agents/skills/timing-track"

if [[ "$(uname)" != Darwin ]]; then
  echo "timing-agent: macOS is required (uses TimingHelper AppleScript)." >&2
  exit 1
fi
if ! command -v osascript >/dev/null; then
  echo "timing-agent: osascript is unavailable." >&2
  exit 1
fi

install -d "$bin_dir" "$skill_dir"
if [[ -f "$script_dir/bin/ta" && -f "$script_dir/skill/SKILL.md" ]]; then
  install -m 755 "$script_dir/bin/ta" "$bin_dir/ta"
  install -m 644 "$script_dir/skill/SKILL.md" "$skill_dir/SKILL.md"
else
  if [[ -z "${GITHUB_TOKEN:-}" ]]; then
    cat >&2 <<EOF
This is a remote installation. Set GITHUB_TOKEN to a token with read access to
$repository, then retry. Example:
  export GITHUB_TOKEN=github_pat_...
EOF
    exit 1
  fi
  api="https://api.github.com/repos/$repository/contents"
  curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.raw+json" \
    "$api/bin/ta?ref=$branch" -o "$bin_dir/ta"
  curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github.raw+json" \
    "$api/skill/SKILL.md?ref=$branch" -o "$skill_dir/SKILL.md"
  chmod 755 "$bin_dir/ta"
fi

case ":$PATH:" in
  *":$bin_dir:"*) ;;
  *)
    cat >&2 <<EOF
Installed ta, but $bin_dir is not on PATH.
Add this to ~/.zprofile (zsh) or ~/.bash_profile (bash):
  export PATH="\$HOME/.local/bin:\$PATH"
EOF
    ;;
esac

echo "Installed: $bin_dir/ta"
echo "Installed skill: $skill_dir/SKILL.md"
echo "Verify with: ta project"
