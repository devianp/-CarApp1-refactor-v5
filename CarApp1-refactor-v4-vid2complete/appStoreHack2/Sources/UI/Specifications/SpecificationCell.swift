
import UIKit

final class SpecificationCell: UITableViewCell {

    struct DataSource {
        let key: String
        let value: String
    }

    var dataSource: DataSource? {
        didSet {
            self.textLabel!.text = self.dataSource?.key
            self.detailTextLabel!.text = self.dataSource?.value
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.textLabel!.numberOfLines = 0
        self.detailTextLabel!.numberOfLines = 0
    }

    required init?(coder _: NSCoder) {
        fatalError()
    }
}
