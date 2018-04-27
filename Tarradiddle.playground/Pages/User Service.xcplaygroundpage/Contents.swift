@testable import Tarradiddle

// setup

let dbQueue = try AppDatabase.openDatabase(.inMemory)
let service = UserService(dbQueue: dbQueue)

// try out

service.createUser(remoteID: 15, handle: "test").subscribe(onNext: { user in
  print("created user:", user)
})

service.getUser(by: 1).subscribe(onNext: { user in
  print("fetched user:", user)
})

service.getUser(by: 100).subscribe(onNext: { user in
  print("couldn't find a user:", user)
})

service.savedUsers().subscribe(onNext: { users in
  print("all users:", users)
})
