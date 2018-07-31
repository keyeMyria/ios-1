@testable import TRAppProxy
import GRDB

// TODO add int extension to produce many rows in the same transaction
// hence change fixture/2

protocol Fixturable {
  associatedtype Resource

  // TODO maybe allow for structs that are not persisted?
  static func fixture(attrs: [String: Any]) -> Resource
  // TODO or in database instead of dbQueue?
  static func fixture(dbQueue: DatabaseQueue, attrs: [String: Any]) throws -> Resource
}

extension User: Fixturable {
  static func fixture(attrs: [String: Any] = [:]) -> User {
    let userID: Int64
    let userHandle: String

    if let id = attrs["id"] as? Int64 {
      userID = id
    } else {
      userID = Int64(arc4random_uniform(1000))
    }

    if let handle = attrs["handle"] as? String {
      userHandle = handle
    } else {
      userHandle = UUID().uuidString
    }

    return User(id: userID, handle: userHandle)
  }

  static func fixture(dbQueue: DatabaseQueue, attrs: [String: Any] = [:]) throws -> User {
    var user = fixture(attrs: attrs)
    return try dbQueue.inDatabase { db -> User in
      try user.insert(db)
      return user
    }
  }
}
