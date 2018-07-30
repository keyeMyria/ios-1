import GRDB

struct Friendship {
  let id: Int64
  let friendID: Int64

  // Preloadable
  var friend: User?

  init(id: Int64, friendID: Int64) {
    self.id = id
    self.friendID = friendID
  }

  init(id: Int64, friend: User) {
    self.id = id
    self.friendID = friend.id
    self.friend = friend
  }
}

extension Friendship: RowConvertible {
  init(row: Row) {
    id = row["id"]
    friendID = row["friend_id"]

    if let friendHandle: String = row["handle"] {
      friend = User(id: friendID, handle: friendHandle)
    }
  }
}

extension Friendship: Persistable {
  func encode(to container: inout PersistenceContainer) {
    container["id"] = id
    container["friend_id"] = friendID
  }

  static let databaseTableName = AppDatabase.Tables.friendships
}

extension Friendship: Equatable {
  static func == (lhs: Friendship, rhs: Friendship) -> Bool {
    return lhs.id == rhs.id && lhs.friendID == rhs.friendID
  }
}

// - MARK: Queries
extension Friendship {
  var friendQuery: QueryInterfaceRequest<User> {
    return User.filter(User.Columns.id == friendID)
  }
}
