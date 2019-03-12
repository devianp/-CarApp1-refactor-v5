
import UIKit

final class CarouselViewCell: UITableViewHeaderFooterView {

    var carouselView: CarouselView? {
        willSet {
            self.carouselView?.removeFromSuperview()
        }
        didSet {
            guard let carouselView = self.carouselView else {
                return
            }

            carouselView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(carouselView)

            NSLayoutConstraint.activate([
                carouselView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                carouselView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                carouselView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                carouselView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                ])
        }
    }
}
