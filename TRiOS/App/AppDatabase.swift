import GRDB

enum AppDatabaseError: RankedError {
  var severity: RankedErrorSeverity {
    switch self {
    case .migration:
      return .init(level: .high, duration: .permanent)
    }
  }

  case migration(error: Error)
}

enum AppDatabase {
  enum Kind {
    case inMemory
    case temp
    case onDisk(path: String)
  }

  static func openDatabase(_ kind: Kind) throws -> DatabaseQueue {
    let dbQueue: DatabaseQueue

    switch kind {
    case .inMemory: dbQueue = DatabaseQueue()
    case .temp: dbQueue = try DatabaseQueue(path: "")
    case let .onDisk(path: path): dbQueue = try DatabaseQueue(path: path)
    }

    do {
      try migrator.migrate(dbQueue)
    } catch {
      throw AppDatabaseError.migration(error: error)
    }

    return dbQueue
  }

  static var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()

    migrator.registerMigration("v0.1.0") { db in
      try db.create(table: User.databaseTableName) { t in
        t.column("id", .integer).primaryKey()
        t.column("handle", .text).collate(.localizedCaseInsensitiveCompare).notNull()
        t.column("inserted_at", .datetime).defaults(sql: "CURRENT_TIMESTAMP").notNull()
        t.column("image_url", .text)
      }

      // TODO can current user id change? if so, these would be invalid, need to store
      // user_id in the friendships table as well
      try db.create(table: Friendship.databaseTableName) { t in
        t.column("id", .integer).primaryKey()
        t.column("inserted_at", .datetime).defaults(sql: "CURRENT_TIMESTAMP").notNull()
        // TODO read up on .cascade, are these deleted when ON CONFLICT REPLACE happens on users?
        // maybe use DEFERRED
        t.column("friend_id", .integer)
          .references(User.databaseTableName, onDelete: .cascade, onUpdate: .restrict)
          .notNull()
          .unique()
      }

      try db.create(table: Conversation.databaseTableName) { t in
        t.column("id", .integer).primaryKey()
        t.column("inserted_at", .datetime).defaults(sql: "CURRENT_TIMESTAMP").notNull()
        t.column("conversee_id", .integer)
          .references(User.databaseTableName, onDelete: .cascade, onUpdate: .restrict)
          .notNull()
          .unique()
      }

      // TODO composite index on voiceMesssages.(conversation_id, author_id)?
      try db.create(table: VoiceMessage.databaseTableName) { t in
        t.column("id", .integer).primaryKey()
        t.column("inserted_at", .datetime).defaults(sql: "CURRENT_TIMESTAMP").notNull()

        t.column("conversation_id", .integer)
          .references(Conversation.databaseTableName, onDelete: .cascade, onUpdate: .restrict)
          .notNull()
          .indexed()

        t.column("author_id", .integer)
          .references(User.databaseTableName, onDelete: .cascade, onUpdate: .restrict)
          .notNull()
          .indexed()

        // a list of UInt8 stored in a Data blob
        t.column("meter_levels", .blob).defaults(to: Data()).notNull()
      }

      // TODO
      // static let voiceMessageTranscripts = "voice_message_transcripts"
      // pubkeys
    }

    return migrator
  }
}
