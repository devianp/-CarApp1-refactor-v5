
struct Version: Decodable {
    let id: Int
    let name: String
    let modelName: String
}

extension Version {
    var summary: String? {
        return nil
    }
}
