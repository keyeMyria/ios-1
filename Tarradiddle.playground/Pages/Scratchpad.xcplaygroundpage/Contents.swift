import PlaygroundSupport
// for testing things out

import RxSwift
import RxCocoa

//Observable.from(["hello", "darkness", "my", "old", "friend"])
//  .map { $0.uppercased() }
//  .subscribe(onNext: { print($0) })

import Apollo
import RxApollo
@testable import Tarradiddle

let url = URL(string: "http://localhost:4000/graphql")!

//let apollo = ApolloClient(url: url)
//apollo.rx
//  .perform(mutation: CreateUserMutation(icloudId: UUID().uuidString))
//  .subscribe(onSuccess: { data in
//    print(data.createUser)
//  })

// for user id 15
let token = "SFMyNTY.g3QAAAACZAAEZGF0YWEPZAAGc2lnbmVkbgYA7JpdAWMB.sYIvpEcsBLYtyYeUwyRvd5QirX-RxywKQGJwrEv8zZ8"

let config = URLSessionConfiguration.default
config.httpAdditionalHeaders = [
  "authorization": "Bearer \(token)"
]

let apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: config))
print("asdf")
apollo.rx
  .fetch(query: UsersQuery(searchQuery: "idiot"))
  .subscribe(onSuccess: { data in
    print(data.users)
  })

PlaygroundPage.current.needsIndefiniteExecution = true
