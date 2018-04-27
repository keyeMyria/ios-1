import Foundation
import GRDB

/// A type responsible for initializing the application database.
class AppDatabase {

  enum Kind {
    /// Used mostly for testing
    case inMemory

    /// Used in the actual app
    case onDisk(path: String)
  }

  /// Creates a fully initialized database at path
  static func openDatabase(_ kind: Kind) throws -> DatabaseQueue {
    let dbQueue: DatabaseQueue

    switch kind {
    case .inMemory:
      dbQueue = DatabaseQueue()
    case let .onDisk(path: path):
      dbQueue = try DatabaseQueue(path: path)
    }

    // Use DatabaseMigrator to define the database schema
    try migrator.migrate(dbQueue)

    return dbQueue
  }

  static var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()

    migrator.registerMigration("create saved_users table") { db in
      try db.create(table: "saved_users") { table in
        table.column("id", .integer).primaryKey() // maybe use rowid instead
        table.column("remote_id", .integer).unique() // make not null?
        table.column("handle", .text).notNull().collate(.localizedCaseInsensitiveCompare)
      }
    }

    return migrator
  }
}
