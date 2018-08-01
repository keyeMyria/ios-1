//import Foundation
//import GRDB

//protocol AccountServiceType {
//  var user: User { get }
//}

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

import CloudKit

protocol AccountServiceType {
  // TODO move to auth service?
  func getCloudID(callback: @escaping (Result<String, AnyError>) -> Void)
}

enum AccountServiceError: Error {
  case invalidCKCallback
}

final class AccountService: AccountServiceType {
  private lazy var ckContainer = CKContainer(identifier: "iCloud.idiot.trade")

  // TODO cleanup and test
  func getCloudID(callback: @escaping (Result<String, AnyError>) -> Void) {
    ckContainer.fetchUserRecordID { recordID, error in
      guard let recordID = recordID else {
        if let error = error {
          DispatchQueue.main.async { callback(.failure(AnyError(error))) }
        } else {
          DispatchQueue.main.async { callback(.failure(AnyError(AccountServiceError.invalidCKCallback))) }
        }
        return
      }
      // TODO remove
      print("iCloudID:\(recordID.recordName)")
      DispatchQueue.main.async { callback(.success(recordID.recordName)) }
    }
  }
}
