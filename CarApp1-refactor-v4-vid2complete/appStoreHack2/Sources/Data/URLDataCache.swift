
import Foundation

final class URLDataCache {

    static let shared = URLDataCache()
}

extension URLDataCache {

    // TODO: combine simultaneous requests for the same url
    func data(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let fileURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!).appendingPathExtension("urldatacache")
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: fileURL) {
                completion(.success(data))
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                let result = Result<Data, Error> {
                    guard error == nil, let data = data, data.isEmpty == false, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw error ?? URLError(.unknown)
                    }
                    return data
                }
                completion(result)
                do {
                    let data = try result.get()
                    try data.write(to: fileURL)
                }
                catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
}
