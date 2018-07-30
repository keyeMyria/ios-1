import Foundation
import GRDB

struct VoiceMessage: Codable {
  let id: Int64
//  var audioFileRemoteURL: String?
//  let audioFileLocalPath: String
  let authorID: Int64
  let conversationID: Int64
  var insertedAt: Date?
  let meterLevelsUnscaled: [UInt8]

  var meterLevelsScaled: [Float] {
    return meterLevelsUnscaled.map { Float($0) / Float(UInt8.max) }
  }

  enum CodingKeys: String, CodingKey {
//    case audioFileRemoteURL = "audio_file_remote_url"
//    case audioFileLocalPath = "audio_file_local_path"
    case authorID = "author_id"
    case conversationID = "conversation_id"
    case meterLevelsUnscaled = "meter_levels"
    case insertedAt = "inserted_at"

    case id
  }
}

extension VoiceMessage {
  enum Columns {
    static let id = Column("id")
    static let authorID = Column("author_id")
    static let conversationID = Column("conversation_id")
    static let insertedAt = Column("inserted_at")
  }
}

extension VoiceMessage {
  init(id: Int64, author: User, conversation: Conversation, meterLevelsUnscaled: [UInt8] = []) {
    self.id = id
    authorID = author.id
    conversationID = conversation.id
    self.meterLevelsUnscaled = meterLevelsUnscaled
  }

  init(id: Int64, authorID: Int64, conversationID: Int64, meterLevelsUnscaled: [UInt8] = []) {
    self.id = id
    self.authorID = authorID
    self.conversationID = conversationID
    self.meterLevelsUnscaled = meterLevelsUnscaled
  }
}

extension VoiceMessage: RowConvertible {}
extension VoiceMessage: Persistable {
  static var databaseTableName = AppDatabase.Tables.voiceMessages
}

extension VoiceMessage: Equatable {
  static func == (lhs: VoiceMessage, rhs: VoiceMessage) -> Bool {
    return lhs.id == rhs.id &&
      lhs.conversationID == rhs.conversationID &&
      lhs.authorID == rhs.authorID
  }
}

// - MARK: Queries
extension VoiceMessage {
  var authorQuery: QueryInterfaceRequest<User> {
    return User.filter(User.Columns.id == authorID)
  }

  var conversationQuery: QueryInterfaceRequest<Conversation> {
    return Conversation.filter(Conversation.Columns.id == conversationID)
  }
}
