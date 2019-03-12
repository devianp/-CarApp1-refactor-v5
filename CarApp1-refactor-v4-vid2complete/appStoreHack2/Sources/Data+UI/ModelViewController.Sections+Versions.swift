
extension Array where Element == ModelViewController.Section {
    init(versions: [Version]) {
        var sections = Array()
        for version in versions {
            let row = ModelViewController.Row(version: version, dataSource: .init(version: version))
            if let index = sections.firstIndex(where: { $0.title == version.modelName }) {
                sections[index].rows.append(row)
            }
            else {
                let section = ModelViewController.Section(title: version.modelName, rows: [row])
                sections.append(section)
            }
        }
        self = sections
    }
}
