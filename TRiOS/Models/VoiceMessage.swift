import Foundation
import GRDB

struct VoiceMessage {
  let id: Int64
//  var audioFileRemoteURL: String?
//  let audioFileLocalPath: String
  let authorID: Int64
  let conversationID: Int64
  var insertedAt: Date?
//  let meterLevelsUnscaled: [UInt8]

//  var meterLevelsScaled: [Float] {
//    return meterLevelsUnscaled.map { Float($0) / Float(UInt8.max) }
//  }
}

extension VoiceMessage: Equatable {
  static func == (lhs: VoiceMessage, rhs: VoiceMessage) -> Bool {
    return lhs.id == rhs.id &&
      lhs.conversationID == rhs.conversationID &&
      lhs.authorID == rhs.authorID
  }
}

extension VoiceMessage {
  enum Columns: String, ColumnExpression {
    case insertedAt = "inserted_at"
    case conversationID = "conversation_id"
    case authorID = "author_id"
    case id
  }
}

//extension VoiceMessage {
//  init(id: Int64, author: User, conversation: Conversation, meterLevelsUnscaled: [UInt8] = []) {
//    self.id = id
//    authorID = author.id
//    conversationID = conversation.id
//    self.meterLevelsUnscaled = meterLevelsUnscaled
//  }
//
//  init(id: Int64, authorID: Int64, conversationID: Int64, meterLevelsUnscaled: [UInt8] = []) {
//    self.id = id
//    self.authorID = authorID
//    self.conversationID = conversationID
//    self.meterLevelsUnscaled = meterLevelsUnscaled
//  }
//}

extension VoiceMessage: FetchableRecord {
  init(row: Row) {
    id = row[Columns.id]
    insertedAt = row[Columns.insertedAt]
    conversationID = row[Columns.conversationID]
    authorID = row[Columns.authorID]
  }
}

extension VoiceMessage: TableRecord {
  static let databaseTableName = "voice_messages"
}

extension VoiceMessage: PersistableRecord {
  static let persistenceConflictPolicy = PersistenceConflictPolicy(
    insert: .replace,
    update: .abort // TODO
  )

  func encode(to container: inout PersistenceContainer) {
    container[Columns.id] = id
    container[Columns.insertedAt] = insertedAt
    container[Columns.conversationID] = conversationID
    container[Columns.authorID] = authorID
  }
}

extension VoiceMessage {
  static let authorRelationship = belongsTo(User.self)
  var authorRequest: QueryInterfaceRequest<User> {
    return request(for: VoiceMessage.authorRelationship)
  }

  static let conversationRelationship = belongsTo(Conversation.self)
  var conversationRequest: QueryInterfaceRequest<Conversation> {
    return request(for: VoiceMessage.conversationRelationship)
  }
}
