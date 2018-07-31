import PlaygroundSupport
import UIKit

@testable import TRAppProxy

import GRDB

//final class RecorderViewController: UIViewController {
//  private let audioSession = AudioSession {
//    print("denied record permission")
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    do {
//      try audioSession.setup()
//
//      let url = try AppFS.audioURL()
//
//      let recorder = try AudioRecorder(url: url, audioSession: audioSession) { meteringLevels in
//        print(meteringLevels)
//      }
//
//      recorder.setup()
//      try recorder.start()
//    } catch {
//      print(error.localizedDescription)
//    }
//  }
//}

//PlaygroundPage.current.liveView = RecorderViewController()

//var meteringLevels: [UInt8] = [1, 2, 3, 4, 5]
//let data = Data(bytes: meteringLevels)
//data.withUnsafeBytes {
//  [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
//}

let dbQueue = try! AppDatabase.openDatabase(.inMemory)

extension UInt8 {
  static func randomArray(count: UInt32 = 50) -> [UInt8] {
    return (0...count).map { _ in
      return UInt8(arc4random_uniform(UInt32(UInt8.max)))
    }
  }
}

try! dbQueue.write { db in
  try User(id: 1, handle: "alice").insert(db)
  try User(id: 2, handle: "bob").insert(db)
  try Conversation(id: 1, converseeID: 1).insert(db)
  try VoiceMessage(id: 1,
                   authorID: 1,
                   conversationID: 1,
                   meterLevels: UInt8.randomArray(count: 100_000))
    .insert(db)
}

let voiceMessage = try! dbQueue.read { db in
  return try VoiceMessage.fetchOne(db, key: 1)
}
