// depending on the severity of the error
// the app's functionality degrades "gracefully"
struct RankedErrorSeverity {
  enum Level: Int {
    // app continues to work
    // but the user might be interested in knowing there was an error
    // example: saving a recording failed due to a constraint violation (double save prevented)
    case low = 1

    // mildly inhibits the app's abilities
    // example: network interruption, mic unauthorized, icloud id unavailable
    case medium = 2

    // doesn't let the app function at all
    // example: filesystem error (can't open a database, can't save a recording)
    case high = 3
  }

  enum Duration {
    // the app can (and will) try again later
    // example: couldn't upload an audiofile to a cloud storage service
    case temporary

    // there is no reason to expect the error would be resolved later
    // example: can't authorize the user since no icloud id available
    case permanent
  }

  let level: Level
  let duration: Duration
}

protocol RankedError: Error {
  var severity: RankedErrorSeverity { get }
}

extension RankedError {
  var canProceed: Bool {
    switch (severity.level, severity.duration) {
    case (.high, .permanent): return false
    default: return true
    }
  }
}
