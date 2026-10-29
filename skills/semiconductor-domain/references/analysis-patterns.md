# 데이터 구조와 분석 패턴

## 흔한 데이터 형태
| 데이터 | 주요 컬럼 예시 | 키 |
|---|---|---|
| 공정 이력 (Lot History) | lot_id, step, eqp_id, chamber, recipe, track_in, track_out | lot_id + step |
| 설비 센서 (FDC Trace) | eqp_id, chamber, lot_id, wafer_id, timestamp, sensor_name, value | 시계열 |
| 계측 (Metrology) | lot_id, wafer_id, step, site(x, y), param(두께, CD 등), value | wafer + site |
| EDS 결과 | lot_id, wafer_id, die_x, die_y, bin, test_item 값 | wafer + die 좌표 |
| 설비 알람·이벤트 | eqp_id, timestamp, alarm_code, message, 조치 내용 | 시계열, 텍스트 |
| 정비 기록 (PM/BM) | eqp_id, start, end, 유형, 교체 부품, 작업 메모 | 기간 |

**먼저 확인할 것**: 키 컬럼의 고유성, 시간대(타임존), 결측 의미(0인지 미측정인지), 단위, 양품 Bin 정의

## 분석 패턴과 기본 방법
| 질문 | 기본 접근 | 주의 |
|---|---|---|
| 수율이 왜 떨어졌나? | 기간 전후 비교 → 단계·설비·챔버별 불량률 비교(공통성 분석) → 차이가 큰 후보 순위 | 표본 수가 적은 설비의 극단값. 불량률과 함께 n을 표시 |
| 어떤 설비가 의심되나? | 설비별 불량률과 전체 평균의 차이, 카이제곱·Fisher 검정이나 비율 신뢰구간 | 여러 설비를 동시에 비교하면 다중 비교 문제 |
| 공정이 안정적인가? | 관리도 (X-bar/R, I-MR), 관리 한계 = 평균 ± 3σ, Western Electric 규칙 | 관리 한계(공정 변동)와 규격 한계(USL/LSL)를 구분 |
| 센서 이상 감지 | 레시피·단계별로 정규화 → 요약 통계(평균, 최대, 기울기) → z-score, IQR, Isolation Forest | 레시피가 다른 데이터를 섞으면 거짓 경보 |
| Wafer Map 패턴 분류 | 규칙 기반(반경·각도별 불량 밀도) → 필요하면 CNN이나 특징 기반 분류 | 클래스 불균형이 심하다 (정상이 대부분) |
| 불량 예측 | 로트·웨이퍼 단위 특징 → 트리 모델(LightGBM, RandomForest) | **분할은 로트나 시간 기준으로** (다이 단위 무작위 분할은 누수). 정확도보다 Recall, PR-AUC |
| 알람·정비 텍스트 요약 | 코드별 빈도와 추세 → LLM이나 키워드로 요약과 분류 | 원문 근거를 함께 보여주기 |
| 병목과 Cycle Time | 단계별 대기·처리 시간 분포, WIP 추세 | 평균보다 분위수(P50, P90) |

### Western Electric 규칙 (관리도 이상 신호)
1. 한 점이 ±3σ 밖
2. 연속 3점 중 2점이 같은 쪽 2σ 밖
3. 연속 5점 중 4점이 같은 쪽 1σ 밖
4. 연속 8점이 중심선의 같은 쪽

### 수율 모델 (결함 밀도 D0, 다이 면적 A)
- Poisson: Y = e^(−A·D0)
- Murphy: Y = ((1 − e^(−A·D0)) / (A·D0))²
- Negative Binomial: Y = (1 + A·D0 / α)^(−α), α는 결함 군집 정도

## 결과 표현
- 엔지니어용 결론 형식: **"[기간]에 [단계]의 [설비/챔버]에서 불량률이 [x%p] 높음 (n=…, 근거: …)"**
- 시각화: Wafer Map 히트맵, 설비별 불량률 막대(신뢰구간 포함), 관리도, 시계열과 이벤트(PM, 알람) 겹쳐 보기
- 인과와 상관을 구분하고, 다음 확인 행동을 제안한다 (예: "해당 챔버 PM 이력 확인").
