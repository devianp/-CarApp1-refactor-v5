struct Specification {
    let name: String
    let version: Version
    let categories: [String] // will be same for all
}

struct Metric {
    let specification: Specification
    let category: String
    let key: String
    let value: String
}

