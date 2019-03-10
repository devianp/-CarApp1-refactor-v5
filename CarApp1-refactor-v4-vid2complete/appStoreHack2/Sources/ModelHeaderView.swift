
import UIKit

final class ModelHeaderView: UIView {

    var generation: Generation? {
        didSet {
            self.imageView.image = UIImage(named: "2")
            self.nameLabel.text = self.generation?.summary
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
        self.nameLabel.numberOfLines = 0

        super.init(frame: frame)

        self.addSubview(self.imageView)
        self.addSubview(self.nameLabel)

        NSLayoutConstraint.activate([
            
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 150.0),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.nameLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 8.0),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15.0),
            
            self.bottomAnchor.constraint(equalTo: self.nameLabel.bottomAnchor),
            ])
    }

    required init?(coder _: NSCoder) {
        fatalError()
    }
}
