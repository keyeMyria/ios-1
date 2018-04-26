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

let apollo = ApolloClient(url: URL(string: "http://localhost:4000/graphql")!)
apollo.rx
  .perform(mutation: CreateUserMutation(icloudId: UUID().uuidString))
  .subscribe(onSuccess: { data in
    print(data.createUser)
  })

PlaygroundPage.current.needsIndefiniteExecution = true
