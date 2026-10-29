# kit — AI 협업 작업 키트

Codex로 과제를 수행할 때 쓰는 **작업 규칙(AGENTS.md)**, **문서 템플릿**, **단계별 프롬프트** 모음입니다.
정답 코드나 과제 풀이는 들어 있지 않고, 일하는 방식(정의 → 계획 → 구현 → 검증 → 기록)만 담았습니다.

## 시험 환경에서 쓰는 법 (2분)

```bash
git clone https://github.com/xxxxKangxxxx/kit ~/kit
cd ~/workspace            # 과제 작업 폴더 (다르면 그 폴더로)
bash ~/kit/setup.sh       # AGENTS.md와 스킬 설치 (기존 파일은 덮어쓰지 않음)
codex
```

- 홈 폴더(`~`)에 clone할 수 없으면 `/tmp/kit`에 clone해도 됩니다. setup.sh가 경로를 알아서 맞춥니다.
- 과제에 AGENTS.md가 이미 있으면 setup.sh가 건드리지 않고 다른 방법을 안내합니다.
- 킷은 작업 폴더 **밖**에 clone합니다 (제출물에 섞이지 않게).

## 구성

| 파일 | 용도 |
|---|---|
| `AGENTS.md` | Codex 작업 규칙: 우선순위, 환경 제약, 작업 흐름, 토큰 효율, 응답 형식 |
| `setup.sh` | 작업 폴더에 AGENTS.md 설치, `~/.codex/skills`에 스킬 설치 (모두 덮어쓰기 없음, 외부 전송 없음, `config.toml` 미변경) |
| `prompts.md` | 단계별 프롬프트 (이해 → 계획 → 구현 → 점검 → 문서 → 복습) |
| `skills/task-intake` | 과제 분석: 요구사항 표, 제출물 목록, 업무 담당자 질문 |
| `skills/task-plan` | MVP 범위, 기술 선택, 시간 배분, 중간 재계획 |
| `skills/build-loop` | 구현 → 검증 → 커밋 반복, 디버깅 절차 |
| `skills/submission-check` | 제출 전 점검, 후속 서술형 대비 브리핑 |
| `skills/semiconductor-domain` | 반도체 제조 용어, 공정 흐름, 데이터 구조, 분석 패턴 |
| `skills/web-quickstart` | 0.0.0.0 바인딩, 스택별 실행 명령, 미리보기 문제 해결 |
| `templates/PLAN.md` | 문제 정의, 요구사항 표, 범위, 단계·시간 계획 |
| `templates/DECISIONS.md` | 결정 기록 (선택지, 이유, 대가) |
| `templates/WORKLOG.md` | AI 협업 기록 (AI가 한 일과 내가 바로잡은 점) |
| `templates/STAKEHOLDER_QA.md` | 업무 담당자 질의 기록 |
| `templates/VERIFICATION.md` | 요구사항별 검증 결과, 실행 방법, 한계 |
| `templates/RESULT_README.md` | 결과물 소개 README |
| `docs/` | 대회 안내 정리, 당일 플레이북 |

> 과제가 파일명이나 형식을 정해 두었다면 항상 그쪽이 우선입니다. 템플릿은 정해진 형식이 없을 때만 씁니다.
