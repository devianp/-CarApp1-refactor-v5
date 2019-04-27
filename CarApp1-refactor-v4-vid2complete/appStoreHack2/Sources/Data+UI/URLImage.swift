
import UIKit

struct URLImage {
    let url: URL
}

extension URLImage {
    func image(scale: CGFloat, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLImageCache.shared.image(with: url, scale: scale) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
