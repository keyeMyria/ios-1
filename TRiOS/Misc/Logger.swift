import Foundation

final class Logger {
  static let shared = Logger()

  enum Level: Int {
    case debug = 0
    case info
    case warn
    case error
  }

  enum Backend {
    case sqlite
    case fs
    case memory
  }

  let minimumLevel: Level = .info
  let backend: Backend = .sqlite

//  fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
//  fileLogger.logFileManager.maximumNumberOfLogFiles = 7

  private init() {}

  func log(_ message: String, level: Level = .info) {
    if level.rawValue > minimumLevel.rawValue {
      //    backend.log(message)
    }
  }
}

protocol Logging {
  func log(_ message: String, level: Logger.Level)
}

extension Logging {
  func log(_ message: String, level: Logger.Level = .info) {
    Logger.shared.log(message, level: level)
  }
}
