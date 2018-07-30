@testable import TRApp

import Apollo

// setup

let dbQueue = try AppDatabase.openDatabase(.inMemory)
let apollo = ApolloClient(url: "")
let service = UserService(apollo: apollo, dbQueue: dbQueue)

// try it out

service.createUser(remoteID: 15, handle: "test").subscribe(onNext: { user in
  print("created user:", user)
})

service.getUser(id: 1).subscribe(onNext: { user in
  print("fetched user:", user)
})

service.getUser(id: 100).subscribe(onNext: { user in
  print("couldn't find a user:", user)
})

service.savedUsers().subscribe(onNext: { users in
  print("all users:", users)
})
