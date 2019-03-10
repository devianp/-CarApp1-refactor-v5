
enum Result<Value> {
    case success(Value)
    case failure(Error)
}


/// created an enum that has all of the possible states that a result can be in
// an optional wouldnt contain enough information
