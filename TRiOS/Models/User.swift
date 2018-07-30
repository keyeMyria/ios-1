import GRDB

/// Models a user saved locally for some reason
///
/// It could've been saved because it's a friend or because it's the current user
struct User: Codable {
  let id: Int64
  let handle: String
}

extension User {
  enum Columns {
    static let id = Column("id")
    static let handle = Column("handle")
  }
}

extension User: RowConvertible {}
extension User: Persistable {
  static let databaseTableName = AppDatabase.Tables.users
  static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: .replace, update: .abort)
}

extension User: Equatable {
  static func == (lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id
  }
}

// - MARK: Queries
//extension User {
////  static struct
////  var friends
//}
