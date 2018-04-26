// for testing things out

import RxSwift

//Observable.from(["hello", "darkness", "my", "old", "friend"])
//  .map { $0.uppercased() }
//  .subscribe(onNext: { print($0) })

import Apollo
import RxApollo
@testable import Tarradiddle

let apollo = ApolloClient(url: URL(string: "http://localhost:4000/graphql")!)
apollo.rx
  .perform(mutation: CreateUserMutation(icloudId: "from xcode"))
  .subscribe(onSuccess: { data in
    print(data.createUser)
  }, onError: { error in
    print(error)
  }, onCompleted: {
    print("completed")
  })

apollo.perform(mutation: CreateUserMutation(icloudId: "from xcode")) { result, error in
  print(result)
}
