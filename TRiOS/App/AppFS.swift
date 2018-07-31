import Foundation

protocol AppFSType {
  static func mainDatabaseURL() throws -> URL

  static func audioURL() throws -> URL
  static func audioURL(for filename: String) throws -> URL
}

enum AppFSError: Error {
  case database(error: Error)
  case audio(error: Error)
}

struct AppFS: AppFSType {
  static func mainDatabaseURL() throws -> URL {
    do {
      return try FileManager.default
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("db.sqlite")
    } catch {
      throw AppFSError.database(error: error)
    }
  }

  static func audioURL() throws -> URL {
    return try AppFS.audioURL(for: UUID().uuidString)
  }

  static func audioURL(for filename: String) throws -> URL {
    do {
      return try FileManager.default
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent(filename + ".m4a")
    } catch {
      throw AppFSError.audio(error: error)
    }
  }
}
