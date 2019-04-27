
import UIKit

final class GenerationCarouselCell: UICollectionViewCell {

    struct DataSource {
        let urlImage: URLImage?
        let text: String?
    }

    var dataSource: DataSource? {
        didSet {
            self.imageView.urlImage = self.dataSource?.urlImage
            self.textLabel.text = self.dataSource?.text
        }
    }

    private let imageView: URLImageView
    private let textLabel: UILabel

    override init(frame: CGRect) {

        self.imageView = URLImageView(frame: .zero)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true

        self.textLabel = UILabel(frame: .zero)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.font = .preferredFont(forTextStyle: .body)
        self.textLabel.textAlignment = .center

        super.init(frame: frame)

        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.textLabel)

        NSLayoutConstraint.activate([

            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.textLabel.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

            self.textLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.textLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.3),
            ])
    }

    required init?(coder _: NSCoder) {
        fatalError()
    }
}
