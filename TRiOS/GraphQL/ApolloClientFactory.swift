import Apollo

final class ApolloClientMommy {
  #if DEBUG
  private let url = URL(string: "http://localhost:4000/api/graphql")!
  #else
  private let url = URL(string: "https://lol.from.network/api/graphql")!
  #endif

  lazy var anonClient: ApolloClient = {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = [
      "x-request-id": "\(UUID().uuidString)" // TODO log somehow?
    ]
    let transport = HTTPNetworkTransport(url: url, configuration: configuration)
    return ApolloClient(networkTransport: transport)
  }()

  lazy var authedClient: ApolloClient = {
    let token = "SFMyNTY.g3QAAAACZAAEZGF0YWEPZAAGc2lnbmVkbgYA7JpdAWMB.sYIvpEcsBLYtyYeUwyRvd5QirX-RxywKQGJwrEv8zZ8"
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = [
      "x-request-id": "\(UUID().uuidString)",
      "authorization": "Bearer \(token)"
    ]
    let transport = HTTPNetworkTransport(url: url, configuration: configuration)
    return ApolloClient(networkTransport: transport)
  }()
}
