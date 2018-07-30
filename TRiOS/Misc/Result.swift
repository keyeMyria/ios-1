enum Result<T, E: Error> {
  case success(T)
  case failure(E)
}

struct AnyError: Error {
  let error: Error

  init(_ error: Error) {
    if let anyError = error as? AnyError {
      self = anyError
    } else {
      self.error = error
    }
  }
}
