
import UIKit

final class NameCell: UICollectionViewCell {

    var name: String? {
        didSet {
            self.nameLabel.text = self.name
        }
    }

    private let nameLabel: UILabel

    override init(frame: CGRect) {

        self.nameLabel = UILabel(frame: .zero)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.font = .preferredFont(forTextStyle: .body)

        super.init(frame: frame)

        self.backgroundColor = .white

        self.contentView.addSubview(self.nameLabel)

        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10.0),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10.0),
            ])
    }

    required init?(coder decoder: NSCoder) {
        fatalError()
    }
}
