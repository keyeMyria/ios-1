import GRDB

struct Conversation {
  let id: Int64

  // TODO maybe use friendshipID
  // TODO maybe use a join table (users_to_conversations)
  let converseeID: Int64
  var insertedAt: Date?

  // preloadable
//  var conversee: User?
//  var voiceMessages: [VoiceMessage]?
}

extension Conversation {
  init(id: Int64, converseeID: Int64) {
    self.id = id
    self.converseeID = converseeID
    self.insertedAt = nil
  }

//  init(id: Int64, conversee: User) {
//    self.id = id
//    self.converseeID = conversee.id
//    self.conversee = conversee
//  }
}

extension Conversation: Equatable {
  static func == (lhs: Conversation, rhs: Conversation) -> Bool {
    return lhs.id == rhs.id && lhs.converseeID == rhs.converseeID
  }
}

extension Conversation {
  enum Columns: String, ColumnExpression {
    case insertedAt = "inserted_at"
    case converseeID = "conversee_id"
    case id
  }
}

extension Conversation: FetchableRecord {
  init(row: Row) {
    id = row[Columns.id]
    insertedAt = row[Columns.insertedAt]
    converseeID = row[Columns.converseeID]

//    if let converseeHandle: String = row["handle"] {
//      conversee = User(id: converseeID, handle: converseeHandle)
//    }
  }
}

extension Conversation: TableRecord {
  static let databaseTableName = "conversations"
}

extension Conversation: PersistableRecord {
  static let persistenceConflictPolicy = PersistenceConflictPolicy(
    insert: .replace,
    update: .abort // TODO
  )

  func encode(to container: inout PersistenceContainer) {
    container[Columns.id] = id
    container[Columns.insertedAt] = insertedAt
    container[Columns.converseeID] = converseeID
  }
}

extension Conversation {
  static let converseeRelationship = belongsTo(User.self)
  var converseeRequest: QueryInterfaceRequest<User> {
    return request(for: Conversation.converseeRelationship)
  }

  static let voiceMessagesRelationship = hasMany(VoiceMessage.self)
  var voiceMessagesRequest: QueryInterfaceRequest<VoiceMessage> {
    // TODO add cursor (after:, before:): WHERE id > ? and id < ? (in service)
    return request(for: Conversation.voiceMessagesRelationship)
  }
}
