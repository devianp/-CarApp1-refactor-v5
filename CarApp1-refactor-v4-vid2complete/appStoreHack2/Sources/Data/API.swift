
import Foundation

final class API {

    static let shared = API()
}

extension API {

    private func request<T: Decodable>(path: String, parameters: [String : String?] = [:], completion: @escaping (Result<T, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "e6dl4159e4.execute-api.eu-west-2.amazonaws.com"
        components.path = path
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
            completion(Result {
                guard error == nil, let data = data, data.isEmpty == false, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw error ?? URLError(.unknown)
                }
                return try JSONDecoder().decode(T.self, from: data)
            })
        }
        task.resume()
    }
}

extension API {

    struct GenerationHead: Decodable {

        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case imageURL = "image_url"
        }

        let id: Int
        let name: String
        let imageURL: URL
    }

    func generations(completion: @escaping (Result<[GenerationHead], Error>) -> Void) {
        self.request(path: "/dev/generations", completion: completion)
    }
}

extension API {

    struct GenerationResponse: Decodable {
        let generation: GenerationBody
    }

    struct GenerationBody: Decodable {
        let summary: String?
        let models: [Model]
    }

    struct Model: Decodable {

        private enum CodingKeys: String, CodingKey {
            case name = "modelName"
            case versions
        }

        let name: String
        let versions: [VersionHead]
    }

    struct VersionHead: Decodable {

        private enum CodingKeys: String, CodingKey {
            case id = "versionId"
            case name = "versionName"
        }

        let id: Int
        let name: String
    }

    func generation(id: Int, completion: @escaping (Result<GenerationResponse, Error>) -> Void) {
        self.request(path: "/dev/generation", parameters: ["id" : "\(id)"], completion: completion)
    }
}

extension API {

    struct VersionBody: Decodable {

        private enum CodingKeys: String, CodingKey {
            case imageURL = "image_url"
            case summary
            case specifications
        }

        let imageURL: URL
        let summary: String
        let specifications: [Specification]
    }

    struct Specification: Decodable {
        let name: String
        let metrics: [Metric]
    }

    struct Metric: Decodable {
        let key: String
        let value: String
    }

    func version(id: Int, completion: @escaping (Result<VersionBody, Error>) -> Void) {
        self.request(path: "/dev/version", parameters: ["id" : "\(id)"], completion: completion)
    }
}
