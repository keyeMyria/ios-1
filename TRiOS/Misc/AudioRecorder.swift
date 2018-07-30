import Foundation
import AVFoundation

//https://developer.apple.com/documentation/avfoundation/avaudiosession/1616463-recordpermission
//https://developer.apple.com/documentation/avfoundation/avaudiosession/1616601-requestrecordpermission

protocol AudioRecorderType {
  // TODO need these callbacks?
  func setup(onDone: @escaping () -> Void)
  func record(onStart: @escaping () -> Void) // Observable<VoiceMessage> // Observable<Audio>
  func stop(onDone: @escaping () -> Void)

  var meter: Int
  var onMeterChange: ((Int) -> Void)?
}

class AudioRecorder: AudioRecorderType {
  var meter = 0

  func setup(onDone: @escaping () -> Void) {
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSessionCategoryRecord)
      try audioSession.setMode(AVAudioSessionModeMeasurement)
      try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
    } catch let error {
      print(error)
      // TODO rethrow?
    }
  }

  func stop(onDone: @escaping () -> Void) {
  }

  func record(onStart: @escaping () -> Void) {
  }
}
