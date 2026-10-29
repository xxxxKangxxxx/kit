---
name: handoff
description: 현재 작업 상태를 HANDOFF.md에 정리해 새 Codex 세션이나 다른 사람이 바로 이어받을 수 있게 하고, 새 세션 시작 시 HANDOFF.md로 맥락을 복구한다. "핸드오프", "인수인계", "새 세션", "상태 정리", 컨텍스트가 길어졌을 때 사용한다.
metadata:
  short-description: 상태 정리와 세션 이어받기
---

# Handoff

## 언제 쓰나
- 단계가 바뀔 때 (STATE 갱신)
- 대화가 길어져 응답이 느려지거나 앞의 내용을 놓치기 시작할 때 → handoff를 쓰고 **새 세션**으로 넘어간다
- 큰 작업을 별도 세션(리뷰 등)에 맡길 때

## 쓰기 (나가는 세션)
1. `git log --oneline | head -10`, `git status`로 실제 상태를 확인한다. 기억에 의존하지 않는다.
2. `HANDOFF.md`를 갱신한다 (템플릿: `{{KIT_DIR}}/templates/HANDOFF.md`).
   - STATE, 합의된 성공 기준, 된 것과 안 된 것, 다음 할 일, 실행 방법, 주의할 점, 핵심 파일
   - 사실만 쓴다. 검증하지 않은 것은 `미검증`이라고 쓴다.
3. 커밋한다: `docs: update handoff (<단계>)`
4. 나에게 새 세션에서 쓸 첫 메시지를 한 줄로 준다.

## 읽기 (새 세션)
1. `AGENTS.md` → `HANDOFF.md` → `PLAN.md` 순서로 읽는다. 코드 전체를 다시 읽지 않는다.
2. `git log --oneline | head -5`로 HANDOFF가 최신인지 확인한다.
3. 이해한 상태를 3줄로 요약하고 "다음 할 일 1번"부터 진행할지 묻는다.
