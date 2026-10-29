#!/usr/bin/env bash
# 사용법: bash ~/kit/setup.sh [작업폴더(기본: 현재 폴더)] [--append]
# - 작업폴더에 AGENTS.md를 설치한다. 기존 AGENTS.md는 덮어쓰지 않는다.
# - --append: 기존 AGENTS.md가 있으면 그 끝에 이 규칙을 덧붙인다.
# - 외부로 아무것도 보내지 않고, ~/.codex 설정도 건드리지 않는다.
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="."
APPEND=0
for arg in "$@"; do
  case "$arg" in
    --append) APPEND=1 ;;
    *) TARGET="$arg" ;;
  esac
done
TARGET="$(cd "$TARGET" && pwd)"
MARKER="<!-- kit-agents -->"

if [ "$TARGET" = "$KIT_DIR" ]; then
  echo "❌ 킷 폴더가 아니라 과제 작업 폴더에서 실행하세요. 예: cd ~/workspace && bash $KIT_DIR/setup.sh"
  exit 1
fi

rendered="$(sed "s#{{KIT_DIR}}#${KIT_DIR}#g" "$KIT_DIR/AGENTS.md")"

if [ ! -e "$TARGET/AGENTS.md" ]; then
  printf '%s\n%s\n' "$MARKER" "$rendered" > "$TARGET/AGENTS.md"
  echo "✅ AGENTS.md 설치: $TARGET/AGENTS.md"
elif grep -q "$MARKER" "$TARGET/AGENTS.md"; then
  echo "ℹ️  이미 설치되어 있습니다: $TARGET/AGENTS.md"
elif [ "$APPEND" -eq 1 ]; then
  printf '\n\n%s\n%s\n' "$MARKER" "$rendered" >> "$TARGET/AGENTS.md"
  echo "✅ 기존 AGENTS.md 끝에 규칙을 덧붙였습니다."
else
  echo "⚠️  과제에 AGENTS.md가 이미 있어서 건드리지 않았습니다."
  echo "   방법 1) Codex에게: \"$KIT_DIR/AGENTS.md 도 읽고 작업 규칙으로 따라줘\""
  echo "   방법 2) 덧붙이기: bash $KIT_DIR/setup.sh \"$TARGET\" --append"
fi

echo "📄 템플릿: $KIT_DIR/templates/"
echo "💬 프롬프트 모음: $KIT_DIR/prompts.md (에디터에서 열어 복사)"
echo "▶  다음: codex 실행 → /status 로 모델 확인 → prompts.md의 0단계부터"
