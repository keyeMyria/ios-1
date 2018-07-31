import PlaygroundSupport

@testable import TRAppProxy
import Apollo

let apollo = ApolloClient(url: URL(string: "http://localhost:4000/graphql")!)
apollo.perform(mutation: CreateUserMutation(icloudId: UUID().uuidString)) { result, error in
  if let error = error { print("error", error) }
  print("result", result)
}

PlaygroundPage.current.needsIndefiniteExecution = true
