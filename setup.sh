#!/usr/bin/env bash
# 사용법: bash /tmp/kit/setup.sh [작업폴더(기본: 현재 폴더)] [--append] [--no-skills]
# - 작업폴더에 AGENTS.md를 설치한다. 기존 AGENTS.md는 덮어쓰지 않는다.
# - --append: 기존 AGENTS.md가 있으면 그 끝에 이 규칙을 덧붙인다.
# - 스킬을 ${CODEX_HOME:-~/.codex}/skills 에 설치한다. 같은 이름이 있으면 건너뛴다. (--no-skills 로 생략)
# - 외부로 아무것도 보내지 않고, config.toml 등 Codex 설정은 건드리지 않는다.
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="."
APPEND=0
SKILLS=1
for arg in "$@"; do
  case "$arg" in
    --append) APPEND=1 ;;
    --no-skills) SKILLS=0 ;;
    *) TARGET="$arg" ;;
  esac
done
TARGET="$(cd "$TARGET" && pwd)"
MARKER="<!-- kit-agents -->"

if [ "$TARGET" = "$KIT_DIR" ]; then
  echo "❌ 킷 폴더가 아니라 과제 작업 폴더에서 실행하세요. 예: cd ~ && bash $KIT_DIR/setup.sh"
  exit 1
fi
case "$KIT_DIR/" in
  "$TARGET"/*) echo "⚠️  킷($KIT_DIR)이 작업 폴더 안에 있어 제출물에 섞일 수 있습니다. 권장: git clone https://github.com/xxxxKangxxxx/kit /tmp/kit && bash /tmp/kit/setup.sh \"$TARGET\"" ;;
esac

render() { sed "s#{{KIT_DIR}}#${KIT_DIR}#g" "$1"; }

# 1) AGENTS.md
rendered="$(render "$KIT_DIR/AGENTS.md")"
if [ ! -e "$TARGET/AGENTS.md" ]; then
  printf '%s\n%s\n' "$MARKER" "$rendered" > "$TARGET/AGENTS.md"
  echo "✅ AGENTS.md 설치: $TARGET/AGENTS.md"
elif grep -q "$MARKER" "$TARGET/AGENTS.md"; then
  echo "ℹ️  AGENTS.md는 이미 설치되어 있습니다."
elif [ "$APPEND" -eq 1 ]; then
  printf '\n\n%s\n%s\n' "$MARKER" "$rendered" >> "$TARGET/AGENTS.md"
  echo "✅ 기존 AGENTS.md 끝에 규칙을 덧붙였습니다."
else
  echo "⚠️  과제에 AGENTS.md가 이미 있어서 건드리지 않았습니다."
  echo "   방법 1) Codex에게: \"$KIT_DIR/AGENTS.md 도 읽고 작업 규칙으로 따라줘\""
  echo "   방법 2) 덧붙이기: bash $KIT_DIR/setup.sh \"$TARGET\" --append"
fi

# 2) 스킬
if [ "$SKILLS" -eq 1 ]; then
  SKILL_HOME="${CODEX_HOME:-$HOME/.codex}/skills"
  if mkdir -p "$SKILL_HOME" 2>/dev/null && [ -w "$SKILL_HOME" ]; then
    for src in "$KIT_DIR"/skills/*/; do
      name="$(basename "$src")"
      dest="$SKILL_HOME/$name"
      if [ -e "$dest" ]; then
        echo "ℹ️  스킬 건너뜀 (이미 있음): $name"
        continue
      fi
      cp -R "$src" "$dest"
      render "$src/SKILL.md" > "$dest/SKILL.md"
      echo "✅ 스킬 설치: $name"
    done
    echo "   → 스킬은 Codex를 새로 시작해야 인식됩니다. 인식이 안 되어도 AGENTS.md가 경로로 안내합니다."
  else
    echo "⚠️  $SKILL_HOME 에 쓸 수 없어 스킬 설치를 건너뜁니다. (AGENTS.md가 $KIT_DIR/skills 경로로 안내함)"
  fi
fi

echo "📄 템플릿: $KIT_DIR/templates/"
echo "💬 프롬프트 모음: $KIT_DIR/prompts.md (에디터에서 열어 복사)"
echo "▶  다음: codex 실행 → /status 로 모델 확인 → prompts.md의 0단계부터"
