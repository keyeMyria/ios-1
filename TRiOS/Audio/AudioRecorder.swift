import AVFoundation

protocol AudioRecorderType {
  func start() throws
  func pause()
  func cancel() throws
  func finish() throws
}

enum AudioRecorderError: RankedError {
  var severity: RankedErrorSeverity {
    switch self {
    case .initialization, .micUnauthorized:
      return .init(level: .medium, duration: .permanent)
    }
  }

  case initialization(error: Error)
  // handle mic unauth permission through error coordinator (need approppriate ranked error)
  case micUnauthorized
}

final class AudioRecorder: AudioRecorderType {
  typealias MeteringLevel = (averagePower: Float, peakPower: Float)

  private let recorderSettings: [String: Any] = [
//    AVFormatIDKey: Int(kAudioFormatMPEG4AAC_HE_V2),
    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
//    AVEncoderBitRateKey: 12_000,
    AVNumberOfChannelsKey: 1,
    AVSampleRateKey: 44_100
  ]

  private let recorder: AVAudioRecorder
  private let audioSession: AudioSessionType
  private var meterTimer: Timer?
  private let onMetersChange: (MeteringLevel) -> Void

  init(url: URL,
       audioSession: AudioSessionType,
       onMetersChange: @escaping (MeteringLevel) -> Void) throws {
    self.audioSession = audioSession
    self.onMetersChange = onMetersChange
    do {
      recorder = try AVAudioRecorder(url: url, settings: recorderSettings)
      recorder.isMeteringEnabled = true
      recorder.prepareToRecord()
      //    recorder.delegate = self // TODO can be put into a convinience init?
//      switch audioSession.recordPermission {
//      case .denied: ()
//      default: ()
//      }
    } catch {
      throw AudioRecorderError.initialization(error: error)
    }
  }

  deinit {
    try? finish()
  }

  func start() throws {
    try audioSession.activate()
    recorder.record()
    activateTimer()
  }

  func cancel() throws {
    try finish()
    recorder.deleteRecording()
  }

  func pause() {
    recorder.pause()
    deactivateTimer()
  }

  func finish() throws {
    recorder.stop()
    deactivateTimer()
    try audioSession.deactivate()
  }

  private func activateTimer() {
    meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                      target: self,
                                      selector: #selector(eachTick),
                                      userInfo: nil,
                                      repeats: true)
  }

  @objc private func eachTick() {
    recorder.updateMeters()
    onMetersChange((averagePower: recorder.averagePower(forChannel: 0),
                    peakPower: recorder.peakPower(forChannel: 0)))
  }

  private func deactivateTimer() {
    meterTimer?.invalidate()
  }
}

//extension AudioRecorder: AVAudioRecorderDelegate {
//  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//    print("AudioRecorderManager did finish recording")
//  }
//
//  // TODO: send errors to server
//  func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
//    print("error encoding", error?.localizedDescription ?? "")
//  }
//}
