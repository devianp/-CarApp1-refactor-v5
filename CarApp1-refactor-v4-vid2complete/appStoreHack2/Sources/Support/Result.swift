
enum Result<Value> {
    case success(Value)
    case failure(Error)
}

extension Result {
    init(wrap: () throws -> Value) {
        do {
            self = .success(try wrap())
        }
        catch {
            self = .failure(error)
        }
    }
}

extension Result {
    func unwrap() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

extension Result {
    func map<T>(transform: (Value) throws -> T) -> Result<T> {
        return Result<T> {
            try transform(try self.unwrap())
        }
    }
}
