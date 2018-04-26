@testable import Tarradiddle
import Apollo
import RxApollo

// connect to backend running on localhost
let apollo = ApolloClient(url: URL(string: "http://localhost:4000/graphql")!)
