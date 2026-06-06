# 지하철 역 데이터 출처 후보

## 날짜

2026-06-06

## 맥락

지하철 역 데이터 최신화를 위해 우선 검토할 공식 또는 공공 데이터 출처를 기록한다.

## 참고 링크

- 서울 열린데이터광장. `https://data.seoul.go.kr`
- 서울시 지하철 실시간 열차 위치정보. `https://data.seoul.go.kr/dataList/OA-12601/A/1/datasetView.do`
- TOPIS Open API 안내. `https://topis.seoul.go.kr/refRoom/openRefRoom_4.do`
- 공공데이터포털 노선별 지하철역 정보 API. `https://www.data.go.kr/dataset/3045253/openapi.do?lang=ko`

## 메모

역 목록 최신화에는 실시간 API를 직접 상시 호출하는 방식보다, 공식 데이터 원천을 주기적으로 가져와 정규화한 뒤 코드 생성 결과를 리뷰하는 방식이 더 안정적이다.
