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
    return User(
      id: attrs["id"] as? Int64 ?? Int64(arc4random_uniform(1000)),
      handle: attrs["handle"] as? String ?? UUID().uuidString
    )
  }

//  static func fixture(id: Int64 = Int64(arc4random_uniform(1000)),
//                      handle: String = UUID().uuidString) -> User {
//    return User(id: id, handle: handle)
//  }

  static func fixture(dbQueue: DatabaseQueue, attrs: [String: Any] = [:]) throws -> User {
    let user = fixture(attrs: attrs)
    return try dbQueue.write { db -> User in
      try user.insert(db)
      return user
    }
  }
}
