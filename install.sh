#!/usr/bin/env bash
#
# Sharp Skills — Shell 安装脚本
#
# 零依赖，直接用 curl + bash 安装。
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/zhouhuijia/sharp-skills/main/install.sh | bash
#   bash install.sh                                    # install all
#   bash install.sh --skill sharp-tech-writing         # specific skill
#   bash install.sh --platform claude,cursor           # specific platform
#   bash install.sh --skill sharp-tech-writing --platform claude
#   bash install.sh --list                             # list skills
#   bash install.sh --remove                           # remove all
#   bash install.sh --remove --skill sharp-tech-writing
#
# Also works with npx skills add (skills.sh compatible):
#   npx skills add https://github.com/zhouhuijia/sharp-skills
#   npx skills add https://github.com/zhouhuijia/sharp-skills --skill "sharp-tech-writing"

set -euo pipefail

# ── Config ───────────────────────────────────────────────────────

REPO_RAW="https://raw.githubusercontent.com/zhouhuijia/sharp-skills/main"
VERSION="1.0.0"

# Colors
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
NC='\033[0m'

SKILLS=(
  "sharp-tech-writing:技术文档:README、API 文档、开发指南 — 主动语态铁律"
  "sharp-dataviz:数据可视化:图表、统计图 — 图表选择决策树、中国红涨绿跌"
  "sharp-copywriting:营销文案:产品描述、广告语 — 禁用虚词、数字铁律"
  "sharp-api-design:API 设计:REST API、接口规范 — 命名一致性、错误响应标准"
  "sharp-interview:面试设计:面试题、技术评估 — 岗位-题型矩阵、评分锚点"
  "sharp-presentation:演示文稿:PPT、汇报材料 — 金字塔原理、反文字墙"
)

declare -A PLATFORM_DIRS=(
  ["claude"]=".claude/rules"
  ["cursor"]=".cursor/rules"
  ["codex"]=".codex/rules"
  ["copilot"]=".github"
  ["windsurf"]=".windsurf/rules"
  ["aider"]=".aider/rules"
  ["workbuddy"]="\$HOME/.workbuddy/skills"
)

declare -A PLATFORM_NAMES=(
  ["claude"]="Claude Code"
  ["cursor"]="Cursor"
  ["codex"]="Codex (OpenAI)"
  ["copilot"]="GitHub Copilot"
  ["windsurf"]="Windsurf"
  ["aider"]="Aider"
  ["workbuddy"]="WorkBuddy"
)

# ── Helpers ──────────────────────────────────────────────────────

header() { echo -e "\n  ${BOLD}${CYAN}◆${NC} ${BOLD}$1${NC}"; }
step()   { echo -e "  ${DIM}→${NC} $1"; }
ok()     { echo -e "  ${GREEN}✓${NC} $1"; }
warn()   { echo -e "  ${YELLOW}!${NC} $1"; }
err()    { echo -e "  ${RED}✗${NC} $1"; }

detect_platform() {
  local detected=""
  for plat in claude cursor codex copilot windsurf aider workbuddy; do
    case $plat in
      claude)    [ -d ".claude" ] && detected="$detected$plat," ;;
      cursor)    [ -d ".cursor" ] || [ -f ".cursorrules" ] && detected="$detected$plat," ;;
      codex)    [ -d ".codex" ] && detected="$detected$plat," ;;
      copilot)  [ -d ".github" ] && detected="$detected$plat," ;;
      windsurf) [ -d ".windsurf" ] && detected="$detected$plat," ;;
      aider)    [ -d ".aider" ] && detected="$detected$plat," ;;
      workbuddy) [ -d "$HOME/.workbuddy" ] || [ -d ".workbuddy" ] && detected="$detected$plat," ;;
    esac
  done
  echo "${detected%,}"
}

list_skills() {
  header "Available Skills (6)"
  echo ""
  for entry in "${SKILLS[@]}"; do
    IFS=':' read -r key name desc <<< "$entry"
    echo -e "  ${BOLD}${key}${NC}"
    echo -e "    ${DIM}${name} — ${desc}${NC}"
    echo ""
  done
}

fetch_skill_content() {
  local skill=$1
  # Try rules.md first, then SKILL.md
  local url="${REPO_RAW}/skills/${skill}/rules.md"
  local content
  content=$(curl -fsSL "$url" 2>/dev/null) || {
    url="${REPO_RAW}/skills/${skill}/SKILL.md"
    content=$(curl -fsSL "$url" 2>/dev/null) || {
      err "Failed to fetch: $skill"
      return 1
    }
    # Strip YAML frontmatter if needed
    if [[ "$content" == ---* ]]; then
      content=$(echo "$content" | sed '1{/^---$/!q}; /^---$/n; /^---$/,$!d; /^---$/d')
    fi
  }
  echo "$content"
}

install_skill_for_platform() {
  local skill=$1
  local plat=$2
  local target_dir
  local workbuddy_skill_dir

  if [ "$plat" = "workbuddy" ]; then
    workbuddy_skill_dir="$HOME/.workbuddy/skills/${skill}"
    mkdir -p "$workbuddy_skill_dir"
    local content
    content=$(curl -fsSL "${REPO_RAW}/skills/${skill}/SKILL.md" 2>/dev/null)
    if [ -n "$content" ]; then
      echo "$content" > "$workbuddy_skill_dir/SKILL.md"
      ok "${skill} → ${PLATFORM_NAMES[$plat]}  ${DIM}${workbuddy_skill_dir}/SKILL.md${NC}"
    else
      err "Failed to fetch SKILL.md for ${skill}"
    fi
  elif [ "$plat" = "copilot" ]; then
    local dir=".github"
    local file="${dir}/copilot-instructions.md"
    mkdir -p "$dir"
    local content
    content=$(fetch_skill_content "$skill")
    if [ -n "$content" ]; then
      if [ -f "$file" ]; then
        echo -e "\n\n## ${skill}\n\n${content}" >> "$file"
      else
        echo "$content" > "$file"
      fi
      ok "${skill} → ${PLATFORM_NAMES[$plat]}  ${DIM}${file}${NC}"
    fi
  else
    target_dir="${PLATFORM_DIRS[$plat]}"
    target_dir="${target_dir/\$HOME/$HOME}"
    mkdir -p "$target_dir"
    local content
    content=$(fetch_skill_content "$skill")
    if [ -n "$content" ]; then
      echo "$content" > "${target_dir}/${skill}.md"
      ok "${skill} → ${PLATFORM_NAMES[$plat]}  ${DIM}${target_dir}/${skill}.md${NC}"
    fi
  fi
}

install_all() {
  local platforms=$1
  header "Installing all 6 skills for: ${platforms}"
  for entry in "${SKILLS[@]}"; do
    IFS=':' read -r key _ _ <<< "$entry"
    step "Installing ${key}..."
    IFS=',' read -ra PLATS <<< "$platforms"
    for plat in "${PLATS[@]}"; do
      install_skill_for_platform "$key" "$plat"
    done
  done
  echo ""
  ok "${BOLD}All 6 skills installed!${NC}"
}

install_specific() {
  local skills=$1
  local platforms=$2
  header "Installing: ${skills} for ${platforms}"
  IFS=',' read -ra SKILL_ARR <<< "$skills"
  IFS=',' read -ra PLAT_ARR <<< "$platforms"
  for skill in "${SKILL_ARR[@]}"; do
    step "Installing ${skill}..."
    for plat in "${PLAT_ARR[@]}"; do
      install_skill_for_platform "$skill" "$plat"
    done
  done
  echo ""
  ok "${BOLD}Done!${NC}"
}

remove_skill_for_platform() {
  local skill=$1
  local plat=$2

  if [ "$plat" = "workbuddy" ]; then
    local dir="$HOME/.workbuddy/skills/${skill}"
    if [ -d "$dir" ]; then
      rm -rf "$dir"
      ok "Removed ${skill} from ${PLATFORM_NAMES[$plat]}"
    fi
  elif [ "$plat" = "copilot" ]; then
    local file=".github/copilot-instructions.md"
    if [ -f "$file" ]; then
      # Remove the section for this skill
      if command -v perl >/dev/null 2>&1; then
        perl -i -0pe "s/\n## ${skill}\n\n.*?(?=\n## |\Z)//gs" "$file"
      else
        sed -i.bak "/^## ${skill}$/,/^## /{ /^## ${skill}$/d; /^## /!d; }" "$file" 2>/dev/null || true
        rm -f "${file}.bak"
      fi
      ok "Removed ${skill} from ${PLATFORM_NAMES[$plat]}"
    fi
  else
    local target_dir="${PLATFORM_DIRS[$plat]}"
    target_dir="${target_dir/\$HOME/$HOME}"
    local file="${target_dir}/${skill}.md"
    if [ -f "$file" ]; then
      rm -f "$file"
      ok "Removed ${skill} from ${PLATFORM_NAMES[$plat]}  ${DIM}${file}${NC}"
    fi
  fi
}

remove_all() {
  local platforms=$1
  header "Removing all skills from: ${platforms}"
  for entry in "${SKILLS[@]}"; do
    IFS=':' read -r key _ _ <<< "$entry"
    step "Removing ${key}..."
    IFS=',' read -ra PLATS <<< "$platforms"
    for plat in "${PLATS[@]}"; do
      remove_skill_for_platform "$key" "$plat" || true
    done
  done
  echo ""
  ok "${BOLD}All skills removed.${NC}"
}

show_info() {
  local detected
  detected=$(detect_platform)
  header "Sharp Skills Info"
  echo ""
  echo -e "  ${BOLD}Version:${NC}    ${VERSION}"
  echo -e "  ${BOLD}Working dir:${NC} $(pwd)"
  echo -e "  ${BOLD}Home dir:${NC}    $HOME"
  echo -e "  ${BOLD}Detected:${NC}   ${detected:-${DIM}none${NC}}"
  echo ""
}

print_help() {
  echo ""
  echo -e "  ${BOLD}${CYAN}Sharp Skills${NC}  ${DIM}— AI Agent 品控规则安装工具 (Shell)${NC}"
  echo ""
  echo -e "  ${BOLD}Usage:${NC}"
  echo -e "    bash install.sh                              ${DIM}# Install all (auto-detect platform)${NC}"
  echo -e "    bash install.sh --skill <name>               ${DIM}# Install specific skill${NC}"
  echo -e "    bash install.sh --platform <plat>            ${DIM}# Target specific platform${NC}"
  echo -e "    bash install.sh --skill <n> --platform <p>   ${DIM}# Both${NC}"
  echo -e "    bash install.sh --list                       ${DIM}# List skills${NC}"
  echo -e "    bash install.sh --remove                     ${DIM}# Remove all${NC}"
  echo -e "    bash install.sh --remove --skill <n>         ${DIM}# Remove specific${NC}"
  echo -e "    bash install.sh --info                       ${DIM}# Show status${NC}"
  echo -e "    bash install.sh --help                       ${DIM}# This message${NC}"
  echo ""
  echo -e "  ${BOLD}Examples:${NC}"
  echo -e "    ${DIM}# Install all skills for Claude Code & Cursor${NC}"
  echo -e "    bash install.sh --platform claude,cursor"
  echo ""
  echo -e "    ${DIM}# Install one skill${NC}"
  echo -e "    bash install.sh --skill sharp-tech-writing"
  echo ""
  echo -e "    ${DIM}# Also works with npx skills add:${NC}"
  echo -e "    npx skills add https://github.com/zhouhuijia/sharp-skills"
  echo -e "    npx skills add https://github.com/zhouhuijia/sharp-skills --skill \"sharp-tech-writing\""
  echo ""
}

# ── Main ─────────────────────────────────────────────────────────

SKILL_ARG=""
PLATFORM_ARG=""
LIST=false
REMOVE=false
INFO=false
HELP=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --skill) SKILL_ARG="$2"; shift 2 ;;
    --platform|-p) PLATFORM_ARG="$2"; shift 2 ;;
    --list) LIST=true; shift ;;
    --remove) REMOVE=true; shift ;;
    --info) INFO=true; shift ;;
    --help|-h) HELP=true; shift ;;
    *) err "Unknown arg: $1"; print_help; exit 1 ;;
  esac
done

if $HELP; then
  print_help
  exit 0
fi

if $LIST; then
  list_skills
  exit 0
fi

if $INFO; then
  show_info
  exit 0
fi

# Resolve platforms
if [ -z "$PLATFORM_ARG" ]; then
  PLATFORM_ARG=$(detect_platform)
  if [ -z "$PLATFORM_ARG" ]; then
    PLATFORM_ARG="claude,cursor"
    warn "No platform detected, defaulting to: claude,cursor"
  else
    step "Detected platforms: ${PLATFORM_ARG}"
  fi
fi

if $REMOVE; then
  if [ -n "$SKILL_ARG" ]; then
    IFS=',' read -ra PLATS <<< "$PLATFORM_ARG"
    for plat in "${PLATS[@]}"; do
      remove_skill_for_platform "$SKILL_ARG" "$plat" || true
    done
    ok "${BOLD}Removed ${SKILL_ARG}${NC}"
  else
    remove_all "$PLATFORM_ARG"
  fi
else
  if [ -n "$SKILL_ARG" ]; then
    install_specific "$SKILL_ARG" "$PLATFORM_ARG"
  else
    install_all "$PLATFORM_ARG"
  fi
fi
