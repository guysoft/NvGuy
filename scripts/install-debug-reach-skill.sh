#!/bin/bash
# Install the debug-reach skill globally for OpenCode.
# This copies the skill from vscodium.nvim into ~/.config/opencode/skills/
# so it's available from any project directory.

set -e

SKILL_SRC="$(dirname "$0")/../skills/debug-reach"
SKILL_DST="$HOME/.config/opencode/skills/debug-reach"

if [ ! -d "$SKILL_SRC" ]; then
  echo "Error: skill source not found at $SKILL_SRC"
  exit 1
fi

mkdir -p "$(dirname "$SKILL_DST")"
cp -r "$SKILL_SRC" "$SKILL_DST"
echo "Installed debug-reach skill to $SKILL_DST"
