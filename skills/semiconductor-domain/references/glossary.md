# 반도체 용어와 공정 흐름

## 제품
| 용어 | 설명 |
|---|---|
| DRAM | 휘발성 메모리. 셀은 트랜지스터 1개 + 커패시터 1개(1T1C). 주기적인 **리프레시**가 필요하다. 종류: DDR(서버·PC), LPDDR(모바일), GDDR(그래픽) |
| NAND Flash | 비휘발성 메모리. 셀당 비트 수에 따라 SLC/MLC/TLC/QLC. 쓰기·지우기(P/E) 횟수 제한(**Endurance**)과 데이터 보존(**Retention**)이 핵심 품질 지표. 셀을 수직으로 쌓는 3D NAND가 주류 |
| HBM | High Bandwidth Memory. DRAM 다이를 수직으로 쌓고 **TSV**(실리콘 관통 전극)로 연결해 대역폭을 크게 높인 메모리. AI 가속기(GPU)에 쓰인다. 세대: HBM2E → HBM3 → HBM3E → HBM4 |
| MR-MUF | SK하이닉스의 HBM 적층 패키징 공정. 쌓은 다이 사이를 액체 보호재로 한 번에 채우고 굳힌다. 열 방출과 생산성에 유리하다 |
| SSD | NAND + 컨트롤러 + 펌웨어로 구성한 저장장치 |
| CXL | CPU와 메모리, 가속기를 잇는 인터커넥트 표준. 메모리 확장과 풀링에 쓰인다 |

## 생산 단위
| 용어 | 설명 |
|---|---|
| Wafer | 실리콘 원판 (메모리는 주로 300mm) |
| Lot | 함께 이동하고 처리되는 웨이퍼 묶음. 보통 FOUP 하나 = 최대 25장 |
| Die / Chip | 웨이퍼 위의 개별 칩. Wafer Map에서 (x, y) 좌표로 표시한다 |
| Shot | 노광 한 번에 찍히는 영역 (여러 다이 포함) |
| Fab | 웨이퍼를 가공하는 공장 (전공정) |
| WIP | 재공. 공정 중에 있는 물량 |
| Route / Flow | 제품이 거치는 공정 단계 순서 |
| Step / Operation | 개별 공정 단계 |
| Recipe | 설비에서 단계를 수행하는 조건 집합 (온도, 압력, 가스, 시간 등) |
| EQP / Tool, Chamber | 설비와 설비 안의 처리 공간. 같은 설비에서도 챔버마다 특성이 다를 수 있다 |

## 공정 흐름 (8대 공정)
1. **웨이퍼 제조**
2. **산화 (Oxidation)**: 보호막과 절연막 형성
3. **포토 (Photo, Lithography)**: 감광액 도포 → 노광 → 현상으로 회로 패턴 전사. 핵심 지표: CD(선폭), Overlay(층간 정렬)
4. **식각 (Etch)**: 필요 없는 부분 제거 (건식·습식)
5. **증착 (Deposition) / 이온주입 (Implant)**: 박막 형성(CVD, PVD, ALD) / 불순물 주입으로 전기적 특성 부여
6. **금속 배선 (Metallization)**: 회로 연결. CMP(화학적 기계 연마)로 평탄화
7. **EDS (Electrical Die Sorting)**: 웨이퍼 상태에서 각 다이를 전기적으로 검사하고 Bin을 부여한다. Probe Card 사용. 리페어(여분 셀로 대체)도 이 단계에서 한다
8. **패키징 (Packaging)**: 다이를 잘라 패키지로 만든다. 이후 **Final Test**와 **Burn-in**(고온·고전압 스트레스로 초기 불량 걸러내기)

공정 사이마다 **계측(Metrology)**과 **검사(Inspection)**가 들어간다: 두께, CD, Overlay, 파티클이나 결함 검사.

## 테스트와 수율
| 용어 | 설명 |
|---|---|
| Bin | 테스트 결과 분류 코드. 양품 Bin과 불량 유형별 Bin. Hard Bin(최종 분류) / Soft Bin(세부 원인). **번호의 의미는 회사와 제품마다 다르므로 반드시 확인한다** |
| Fail Bit Map | 메모리 셀 단위의 불량 위치 지도. 단일 비트, 행(Row), 열(Column), 블록 불량 패턴으로 원인을 추정한다 |
| Repair / Redundancy | 불량 행·열을 여분 셀로 대체하는 것. 리페어 전후 수율을 구분해야 한다 |
| Yield | 수율. 범위를 꼭 확인한다: **Line Yield**(웨이퍼 생존율), **Die/Probe Yield**(EDS 양품률), **Package/Final Yield**, **누적 수율** = 각 수율의 곱 |
| Gross Die | 웨이퍼 한 장에 들어가는 다이 수 |
| D0 | 단위 면적당 결함 밀도 |
| Wafer Map Pattern | 불량 다이의 공간 분포. Center, Donut, Edge-Ring, Edge-Loc, Loc, Scratch, Random, Near-full 등 (공개 데이터셋 WM-811K의 분류) |

## 설비와 공정 제어
| 용어 | 설명 |
|---|---|
| FDC | Fault Detection & Classification. 설비 센서 데이터로 이상을 감지하고 분류 |
| SPC | 통계적 공정 관리. 관리도(Control Chart)로 공정 안정성을 감시 |
| APC / R2R | Advanced Process Control / Run-to-Run. 직전 결과로 다음 레시피를 보정 (EWMA 등) |
| VM | Virtual Metrology. 설비 센서로 계측값을 예측 |
| PM | 예방 정비. PM 직후에는 특성이 바뀌는(시즈닝) 경우가 많다 |
| Alarm / Interlock | 설비 경보 / 조건 위반 시 자동 정지 |
| OEE | 설비종합효율 = 가동률 × 성능률 × 양품률 |
| MTBF / MTTR | 평균 고장 간격 / 평균 수리 시간 |
| Cycle Time / TAT | 투입부터 완료까지 걸린 시간 |
| Excursion | 공정이 정상 범위를 벗어난 사건 |
| Cp / Cpk | 공정 능력 지수. Cp = (USL − LSL) / 6σ, Cpk = min(USL − μ, μ − LSL) / 3σ. 1.33 이상을 흔히 기준으로 쓴다 (회사 기준 확인 필요) |

## 품질 문제 해결
| 용어 | 설명 |
|---|---|
| 8D | 고객 불량 대응 보고 절차 (팀 구성 → 문제 정의 → 임시 조치 → 근본 원인 → 영구 대책 → 검증 → 재발 방지 → 종결) |
| 5 Why | "왜"를 반복해 근본 원인까지 내려가는 기법 |
| FMEA | 고장 모드와 영향 분석. 심각도 × 발생도 × 검출도 = RPN |
| Commonality Analysis | 불량 로트가 공통으로 거친 설비, 챔버, 시간대를 찾는 분석 |
