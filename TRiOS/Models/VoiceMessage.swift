import Foundation
import GRDB

struct VoiceMessage {
  let id: Int64
//  var audioFileRemoteURL: String?
//  let audioFileLocalPath: String
  let authorID: Int64
  let conversationID: Int64
  var insertedAt: Date?
  let meterLevels: [UInt8]

  // TODO remove
  var meterLevelsScaled: [Float] {
    return meterLevels.map { Float($0) / Float(UInt8.max) }
  }
}

extension VoiceMessage {
  init(id: Int64, authorID: Int64, conversationID: Int64, meterLevels: [UInt8]) {
    self.id = id
    self.authorID = authorID
    self.conversationID = conversationID
    self.meterLevels = meterLevels
  }
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
    case meterLevels = "meter_levels"
    case id
  }
}

extension VoiceMessage: FetchableRecord {
  init(row: Row) {
    id = row[Columns.id]
    insertedAt = row[Columns.insertedAt]
    conversationID = row[Columns.conversationID]
    authorID = row[Columns.authorID]
    let meterLevelsBlob: Data = row[Columns.meterLevels]
    meterLevels = meterLevelsBlob.withUnsafeBytes {
      [UInt8](UnsafeBufferPointer(start: $0, count: meterLevelsBlob.count))
    }
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
    container[Columns.meterLevels] = Data(bytes: meterLevels)
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
