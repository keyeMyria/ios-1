import Apollo

protocol RemoteUserServiceType {
  func search(query: String, callback: @escaping (Result<[UsersQuery.Data], AnyError>) -> Void)
//  func getInfo(userID: Int64, callback: @escaping (Result<>))
}

final class RemoteUserService: RemoteUserServiceType {
  private let apollo: ApolloClient

  init(apollo: ApolloClient) {
    self.apollo = apollo
  }

  func search(query: String, callback: @escaping (Result<[UsersQuery.Data], AnyError>) -> Void) {
    apollo.fetch(query: UsersQuery(searchQuery: query)) { result, error in
      if let error = error {
        callback(.failure(AnyError(error)))
        return
      }

      
    }
  }
}
