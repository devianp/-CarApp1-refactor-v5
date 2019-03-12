
import Foundation

final class API {

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }
}

extension API {
    static let shared = API(session: .shared)
}

extension API {

    private func request<T: Decodable>(path: String, parameters: [String : String?] = [:], completion: @escaping (Result<T>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "e6dl4159e4.execute-api.eu-west-2.amazonaws.com"
        components.path = path
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        let task = self.session.dataTask(with: components.url!) { data, response, error in
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

    struct GenerationsResponse: Decodable {
        let generations: [Generation]
    }

    func generations(completion: @escaping (Result<GenerationsResponse>) -> Void) {
        self.request(path: "/dev/generations", completion: completion)
    }
}

extension API {

    struct GenerationResponse {
        let summary: String?
        let versions: [Version]
    }

    func generation(id: Int, completion: @escaping (Result<GenerationResponse>) -> Void) {
        self.request(path: "/dev/generation", parameters: ["id" : "\(id)"], completion: completion)
    }
}

extension API.GenerationResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case generation
    }

    private enum GenerationCodingKeys: String, CodingKey {
        case summary
        case models
    }

    private enum ModelCodingKeys: String, CodingKey {
        case modelName
        case versions
    }

    private enum VersionCodingKeys: String, CodingKey {
        case versionId
        case versionName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let generationContainer = try container.nestedContainer(keyedBy: GenerationCodingKeys.self, forKey: .generation)
        var modelsContainer = try generationContainer.nestedUnkeyedContainer(forKey: .models)
        var versions = [Version]()
        while modelsContainer.isAtEnd == false {
            let modelContainer = try modelsContainer.nestedContainer(keyedBy: ModelCodingKeys.self)
            let modelName = try modelContainer.decode(String.self, forKey: .modelName)
            var versionsContainer = try modelContainer.nestedUnkeyedContainer(forKey: .versions)
            while versionsContainer.isAtEnd == false {
                let versionContainer = try versionsContainer.nestedContainer(keyedBy: VersionCodingKeys.self)
                let id = try versionContainer.decode(Int.self, forKey: .versionId)
                let name = try versionContainer.decode(String.self, forKey: .versionName)
                let version = Version(id: id, name: name, modelName: modelName)
                versions.append(version)
            }
        }
        self.summary = try generationContainer.decode(String.self, forKey: .summary)
        self.versions = versions
    }
}
