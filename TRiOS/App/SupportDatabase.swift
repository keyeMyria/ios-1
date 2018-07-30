import GRDB

/// Unlike `AppDatabase`, this one is not required for the core functionality
/// of the app.
final class SupportDatabase {

  enum Kind {
    /// Used mostly for testing
    case inMemory

    /// Used in the actual app
    case onDisk(path: String)
  }

  static func openDatabase(_ kind: Kind) throws -> DatabaseWriter {
    let writer: DatabaseWriter

    switch kind {
    case .inMemory: writer = DatabaseQueue()
    case let .onDisk(path: path): writer = try DatabasePool(path: path)
    }

    try migrator.migrate(writer)
    return writer
  }

  enum Tables {
    /// Mostly crash logs which are to be sent to the backend
    /// for post-mortems
    static let logs = "logs"

    /// Complaints which were made when the app didn't have
    /// internet access, just like `.logs`, they are
    /// supposed to be sent to the backend once the internet
    /// connection is reestablished
    static let complaints = "complaints"
  }

  static var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()

    migrator.registerMigration("v0.1.0") { db in
      try db.create(table: Tables.logs) { t in
        t.column("level", .text).notNull().indexed()
        t.column("message", .text).notNull()
        t.column("inserted_at", .datetime).defaults(sql: "CURRENT_TIMESTAMP").notNull()

        // delete once sent (trigger?) or just delete and only store unsent
        t.column("sent?", .boolean).defaults(to: false).notNull().indexed()

        /// These are set in and read of AppEnvironment
        t.column("app_vesrion", .text).notNull()
        t.column("ios_version", .text).notNull()
        t.column("host_device", .text).notNull()

        // additional info stored as a blob (json utf8)
        t.column("additional_info", .blob)

        // maybe references "states" which have a state (of the app or leading to the error (like redux))
        // state can be collected via coordinators
      }

//      try db.create(table: Tables.complaints) { t in
//        t.column("id", .integer).primaryKey()
//        t.column("friend_id", .integer).notNull().unique().references(Tables.users, onDelete: .cascade)
//      }
    }

    // TODO composite index on voiceMesssages.(conversation_id, author_id)

    return migrator
  }
}
