
import UIKit

final class SpecificationHeaderView: UIView {

    var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
        }
    }

    var text: String? {
        get {
            return self.textLabel.text
        }
        set {
            self.textLabel.text = newValue
        }
    }

    private let imageView: UIImageView
    private let textLabel: UILabel

    override init(frame: CGRect) {

        self.imageView = UIImageView(frame: .zero)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true

        self.textLabel = UILabel(frame: .zero)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.font = .preferredFont(forTextStyle: .body)
        self.textLabel.numberOfLines = 0

        super.init(frame: frame)

        self.addSubview(self.imageView)
        self.addSubview(self.textLabel)

        NSLayoutConstraint.activate([

            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 150.0),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            self.textLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 8.0),
            self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
            self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15.0),
            self.bottomAnchor.constraint(equalTo: self.textLabel.bottomAnchor),
            ])
    }

    required init?(coder _: NSCoder) {
        fatalError()
    }
}
