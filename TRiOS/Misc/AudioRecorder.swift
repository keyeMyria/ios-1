import Foundation
import AVFoundation

//https://developer.apple.com/documentation/avfoundation/avaudiosession/1616463-recordpermission
//https://developer.apple.com/documentation/avfoundation/avaudiosession/1616601-requestrecordpermission

//protocol AudioRecorderType {
//  // TODO need these callbacks?
//  func setup(onDone: @escaping () -> Void)
//  func record(onStart: @escaping () -> Void) // Observable<VoiceMessage> // Observable<Audio>
//  func stop(onDone: @escaping () -> Void)
//
//  var meter: Int { get }
//  var onMeterChange: ((Int) -> Void)? { get set } // TODO or specify on init
//}

//final class AudioRecorder: AudioRecorderType {
//  var meter = 0
//  var onMeterChange: ((Int) -> Void)?
//
//  func setup(onDone: @escaping () -> Void) {
//    let audioSession = AVAudioSession.sharedInstance()
//    do {
//      try audioSession.setCategory(AVAudioSessionCategoryRecord)
//      try audioSession.setMode(AVAudioSessionModeMeasurement)
//      try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
//    } catch let error {
//      print(error)
//      // TODO rethrow?
//    }
//  }
//
//  func stop(onDone: @escaping () -> Void) {
//  }
//
//  func record(onStart: @escaping () -> Void) {
//  }
//}


import Foundation
import AVFoundation

// from https://www.youtube.com/watch?v=TZtf40cBltg
final class AudioRecorder: NSObject {
  static let shared = AudioRecorderManager()

  var recordingSession: AVAudioSession!
  var recorder: AVAudioRecorder!

  var filename: String!

  var meterTimer: Timer?
  var averagePower: Float = 0
  var peakPower: Float = 0

  func setup() {
    recordingSession = AVAudioSession.sharedInstance()
    do {
      try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
      try recordingSession.setActive(true)
      recordingSession.requestRecordPermission { isAllowed in
        if isAllowed {
          print("mic authorized")
        } else {
          print("mic not authorized")
        }
      }
    } catch {
      print("failed to set category", error.localizedDescription)
    }
  }

  func startRecording() {
    filename = String.random(length: 20)
    // aac_ls?
    let url = AudioRecorderManager.getUserPath()!.appendingPathComponent(filename + ".m4a")
    let audioURL = URL.init(fileURLWithPath: url.path)
    let recordedSettings: [String: Any] = [
      AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
      AVEncoderBitRateKey: 12_000.0,
      AVNumberOfChannelsKey: 1,
      AVSampleRateKey: 44_100.0
    ]

    do {
      recorder = try AVAudioRecorder(url: audioURL, settings: recordedSettings)
      recorder?.delegate = self
      recorder?.isMeteringEnabled = true
      recorder?.prepareToRecord()
      recorder?.record()

      self.meterTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
        if let recorder = self?.recorder {
          recorder.updateMeters()
          self?.averagePower = recorder.averagePower(forChannel: 0)
          self?.peakPower = recorder.peakPower(forChannel: 0)
        }
      }

      print("recording \(filename).m4a")
    } catch {
      print("error recording")
    }
  }

  func finishRecording() -> String {
    recorder?.stop()
    meterTimer?.invalidate()
    return filename
  }

  //  func deleteRecording(filename: String) {
  //    let url = getUserPath().appendingPathComponent(filename + ".m4a")
  //    let audioURL = URL.init(fileURLWithPath: url.path)
  //    FileManager.default.trashItem(at: audioURL, resultingItemURL: <#T##AutoreleasingUnsafeMutablePointer<NSURL?>?#>)
  //  }
  static private func getUserPath() -> URL? {
    return try? FileManager.default.url(
      for: .applicationSupportDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )
  }
}

extension AudioRecorder: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    print("AudioRecorderManager did finish recording")
  }

  // TODO: send errors to server
  func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
    print("error encoding", error?.localizedDescription ?? "")
  }
}
