import GRDB

/// Models a user saved locally for some reason
///
/// It could've been saved because it's a friend or because it's the current user
struct User {
  let id: Int64
  let handle: String
  var insertedAt: Date?
}

extension User {
  // TODO need it?
  init(id: Int64, handle: String) {
    self.id
    self.handle = handle
    self.insertedAt = nil
  }
}

extension User {
  enum Columns: String, ColumnExpression {
    case insertedAt = "inserted_at"
    case id, handle
  }
}

extension User: FetchableRecord {
  init(row: Row) {
    id = row[Columns.id]
    insertedAt = row[Columns.insertedAt]
    handle = row[Columns.handle]
  }
}

extension User: TableRecord {
  static let databaseTableName = "users"
}

extension User: PersistableRecord {
  static let persistenceConflictPolicy = PersistenceConflictPolicy(
    insert: .replace,
    update: .abort // TODO
  )

  func encode(to container: inout PersistenceContainer) {
    container[Columns.id] = id
    container[Columns.insertedAt] = insertedAt
    container[Columns.handle] = handle
  }
}

extension User {
  static let friendshipsRelationship = hasMany(Friendship.self)
  var friendshipsRequest: QueryInterfaceRequest<Friendship> {
    return request(for: User.friendshipsRelationship)
  }
}
