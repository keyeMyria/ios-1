import Apollo

final class ApolloClientMommy {
  #if DEBUG
  private let url = URL(string: "http://localhost:4000/api/graphql")!
  #else
  private let url = URL(string: "https://trapp.yolocast.wtf/api/graphql")!
  #endif

  private let token: String

  init(token: String) {
    self.token = token
  }

  lazy var anonClient: ApolloClient = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = [
      "x-request-id": "\(UUID().uuidString)"
    ]
    let transport = HTTPNetworkTransport(url: url, configuration: configuration)
    return ApolloClient(networkTransport: transport)
  }()

  lazy var authedClient: ApolloClient = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = [
      "x-request-id": "\(UUID().uuidString)",
      "authorization": "Bearer \(token)"
    ]
    let transport = HTTPNetworkTransport(url: url, configuration: configuration)
    return ApolloClient(networkTransport: transport)
  }()
}
