#!/usr/bin/env bash
# Install the ai-delivery-pm WorkBuddy expert, or just its reusable skill.
# This script never overwrites or deletes existing user data.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${WORKBUDDY_CONFIG_DIR:-$HOME/.workbuddy}"
MODE="expert"
SKILL_TARGET=""

EXPERT_NAME="ai-delivery-pm"
SKILL_NAME="ai-delivery-playbook"

usage() {
  cat <<'EOF'
Usage: ./install.sh [OPTIONS]

Options:
  (none)            Install the full WorkBuddy expert package (default)
  --skill-only      Install only the ai-delivery-playbook skill
  --skill-dir DIR   Target skills directory (default: $WORKBUDDY_CONFIG_DIR/skills)
  --config-dir DIR  WorkBuddy config directory (default: $HOME/.workbuddy)
  -h, --help        Show this help

Environment:
  WORKBUDDY_CONFIG_DIR   Overrides the WorkBuddy config directory
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --skill-only) MODE="skill"; shift ;;
    --skill-dir) SKILL_TARGET="${2:-}"; shift 2 ;;
    --config-dir) CONFIG_DIR="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

if [ -z "$CONFIG_DIR" ]; then
  echo "Error: config directory is empty" >&2
  exit 1
fi

PLUGINS_DIR="$CONFIG_DIR/plugins/marketplaces/my-experts/plugins"
MARKETPLACE_FILE="$CONFIG_DIR/plugins/marketplaces/my-experts/.codebuddy-plugin/marketplace.json"

install_skill() {
  local target="${SKILL_TARGET:-$CONFIG_DIR/skills}"
  mkdir -p "$target"
  if [ -e "$target/$SKILL_NAME" ]; then
    echo "Error: already exists: $target/$SKILL_NAME" >&2
    echo "Remove or rename it first. install.sh never overwrites existing data." >&2
    exit 1
  fi
  cp -R "$REPO_DIR/skills/$SKILL_NAME" "$target/$SKILL_NAME"
  echo "Skill installed -> $target/$SKILL_NAME"
}

register_marketplace() {
  EXPERT_DIR="$1" MARKETPLACE_FILE="$MARKETPLACE_FILE" python3 - <<'PY'
import json, os
from pathlib import Path

expert_dir = Path(os.environ["EXPERT_DIR"])
mp_path = Path(os.environ["MARKETPLACE_FILE"])
pj = json.loads((expert_dir / ".codebuddy-plugin" / "plugin.json").read_text(encoding="utf-8"))
name = pj["name"]
entry = {
    "name": name,
    "source": "./plugins/" + name,
    "description": pj.get("description", ""),
    "version": pj.get("version", "1.0.0"),
}

mp_path.parent.mkdir(parents=True, exist_ok=True)
if mp_path.exists():
    try:
        data = json.loads(mp_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        data = {}
else:
    data = {}
data.setdefault("name", "my-experts")
data.setdefault("description", "my-experts marketplace (auto-generated)")
plugins = data.setdefault("plugins", [])

for i, item in enumerate(plugins):
    if item.get("name") == name or item.get("source") == entry["source"]:
        plugins[i] = entry
        break
else:
    plugins.append(entry)

mp_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
print("Registered in", mp_path)
PY
}

install_expert() {
  local target="$PLUGINS_DIR/$EXPERT_NAME"
  if [ -e "$target" ]; then
    echo "Error: already exists: $target" >&2
    echo "Remove or rename it first. install.sh never overwrites existing data." >&2
    exit 1
  fi
  mkdir -p "$target"
  (cd "$REPO_DIR" && tar --exclude='.git' --exclude='.DS_Store' --exclude='install.sh' -cf - .) \
    | (cd "$target" && tar -xf -)
  register_marketplace "$target"
  echo "Expert installed -> $target"
  echo "Open WorkBuddy > Expert Center > My Experts, then look for '程必达 / AI 交付项目经理'."
}

if [ "$MODE" = "skill" ]; then
  install_skill
else
  install_expert
fi
