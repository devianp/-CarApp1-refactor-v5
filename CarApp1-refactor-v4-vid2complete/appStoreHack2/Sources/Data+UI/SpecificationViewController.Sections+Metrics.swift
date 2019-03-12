
extension Array where Element == SpecificationViewController.Section {
    init(metrics: [Metric]) {
        var sections = Array()
        for metric in metrics {
            let row = SpecificationViewController.Row(dataSource: .init(metric: metric))
            if let index = sections.firstIndex(where: { $0.title == metric.category }) {
                sections[index].rows.append(row)
            }
            else {
                let section = SpecificationViewController.Section(title: metric.category, rows: [row])
                sections.append(section)
            }
        }
        self = sections
    }
}
