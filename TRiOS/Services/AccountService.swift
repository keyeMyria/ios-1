import Foundation
import GRDB

protocol AccountServiceType {
  var user: User { get }
}

//final class AccountService: AccountServiceType {
//  private let dbQueue: DatabaseQueue
//
//  let user: User
//
//  init(userID: Int, dbQueue: DatabaseQueue) {
//    self.dbQueue = dbQueue
//
//    maybeUser = dbQueue.inDatabase { db in
//      return User.fetchOne(db)
//    }
//
//    // tries to load the user from the local database
//    if let user = maybeUser {
//
//    } else {
//      // otherwise loads the user from the backend
//
//    }
//  }
//}
