import GRDB

/// Models a user saved locally for some reason
///
/// It could've been saved because it's a friend ...
struct User: Codable {
  var id: Int64? // need it? can just use rowid maybe?
  var remoteID: Int64
  var handle: String

  enum CodingKeys: String, CodingKey {
    case remoteID = "remote_id"

    case id
    case handle
  }
}

// MARK: - GRDB

extension User {
  enum Columns {
    static let id = Column("id")
    static let remoteID = Column("remote_id")
    static let handle = Column("handle")
  }
}

// Comment from GRDB demo project:
//
// Adopt RowConvertible so that we can fetch players from the database.
// Implementation is automatically derived from Codable.
extension User: RowConvertible {}

// Another useful comment from GRDB demo project:
//
// Adopt MutablePersistable so that we can create/update/delete players in the database.
// Implementation is partially derived from Codable.
extension User: MutablePersistable {
  static var databaseTableName = "saved_users" // move to in AppDatabase.Tables.users.rawValue
  mutating func didInsert(with rowID: Int64, for column: String?) {
    id = rowID
  }
}
