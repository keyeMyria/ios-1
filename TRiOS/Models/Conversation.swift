import GRDB

struct Conversation: Codable {
  let id: Int64

  // maybe use friendshipID
  // maybe use a join table (users_to_conversations)
  let converseeID: Int64

  // preloadable
  var conversee: User?
  var voiceMessages: [VoiceMessage]?

  init(id: Int64, converseeID: Int64) {
    self.id = id
    self.converseeID = converseeID
  }

  init(id: Int64, conversee: User) {
    self.id = id
    self.converseeID = conversee.id
    self.conversee = conversee
  }
}

extension Conversation {
  enum Columns {
    static let id = Column("id")
    static let converseeID = Column("conversee_id")
  }
}

extension Conversation: RowConvertible {
  init(row: Row) {
    id = row["id"]
    converseeID = row["conversee_id"]

    if let converseeHandle: String = row["handle"] {
      conversee = User(id: converseeID, handle: converseeHandle)
    }
  }
}

extension Conversation: Persistable {
  static var databaseTableName = AppDatabase.Tables.conversations

  func encode(to container: inout PersistenceContainer) {
    container["id"] = id
    container["conversee_id"] = converseeID
  }
}

extension Conversation: Equatable {
  static func == (lhs: Conversation, rhs: Conversation) -> Bool {
    return lhs.id == rhs.id && lhs.converseeID == rhs.converseeID
  }
}

// - MARK: Queries
extension Conversation {
  var converseeQuery: QueryInterfaceRequest<User> {
    return User.filter(User.Columns.id == converseeID)
  }

  var voiceMessagesQuery: QueryInterfaceRequest<VoiceMessage> {
    // TODO add cursor (after:, before:): WHERE id > ? and id < ?
    return VoiceMessage.filter(VoiceMessage.Columns.conversationID == id)
  }

  mutating func preloadVoiceMessages(db: Database) throws {
    voiceMessages = try voiceMessagesQuery.fetchAll(db)
  }
}
