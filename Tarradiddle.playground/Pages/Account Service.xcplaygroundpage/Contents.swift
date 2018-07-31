import Foundation
import GRDB

@testable import TRAppProxy

final class FakeAccountService: AccountServiceType {
  private let dbQueue: DatabaseQueue
  let user: User

  init(user: User, dbQueue: DatabaseQueue) {
    self.dbQueue = dbQueue
    self.user = user
  }

//  static func createNewUser(iCloudToken: String) -> User {
//
//  }
}

let dbQueue = try! AppDatabase.openDatabase(.inMemory)

// when the app is launched for the first time, the user is created
// so we should create a fake one now to be then used with the account service

let fakeUser = try! dbQueue.inDatabase { db -> User in
  let fakeUser = User(id: 66, handle: "fake")
//  var fakeUser2 = User(id: 66, handle: "faker")
  try fakeUser.insert(db)
//  try fakeUser2.insert(db)
//  try User.filter(key: 66).fetchOne(db) // faker
  return fakeUser
}

let accountService = FakeAccountService(user: fakeUser, dbQueue: dbQueue)
