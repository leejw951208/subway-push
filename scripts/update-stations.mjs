// 서울 열린데이터광장에서 최신 역 데이터를 가져와 정적 데이터 파일을 생성한다.
import { mkdir, readFile, writeFile } from "node:fs/promises"
import { dirname, resolve } from "node:path"
import { fileURLToPath } from "node:url"

import {
  buildApiUrl,
  generateDartStations,
  generateTypeScriptStations,
  normalizeStationRows,
  parseSeoulStationResponse,
  readEnvFile,
  validateKnownLineColors,
} from "./station-data.mjs"

const rootDir = resolve(dirname(fileURLToPath(import.meta.url)), "..")

async function main() {
  const env = await loadRootEnv()
  const apiKey = env.SEOUL_OPEN_DATA_API_KEY
  if (!apiKey) {
    throw new Error("SEOUL_OPEN_DATA_API_KEY가 루트 .env에 없습니다.")
  }

  const rows = await fetchAllRows(apiKey)
  const normalized = normalizeStationRows(rows)
  const missingLineColors = validateKnownLineColors(normalized.stations)
  if (missingLineColors.length > 0) {
    console.warn(`노선 색상 미정의. ${missingLineColors.join(", ")}`)
  }

  await mkdir(resolve(rootDir, "data"), { recursive: true })
  await writeFile(
    resolve(rootDir, "data/stations.json"),
    `${JSON.stringify(normalized, null, 2)}\n`,
  )
  await writeFile(
    resolve(rootDir, "apps/api/src/stations/stations.data.ts"),
    generateTypeScriptStations(normalized),
  )
  await writeFile(
    resolve(rootDir, "apps/mobile/lib/data/stations.dart"),
    generateDartStations(normalized),
  )

  console.log(`역 데이터 갱신 완료. ${normalized.stations.length}개 역`)
}

async function loadRootEnv() {
  const content = await readFile(resolve(rootDir, ".env"), "utf8")
  return readEnvFile(content)
}

async function fetchAllRows(apiKey) {
  const first = await fetchRange(apiKey, 1, 1000)
  if (first.totalCount <= first.rows.length) {
    return first.rows
  }

  const rows = [...first.rows]
  for (let start = 1001; start <= first.totalCount; start += 1000) {
    const end = Math.min(start + 999, first.totalCount)
    rows.push(...(await fetchRange(apiKey, start, end)).rows)
  }
  return rows
}

async function fetchRange(apiKey, start, end) {
  const url = buildApiUrl({ apiKey, start, end })
  const response = await fetch(url)
  if (!response.ok) {
    throw new Error(`서울 열린데이터광장 요청 실패. HTTP ${response.status}`)
  }
  return parseSeoulStationResponse(await response.text())
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : error)
  process.exitCode = 1
})
