import PlaygroundSupport

import RxSwift
import RxCocoa

import Apollo
import RxApollo
@testable import Tarradiddle

let apollo = ApolloClient(url: URL(string: "http://localhost:4000/graphql")!)
apollo.rx
  .perform(mutation: CreateUserMutation(icloudId: UUID().uuidString))
  .subscribe(onSuccess: { data in
    print(data.createUser)
  })

PlaygroundPage.current.needsIndefiniteExecution = true
