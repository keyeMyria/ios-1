import GRDB

struct Friendship {
  let id: Int64
  let friendID: Int64
  var insertedAt: Date?

  // Preloadable? FriendshipWithFriend?
//  var friend: User?
}

extension Friendship {
  // TODO need it?
  init(id: Int64, friendID: Int64) {
    self.id = id
    self.friendID = friendID
    self.insertedAt = nil
  }

//  init(id: Int64, friend: User) {
//    self.id = id
//    self.friendID = friend.id
//    self.friend = friend
//  }
}

extension Friendship: Equatable {
  static func == (lhs: Friendship, rhs: Friendship) -> Bool {
    return lhs.id == rhs.id && lhs.friendID == rhs.friendID
  }
}

extension Friendship {
  enum Columns: String, ColumnExpression {
    case insertedAt = "inserted_at"
    case friendID = "friend_id"
    case id
  }
}

extension Friendship: FetchableRecord {
  init(row: Row) {
    id = row[Columns.id]
    insertedAt = row[Columns.insertedAt]
    friendID = row[Columns.friendID]
//    if let friendHandle: String = row["handle"] {
//      friend = User(id: friendID, handle: friendHandle)
//    }
  }
}

extension Friendship: TableRecord {
  static let databaseTableName = "friendships"
}

extension Friendship: PersistableRecord {
  static let persistenceConflictPolicy = PersistenceConflictPolicy(
    insert: .replace,
    update: .abort // TODO
  )

  func encode(to container: inout PersistenceContainer) {
    container[Columns.id] = id
    container[Columns.insertedAt] = insertedAt
    container[Columns.friendID] = friendID
  }
}

extension Friendship {
  static let friendRelationship = belongsTo(User.self)
  var friendRequest: QueryInterfaceRequest<User> {
    return request(for: Friendship.friendRelationship)
  }
}
