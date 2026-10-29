---
name: web-quickstart
description: 시험용 웹 IDE(원격 샌드박스와 Browser 미리보기)에서 웹 서비스를 빠르게 띄우고 확인하는 요령. 서버 실행, 포트, 0.0.0.0 바인딩, 미리보기 연결 오류, 프론트엔드와 API 연결, 테스트 명령이 필요할 때 사용한다.
metadata:
  short-description: 웹 서비스 실행과 미리보기 요령
---

# 웹 서비스 빠른 시작

스택별 실행 명령은 `references/stacks.md`를 본다.

## 핵심 규칙 (미리보기가 안 되는 원인의 대부분)
1. **`0.0.0.0`에 바인딩한다.** `localhost`나 `127.0.0.1`에만 바인딩하면 미리보기에서 접속할 수 없다.
2. **프론트엔드에서 API 주소를 `http://localhost:8000`처럼 고정하지 않는다.** 미리보기는 내 브라우저에서 원격 주소(https)로 열린다. API는 **상대 경로**(`/api/...`)로 호출한다.
3. 그래서 **서버 하나가 API와 정적 파일을 함께 서빙**하는 구조가 가장 안전하다. 프론트엔드 개발 서버를 따로 쓰면 개발 서버의 proxy 설정으로 `/api`를 백엔드로 넘긴다.
4. 개발 서버의 **호스트 검사**가 원격 도메인을 막을 수 있다 (Vite, webpack, Django 등). `references/stacks.md`의 설정을 적용한다.
5. 미리보기 주소가 https이므로 http 리소스를 고정해서 쓰지 않는다 (혼합 콘텐츠 차단).

## 실행과 확인 순서
1. 환경 확인: `node -v; npm -v; python3 --version`
2. 포트 확인: `lsof -i :PORT` 또는 `ss -ltnp | grep PORT` (이미 쓰고 있으면 기존 프로세스를 정리)
3. 서버 실행: 사용자가 별도 터미널에서 실행하거나, `nohup <cmd> > server.log 2>&1 &` 후 `tail -20 server.log`
4. 서버 안에서 먼저 확인: `curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:PORT/`
5. 사용자에게 안내: Browser 도구에 **PORT**와 **경로**를 입력하고 원형 화살표를 누른다.
6. 안 열리면 순서대로 확인: 터미널 오류나 서버 종료 → 실제 포트 → `0.0.0.0` 바인딩 → 경로 → 호스트 검사 설정

## 자원 아끼기 (OOM은 구제되지 않음)
- 무거운 프레임워크보다 가벼운 구성: 정적 HTML과 JS + 작은 백엔드, 또는 FastAPI, Express 한 개
- 개발 서버는 하나만 띄운다. 끝난 서버는 종료한다.
- 데이터 저장은 파일이나 **SQLite**로 한다 (외부 DB 서버를 쓰지 않는다).
- 설치는 필요한 패키지만: `pip install --no-cache-dir <pkg>`, `npm i <pkg>` (전체 템플릿 생성기는 꼭 필요할 때만)

## 테스트 명령
- Python: `pytest -q` (없으면 `python -m pytest -q`), FastAPI는 `fastapi.testclient.TestClient`
- Node: `node --test`, 또는 이미 설정된 `npm test`
- API 확인: `curl -s localhost:PORT/api/x | head -c 500`
- 화면 동작은 사람이 미리보기에서 확인한다. 확인할 조작 순서를 짧게 안내한다.
