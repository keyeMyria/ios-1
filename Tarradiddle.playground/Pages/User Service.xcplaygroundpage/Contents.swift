@testable import TRAppProxy

import GRDB
import Apollo

// setup

let dbQueue = try AppDatabase.openDatabase(.inMemory)
//let apollo = ApolloClient(url: "")
let service = LocalUserService(dbQueue: dbQueue)

// try it out
service.createUser(id: 15, handle: "test") { result in
  if case let .success(user) = result {
    print("created user", user)
  }
}

service.getUser(id: 15) { result in
  if case let .success(user) = result {
    print("fetched user:", user)
  }
}

service.getUser(id: 100) { result in
  if case let .success(user) = result {
    print("fetched user:", user)
  }
}

service.listUsers { result in
  if case let .success(users) = result {
    print("list users", users)
  }
}
