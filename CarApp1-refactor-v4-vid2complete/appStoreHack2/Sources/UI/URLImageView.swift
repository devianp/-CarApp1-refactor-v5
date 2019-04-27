
import UIKit

final class URLImageView: UIImageView {

    var urlImage: URLImage? {
        didSet {
            self.image = nil
            self.urlImage?.image(scale: 0.0) { [weak self] result in
                self?.image = try? result.get()
            }
        }
    }
}
