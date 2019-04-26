
extension SpecificationCell.DataSource {
    init(metric: API.Metric) {
        self.key = metric.key
        self.value = metric.value
    }
}
