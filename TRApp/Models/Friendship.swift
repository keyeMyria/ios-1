import Foundation
import GRDB

struct Friendship: Codable {
  var id: Int64?
  var remoteID: Int64?
  let userID: Int64

  enum CodingKeys: String, CodingKey {
    case userID = "user_id"
    case remoteID = "remote_id"

    case id
  }
}

extension Friendship: RowConvertible {}

extension Friendship: MutablePersistable {
  static var databaseTableName = "friendships"
  mutating func didInsert(with rowID: Int64, for column: String?) {
    id = rowID
  }
}
