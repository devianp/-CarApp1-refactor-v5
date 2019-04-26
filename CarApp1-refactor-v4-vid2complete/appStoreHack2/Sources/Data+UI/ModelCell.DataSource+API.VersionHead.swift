
extension ModelCell.DataSource {
    init(version: API.VersionHead) {
        self.text = version.name
    }
}
