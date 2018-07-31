import Foundation
import GRDB

@testable import TRAppProxy

// https://github.com/yapstudios/YapDatabase/wiki/SQLite-version-(bundled-with-OS)

let dbQueue = try! AppDatabase.openDatabase(.inMemory) as! DatabaseQueue

@discardableResult
func withDatabase<T>(closure: @escaping (Database) throws -> T?) -> T? {
  do {
    return try dbQueue.inDatabase(closure)
  } catch {
    print("withDatabase: \(error.localizedDescription)")
    return nil
  }
}

// create some users

try! dbQueue.inDatabase { db in
  try User(id: 1, handle: "fake").insert(db) // let "fake" be the current user
  try User(id: 2, handle: "faker").insert(db)
  try Friendship(id: 1, friendID: 2).insert(db) // then friendID is faker's id
  try User(id: 1, handle: "fakerer").insert(db)
}

let friendship = withDatabase { db in
  return try Friendship.filter(key: 1).fetchOne(db)
}

let friend = withDatabase { db in
  return try friendship?.friendQuery.fetchOne(db)
}

let sql = """
SELECT f.id, f.friend_id, u.handle
FROM friendships AS f
LEFT JOIN users AS u ON f.friend_id = u.id
WHERE f.id = 1;
"""

withDatabase { db in
  return try Row.fetchOne(db, sql).map { row in
    return (id: row[0], friendID: row[1], friendHandle: row[2])
  }
}

withDatabase { db in
  return try Friendship.fetchOne(db, sql)
}

// check how ON CONFLICT REPLACE affects observers
// https://sqlite.org/c3ref/update_hook.html
// > the update hook is not invoked when conflicting rows
// > are deleted because of an ON CONFLICT REPLACE clause

//let request = SQLRequest("SELECT * FROM persons")
//request.rx.changes(in: dbPool)
//  .subscribe(onNext: { db: Database in
//    print("Persons table has changed.")
//  })
//
//try dbPool.writeInTransaction { db in
//  try Person(name: "Arthur").insert(db)
//  try Person(name: "Barbara").insert(db)
//  return .commit // Prints "Persons table has changed."
//}
