// 서울 열린데이터광장 역 데이터를 프로젝트 정적 데이터로 변환한다.
export const SEOUL_STATION_SERVICE = "SearchSTNBySubwayLineInfo"

export const lineColors = {
  "1": "#0052A4",
  "2": "#00A84D",
  "3": "#EF7C1C",
  "4": "#00A5DE",
  "5": "#996CAC",
  "6": "#CD7C2F",
  "7": "#747F00",
  "8": "#E6186C",
  "9": "#BDB092",
  경의중앙: "#77C4A3",
  공항: "#0090D2",
  경춘: "#0C8E72",
  경강: "#003DA5",
  신분당: "#D4003B",
  수인분당: "#FABE00",
  우이신설: "#B7C452",
  서해: "#8FC31F",
  신림: "#6789CA",
  김포골드: "#A17800",
  "GTX-A": "#9A6292",
  인천1: "#7CA8D5",
  인천2: "#ED8B00",
  의정부: "#FDA600",
  용인: "#56AA1C",
}

const lineOrder = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "경의중앙",
  "공항",
  "경춘",
  "경강",
  "신분당",
  "수인분당",
  "우이신설",
  "서해",
  "신림",
  "김포골드",
  "GTX-A",
  "인천1",
  "인천2",
  "의정부",
  "용인",
]

const lineAliases = new Map([
  ["01호선", "1"],
  ["02호선", "2"],
  ["03호선", "3"],
  ["04호선", "4"],
  ["05호선", "5"],
  ["06호선", "6"],
  ["07호선", "7"],
  ["08호선", "8"],
  ["09호선", "9"],
  ["1호선", "1"],
  ["2호선", "2"],
  ["3호선", "3"],
  ["4호선", "4"],
  ["5호선", "5"],
  ["6호선", "6"],
  ["7호선", "7"],
  ["8호선", "8"],
  ["9호선", "9"],
  ["경의선", "경의중앙"],
  ["중앙선", "경의중앙"],
  ["경의중앙선", "경의중앙"],
  ["공항철도", "공항"],
  ["공항철도선", "공항"],
  ["신분당선", "신분당"],
  ["수인분당선", "수인분당"],
  ["분당선", "수인분당"],
  ["경춘선", "경춘"],
  ["경강선", "경강"],
  ["우이신설선", "우이신설"],
  ["우이신설경전철", "우이신설"],
  ["서해선", "서해"],
  ["신림선", "신림"],
  ["김포골드라인", "김포골드"],
  ["김포도시철도", "김포골드"],
  ["인천선", "인천1"],
  ["인천1호선", "인천1"],
  ["인천2호선", "인천2"],
  ["의정부경전철", "의정부"],
  ["용인경전철", "용인"],
  ["에버라인", "용인"],
])

export function readEnvFile(content) {
  const env = {}
  for (const rawLine of content.split(/\r?\n/)) {
    const line = rawLine.trim()
    if (!line || line.startsWith("#")) {
      continue
    }

    const separator = line.indexOf("=")
    if (separator === -1) {
      continue
    }

    const key = line.slice(0, separator).trim()
    let value = line.slice(separator + 1).trim()
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1)
    }
    env[key] = value
  }
  return env
}

export function buildApiUrl({ apiKey, start, end }) {
  return `http://openapi.seoul.go.kr:8088/${encodeURIComponent(apiKey)}/json/${SEOUL_STATION_SERVICE}/${start}/${end}/`
}

export function parseSeoulStationResponse(body) {
  const parsed = JSON.parse(body)
  const payload = parsed[SEOUL_STATION_SERVICE]
  if (!payload) {
    throw new Error("서울 열린데이터광장 응답에 역 데이터가 없습니다.")
  }

  const code = payload.RESULT?.CODE
  if (code && code !== "INFO-000") {
    throw new Error(
      `서울 열린데이터광장 응답 오류. ${code}: ${payload.RESULT?.MESSAGE ?? "unknown"}`,
    )
  }

  return {
    totalCount: Number(payload.list_total_count ?? payload.row?.length ?? 0),
    rows: payload.row ?? [],
  }
}

export function normalizeLineName(value) {
  const line = String(value ?? "").trim()
  return lineAliases.get(line) ?? line.replace(/호선$/, "")
}

export function normalizeStationRows(rows, options = {}) {
  const descriptions = options.descriptions ?? new Map()
  const byName = new Map()

  for (const row of rows) {
    const name = requiredString(row.STATION_NM, "STATION_NM")
    const line = normalizeLineName(requiredString(row.LINE_NUM, "LINE_NUM"))
    const station = byName.get(name) ?? {
      name,
      description: descriptions.get(name) ?? "",
      lines: [],
      codes: [],
    }

    if (!station.lines.includes(line)) {
      station.lines.push(line)
    }

    station.codes.push({
      line,
      stationCode: stringValue(row.STATION_CD),
      externalCode: stringValue(row.FR_CODE),
      nameKo: name,
      nameEn: stringValue(row.STATION_NM_ENG),
      nameZh: stringValue(row.STATION_NM_CHN),
      nameJa: stringValue(row.STATION_NM_JPN),
    })

    byName.set(name, station)
  }

  const stations = [...byName.values()]
    .map((station) => {
      const lines = sortLines(station.lines)
      return {
        ...station,
        lines,
        description:
          station.description || (lines.length > 1 ? "환승역" : ""),
        codes: station.codes.sort(
          (a, b) =>
            compareLine(a.line, b.line) ||
            a.stationCode.localeCompare(b.stationCode, "ko"),
        ),
      }
    })
    .sort((a, b) => a.name.localeCompare(b.name, "ko"))

  return {
    source: {
      name: "서울교통공사_노선별 지하철역 정보",
      service: SEOUL_STATION_SERVICE,
      url: "https://data.seoul.go.kr/dataList/OA-15442/S/1/datasetView.do",
    },
    lineColors,
    stations,
  }
}

export function generateTypeScriptStations({ stations, lineColors }) {
  const colors = Object.entries(lineColors)
    .map(([line, color]) => `    ${quoteObjectKey(line)}: "${color}",`)
    .join("\n")
  const stationRows = stations
    .map(
      (station) =>
        `    { name: ${json(station.name)}, lines: ${tsList(station.lines)}, description: ${json(station.description)} },`,
    )
    .join("\n")

  return `// 지하철 역 목록과 노선 색상 데이터를 제공한다.
export type StationDto = {
    name: string
    lines: string[]
    description: string
}

export const lineColors: Record<string, string> = {
${colors}
}

export const stations: StationDto[] = [
${stationRows}
]
`
}

export function generateDartStations({ stations, lineColors }) {
  const colors = Object.entries(lineColors)
    .map(([line, color]) => `  ${dartString(line)}: Color(0xFF${color.slice(1)}),`)
    .join("\n")
  const stationRows = stations
    .map(
      (station) =>
        `  Station(${dartString(station.name)}, ${dartList(station.lines)}, ${dartString(station.description)}),`,
    )
    .join("\n")

  return `// 지하철 역 목록과 노선 색상 데이터를 제공한다.
import 'package:flutter/material.dart';

import '../models/station.dart';

const Map<String, Color> lineColors = {
${colors}
};

const stations = <Station>[
${stationRows}
];

Station stationByName(String name) {
  return stations.firstWhere((station) => station.name == name);
}
`
}

export function validateKnownLineColors(stations, colors = lineColors) {
  const missing = new Set()
  for (const station of stations) {
    for (const line of station.lines) {
      if (!colors[line]) {
        missing.add(line)
      }
    }
  }
  return [...missing].sort(compareLine)
}

function requiredString(value, field) {
  const text = stringValue(value)
  if (!text) {
    throw new Error(`서울 열린데이터광장 응답 필수 필드 누락. ${field}`)
  }
  return text
}

function stringValue(value) {
  return String(value ?? "").trim()
}

function sortLines(lines) {
  return [...lines].sort(compareLine)
}

function compareLine(a, b) {
  const aIndex = lineOrder.indexOf(a)
  const bIndex = lineOrder.indexOf(b)
  if (aIndex !== -1 || bIndex !== -1) {
    return (aIndex === -1 ? Number.MAX_SAFE_INTEGER : aIndex) -
      (bIndex === -1 ? Number.MAX_SAFE_INTEGER : bIndex)
  }
  return a.localeCompare(b, "ko")
}

function quoteObjectKey(key) {
  return /^[A-Za-z_$][\w$]*$/.test(key) ? key : json(key)
}

function json(value) {
  return JSON.stringify(value)
}

function tsList(values) {
  return `[${values.map(json).join(", ")}]`
}

function dartList(values) {
  return `[${values.map(dartString).join(", ")}]`
}

function dartString(value) {
  return `'${String(value).replaceAll("\\", "\\\\").replaceAll("'", "\\'")}'`
}
