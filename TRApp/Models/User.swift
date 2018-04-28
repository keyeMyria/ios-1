import GRDB

/// Models a user saved locally for some reason
///
/// It could've been saved because it's a friend ...
struct User: Codable {
  var id: Int64? // TODO need it? can just use rowid maybe?
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

extension User: RowConvertible {}

extension User: MutablePersistable {
  static var databaseTableName = "saved_users" // TODO move to in AppDatabase.Tables.users.rawValue
  mutating func didInsert(with rowID: Int64, for column: String?) {
    id = rowID
  }
}
