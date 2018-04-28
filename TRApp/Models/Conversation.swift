import Foundation
import GRDB

struct Conversation: Codable {
  var id: Int64?
  var remoteID: Int64?

//  let friendshipID
  let userID: Int64 // with whom the conversation is

  enum CodingKeys: String, CodingKey {
    case userID = "user_id"
    case remoteID = "remote_id"

    case id
  }
}

extension Conversation: RowConvertible {}

extension Conversation: MutablePersistable {
  static var databaseTableName = "conversations"
  mutating func didInsert(with rowID: Int64, for column: String?) {
    id = rowID
  }
}
