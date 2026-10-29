# 스택별 실행 명령 (0.0.0.0 바인딩)

## Python
| 스택 | 실행 | 주의 |
|---|---|---|
| FastAPI | `uvicorn main:app --host 0.0.0.0 --port 8000 --reload` | 정적 파일: `app.mount("/", StaticFiles(directory="static", html=True))`는 **API 라우트를 모두 정의한 뒤 마지막에** |
| Flask | `flask --app app run --host 0.0.0.0 --port 5000 --debug` | 코드 안이라면 `app.run(host="0.0.0.0", port=5000)` |
| Django | `python manage.py runserver 0.0.0.0:8000` | 개발 중에는 `ALLOWED_HOSTS = ["*"]`. 폼을 POST하면 `CSRF_TRUSTED_ORIGINS`에 미리보기 https 도메인 추가 |
| Streamlit | `streamlit run app.py --server.address 0.0.0.0 --server.port 8501 --server.headless true` | 프록시 뒤에서 연결이 끊기면 `--server.enableCORS false --server.enableXsrfProtection false` |
| Gradio | `demo.launch(server_name="0.0.0.0", server_port=7860)` | |
| 정적 파일 | `python3 -m http.server 8000 --bind 0.0.0.0` | |

### FastAPI 최소 예시 (API와 정적 파일을 함께 서빙)
```python
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

app = FastAPI()

@app.get("/api/health")
def health():
    return {"ok": True}

app.mount("/", StaticFiles(directory="static", html=True), name="static")  # 마지막에
```
프론트엔드에서는 `fetch("/api/health")`처럼 상대 경로로 호출한다.

## Node
| 스택 | 실행 | 주의 |
|---|---|---|
| Express | `app.listen(PORT, "0.0.0.0")` | 정적 파일: `app.use(express.static("public"))` |
| Vite | `npx vite --host 0.0.0.0 --port 5173` | `vite.config`에 `server: { host: true, allowedHosts: true, proxy: { "/api": "http://127.0.0.1:8000" } }`. 빌드 결과 확인용 `vite preview`에는 `preview.allowedHosts`도 설정 |
| Next.js | `npx next dev -H 0.0.0.0 -p 3000` | 원격 도메인 경고나 차단이 나오면 `next.config`의 `allowedDevOrigins`에 미리보기 도메인 추가 |
| CRA / webpack | `HOST=0.0.0.0 PORT=3000 npm start` | "Invalid Host header"가 나오면 `DANGEROUSLY_DISABLE_HOST_CHECK=true` (webpack은 `devServer.allowedHosts: "all"`) |

### Express 최소 예시
```js
const express = require("express");
const app = express();
app.use(express.json());
app.get("/api/health", (req, res) => res.json({ ok: true }));
app.use(express.static("public"));
const PORT = process.env.PORT || 3000;
app.listen(PORT, "0.0.0.0", () => console.log(`listening on ${PORT}`));
```

## 자주 나는 문제
| 증상 | 원인과 해결 |
|---|---|
| "포트 N에 아직 응답하는 서버가 없어요" | 서버가 꺼졌거나 다른 포트에서 실행됨 → 터미널 로그에서 실제 포트 확인 |
| 미리보기가 빈 화면이거나 연결 거부 | `localhost`에만 바인딩됨 → `0.0.0.0` |
| "Blocked request. This host is not allowed" | Vite 호스트 검사 → `server.allowedHosts: true` |
| "Invalid Host header" | webpack 호스트 검사 → `allowedHosts: "all"` |
| 화면은 뜨는데 데이터가 안 옴 | API를 `localhost:포트`로 고정 호출함 → 상대 경로와 프록시로 변경 |
| CORS 오류 | 프론트엔드와 API의 출처가 다름 → 한 서버로 합치거나 개발 프록시 사용 (CORS 전체 허용은 마지막 수단) |
| 새로고침 시 404 (SPA) | 서버가 알 수 없는 경로를 `index.html`로 돌려주게 설정 |
| HMR(자동 새로고침)이 안 됨 | 프록시 뒤에서 웹소켓이 막힘 → 무시하고 수동 새로고침 |
| `EADDRINUSE` | 포트 사용 중 → `lsof -i :PORT`로 PID 확인 후 종료 |
