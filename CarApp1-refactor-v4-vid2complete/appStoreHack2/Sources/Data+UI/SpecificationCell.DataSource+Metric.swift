
extension SpecificationCell.DataSource {
    init(metric: Metric) {
        self.key = metric.key
        self.value = metric.value
    }
}
