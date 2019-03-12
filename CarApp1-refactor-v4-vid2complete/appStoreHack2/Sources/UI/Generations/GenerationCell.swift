
import UIKit

final class GenerationCell: UITableViewCell {

    struct DataSource {
        let text: String
    }

    var dataSource: DataSource? {
        didSet {
            self.textLabel!.text = self.dataSource?.text
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.separatorInset = .zero
        self.textLabel!.numberOfLines = 0
    }

    required init?(coder _: NSCoder) {
        fatalError()
    }
}
