// 서울 열린데이터광장 역 데이터 정규화와 코드 생성을 검증한다.
import assert from "node:assert/strict"
import { test } from "node:test"

import {
  buildApiUrl,
  generateDartStations,
  generateTypeScriptStations,
  normalizeStationRows,
  parseSeoulStationResponse,
  readEnvFile,
} from "./station-data.mjs"

const sampleRows = [
  {
    STATION_CD: "1007",
    STATION_NM: "신도림",
    STATION_NM_ENG: "Sindorim",
    LINE_NUM: "01호선",
    FR_CODE: "140",
    STATION_NM_CHN: "新道林",
    STATION_NM_JPN: "シンドリム",
  },
  {
    STATION_CD: "0234",
    STATION_NM: "신도림",
    STATION_NM_ENG: "Sindorim",
    LINE_NUM: "02호선",
    FR_CODE: "234",
    STATION_NM_CHN: "新道林",
    STATION_NM_JPN: "シンドリム",
  },
  {
    STATION_CD: "4311",
    STATION_NM: "판교",
    STATION_NM_ENG: "Pangyo",
    LINE_NUM: "신분당선",
    FR_CODE: "D11",
    STATION_NM_CHN: "板桥",
    STATION_NM_JPN: "パンギョ",
  },
]

test("readEnvFile reads SEOUL_OPEN_DATA_API_KEY from dotenv content", () => {
  const env = readEnvFile('PORT=3000\nSEOUL_OPEN_DATA_API_KEY="abc123"\n')

  assert.equal(env.SEOUL_OPEN_DATA_API_KEY, "abc123")
})

test("buildApiUrl creates Seoul Open Data URL with encoded range", () => {
  const url = buildApiUrl({ apiKey: "sample", start: 1, end: 1000 })

  assert.equal(
    url,
    "http://openapi.seoul.go.kr:8088/sample/json/SearchSTNBySubwayLineInfo/1/1000/",
  )
})

test("parseSeoulStationResponse extracts rows and total count", () => {
  const payload = {
    SearchSTNBySubwayLineInfo: {
      list_total_count: 3,
      RESULT: { CODE: "INFO-000", MESSAGE: "정상 처리되었습니다" },
      row: sampleRows,
    },
  }

  const parsed = parseSeoulStationResponse(JSON.stringify(payload))

  assert.equal(parsed.totalCount, 3)
  assert.equal(parsed.rows.length, 3)
})

test("parseSeoulStationResponse fails for non-success result", () => {
  const payload = {
    SearchSTNBySubwayLineInfo: {
      RESULT: { CODE: "ERROR-500", MESSAGE: "실패" },
    },
  }

  assert.throws(
    () => parseSeoulStationResponse(JSON.stringify(payload)),
    /서울 열린데이터광장 응답 오류/,
  )
})

test("normalizeStationRows merges transfer stations and normalizes line names", () => {
  const result = normalizeStationRows(sampleRows, {
    descriptions: new Map([["신도림", "구로구 · 환승역"]]),
  })

  assert.deepEqual(result.stations[0], {
    name: "신도림",
    description: "구로구 · 환승역",
    lines: ["1", "2"],
    codes: [
      {
        line: "1",
        stationCode: "1007",
        externalCode: "140",
        nameKo: "신도림",
        nameEn: "Sindorim",
        nameZh: "新道林",
        nameJa: "シンドリム",
      },
      {
        line: "2",
        stationCode: "0234",
        externalCode: "234",
        nameKo: "신도림",
        nameEn: "Sindorim",
        nameZh: "新道林",
        nameJa: "シンドリム",
      },
    ],
  })
  assert.deepEqual(result.stations[1].lines, ["신분당"])
})

test("generateTypeScriptStations emits StationDto data", () => {
  const { stations, lineColors } = normalizeStationRows(sampleRows)
  const source = generateTypeScriptStations({ stations, lineColors })

  assert.match(source, /\/\/ 지하철 역 목록과 노선 색상 데이터를 제공한다\./)
  assert.match(source, /export const stations: StationDto\[\] = \[/)
  assert.match(source, /name: "신도림"/)
  assert.match(source, /lines: \["1", "2"\]/)
})

test("generateDartStations emits Flutter station data", () => {
  const { stations, lineColors } = normalizeStationRows(sampleRows)
  const source = generateDartStations({ stations, lineColors })

  assert.match(source, /import 'package:flutter\/material\.dart';/)
  assert.match(source, /const stations = <Station>\[/)
  assert.match(source, /Station\('신도림', \['1', '2'\], '환승역'\)/)
})
