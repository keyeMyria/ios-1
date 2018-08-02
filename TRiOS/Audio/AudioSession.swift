import AVFoundation

protocol AudioSessionType {
  func setup() throws
  func activate() throws
  func deactivate() throws

  var recordPermission: AVAudioSession.RecordPermission { get }
}

enum AudioSessionError: Error {
  case microphoneUnauthorized
  case category(error: Error)
  case unavailableMode
  case unavailableCategory
  case noPermission
}

final class AudioSession: AudioSessionType {
  private let session: AVAudioSession
  private let onDeniedRecordPermission: () -> Void

  var recordPermission: AVAudioSession.RecordPermission {
    return session.recordPermission
  }

  init(session: AVAudioSession = .sharedInstance(),
       onDeniedRecordPermission: @escaping () -> Void) {
    self.session = session
    self.onDeniedRecordPermission = onDeniedRecordPermission
  }

  deinit {
    try? deactivate()
  }

  // TODO move to init
  func setup() throws {
    guard session.availableModes.contains(.voiceChat) else {
      throw AudioSessionError.unavailableMode
    }

    guard session.availableCategories.contains(.playAndRecord) else {
      throw AudioSessionError.unavailableCategory
    }

    do {
      if #available(iOS 10.0, *) {
        try session.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .duckOthers])
      } else {
        // TODO
//        try session.setCategory(.playAndRecord, with: [.defaultToSpeaker, .duckOthers])
//        try session.setMode(.voiceChat)
      }
      setupNotifications()
    } catch {
      throw AudioSessionError.category(error: error)
    }
  }

  // TODO is it noop? use state: .active | .inactive?
  func activate() throws {
    try session.setActive(true)
  }

  func deactivate() throws {
    try session.setActive(false)
  }

  private func setupNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleInterruption),
                                           name: AVAudioSession.interruptionNotification,
                                           object: nil)

    // TODO https://developer.apple.com/documentation/avfoundation/avaudiosession/1616540-mediaserviceswereresetnotificati
  }

  // TODO https://developer.apple.com/documentation/avfoundation/avaudiosession/1616596-interruptionnotification
  @objc private func handleInterruption(notification: Notification) {
    guard
      let userInfo = notification.userInfo,
      let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
      let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

    switch type {
    // Interruption began, take appropriate actions
    case .began: ()
    case .ended:
      if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
        let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
        if options.contains(.shouldResume) {
          // Interruption Ended - playback should resume
        } else {
          // Interruption Ended - playback should NOT resume
        }
      }
    }
  }
}
