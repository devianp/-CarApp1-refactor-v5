
import UIKit

final class URLImageCache {

    static let shared = URLImageCache()
}

extension URLImageCache {

    func image(with url: URL, scale: CGFloat, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLDataCache.shared.data(with: url) { result in
            completion(Result {
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data, scale: scale) else {
                        throw URLError(.unknown)
                    }
                    return image
                case .failure(let error):
                    throw error
                }
            })
        }
    }
}
