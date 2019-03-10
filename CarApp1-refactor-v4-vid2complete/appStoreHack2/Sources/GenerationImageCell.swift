
import UIKit

final class GenerationImageCell: UICollectionViewCell {

    var generation: Generation? {
        didSet {
            self.imageView.image = UIImage(named: "2")
            self.nameLabel.text = self.generation?.name
        }
    }

    private let imageView: UIImageView
    private let nameLabel: UILabel

    override init(frame: CGRect) {

        self.imageView = UIImageView(frame: .zero)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true

        self.nameLabel = UILabel(frame: .zero)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.font = .preferredFont(forTextStyle: .body)
        self.nameLabel.textAlignment = .center

        super.init(frame: frame)

        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.nameLabel)

        NSLayoutConstraint.activate([

            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.nameLabel.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.nameLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.3),
            ])
    }

    required init?(coder _: NSCoder) {
        fatalError()
    }
}
