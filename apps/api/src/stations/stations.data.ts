// 지하철 역 목록과 노선 색상 데이터를 제공한다.
export type StationDto = {
    name: string
    lines: string[]
    description: string
}

export const lineColors: Record<string, string> = {
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
    분당: "#FABE00",
    신분당: "#D4003B",
    경춘: "#0C8E72",
}

export const stations: StationDto[] = [
    { name: "강남", lines: ["2", "신분당"], description: "강남구 · 환승역" },
    {
        name: "홍대입구",
        lines: ["2", "경의중앙", "공항"],
        description: "마포구 · 환승역",
    },
    { name: "잠실", lines: ["2", "8"], description: "송파구 · 환승역" },
    { name: "사당", lines: ["2", "4"], description: "관악구 · 환승역" },
    {
        name: "서울역",
        lines: ["1", "4", "경의중앙", "공항"],
        description: "용산구 · 환승역",
    },
    { name: "시청", lines: ["1", "2"], description: "중구 · 환승역" },
    { name: "종로3가", lines: ["1", "3", "5"], description: "종로구 · 환승역" },
    { name: "명동", lines: ["4"], description: "중구" },
    { name: "신도림", lines: ["1", "2"], description: "구로구 · 환승역" },
    { name: "신촌", lines: ["2"], description: "서대문구" },
    { name: "이태원", lines: ["6"], description: "용산구" },
    { name: "건대입구", lines: ["2", "7"], description: "광진구 · 환승역" },
    { name: "합정", lines: ["2", "6"], description: "마포구 · 환승역" },
    { name: "여의도", lines: ["5", "9"], description: "영등포구 · 환승역" },
    { name: "압구정", lines: ["3"], description: "강남구" },
    { name: "성수", lines: ["2"], description: "성동구" },
    { name: "신사", lines: ["3", "신분당"], description: "강남구 · 환승역" },
    { name: "교대", lines: ["2", "3"], description: "서초구 · 환승역" },
    { name: "선릉", lines: ["2", "분당"], description: "강남구 · 환승역" },
    { name: "삼성", lines: ["2"], description: "강남구" },
    { name: "역삼", lines: ["2"], description: "강남구" },
    { name: "양재", lines: ["3", "신분당"], description: "서초구 · 환승역" },
    {
        name: "왕십리",
        lines: ["2", "5", "경의중앙", "분당"],
        description: "성동구 · 환승역",
    },
    { name: "동대문", lines: ["1", "4"], description: "종로구 · 환승역" },
    { name: "광화문", lines: ["5"], description: "종로구" },
    { name: "을지로입구", lines: ["2"], description: "중구" },
    { name: "안국", lines: ["3"], description: "종로구" },
    { name: "혜화", lines: ["4"], description: "종로구" },
    { name: "서울대입구", lines: ["2"], description: "관악구" },
    { name: "강변", lines: ["2"], description: "광진구" },
]
