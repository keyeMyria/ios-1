import Foundation

protocol AudioServiceType {
  func startRecording(for conversation: Conversation) throws
  func cancelRecording() throws
  func finishRecording(callback: @escaping (Result<AudioService.RecordingResult, AnyError>) -> Void)
}

final class AudioService: AudioServiceType {
  private var currentAudioRecorder: AudioRecorderType?
  private let audioSession: AudioSessionType
  private var currentMeters: [UInt8] = []
  private var currentURL: URL?

  typealias RecordingResult = (url: URL, meters: [UInt8])

  init(audioSession: AudioSessionType) {
    self.audioSession = audioSession
  }

  func startRecording(for conversation: Conversation) throws {
    currentMeters.removeAll()
    if let currentURL = try? AppFS.audioURL() {
      self.currentURL = currentURL
      currentAudioRecorder = try AudioRecorder(
        url: currentURL,
        audioSession: audioSession,
        onMetersChange: { [weak self] in
          let scaled = ($0.peakPower + 160) / 160 * 250
          print("raw", $0.peakPower, "scaled", scaled)
          self?.currentMeters.append(UInt8(scaled))
        }
      )
      currentAudioRecorder?.setup()
      try currentAudioRecorder?.start()
    }
  }

  func cancelRecording() throws {
    try currentAudioRecorder?.cancel()
  }

  func finishRecording(callback: @escaping (Result<AudioService.RecordingResult, AnyError>) -> Void) {
    if let currentAudioRecorder = currentAudioRecorder, let recordingURL = currentURL {
      do {
        try currentAudioRecorder.finish()
        let recordedMeters = currentMeters
        currentMeters.removeAll()
        callback(.success((url: recordingURL, meters: recordedMeters)))
      } catch {
        callback(.failure(AnyError(error)))
      }
    }
  }
}
