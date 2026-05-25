export default {
    moduleFileExtensions: ["js", "json", "ts"],
    rootDir: ".",
    testRegex: ".*\\.spec\\.ts$",
    transform: {
        "^.+\\.(t|j)s$": ["ts-jest", { useESM: true }],
    },
    moduleNameMapper: {
        "^(\\.{1,2}/.*)\\.js$": "$1",
    },
    extensionsToTreatAsEsm: [".ts"],
    collectCoverageFrom: ["src/**/*.(t|j)s"],
    coverageDirectory: "./coverage",
    testEnvironment: "node",
}
