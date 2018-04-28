import Foundation
import GRDB

struct VoiceMessage: Codable {
  var id: Int64?
  let remoteID: Int64
  var audioFileRemoteURL: String?
  let audioFileLocalPath: String
  let authorID: Int64
  let conversationID: Int64
  let meterLevels: [Int]

  enum CodingKeys: String, CodingKey {
    case remoteID = "remote_id"
    case audioFileRemoteURL = "audio_file_remote_url"
    case audioFileLocalPath = "audio_file_local_path"
    case authorID = "author_id"
    case conversationID = "conversation_id"
    case meterLevels = "meter_levels"

    case id
  }
}

extension VoiceMessage: RowConvertible {}

extension VoiceMessage: MutablePersistable {
  static var databaseTableName = "voice_messages"
  mutating func didInsert(with rowID: Int64, for column: String?) {
    id = rowID
  }
}
