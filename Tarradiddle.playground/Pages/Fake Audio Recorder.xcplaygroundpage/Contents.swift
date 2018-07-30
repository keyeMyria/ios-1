import PlaygroundSupport
import Foundation
import RxSwift
import RxCocoa
import Action
import AVKit
import AVFoundation

// want:
// mockable audio service through protocol (record, finish, cancel, play, pause)
// to be injected into a viewmodel for tests

// testable audio recorder (emits text events like "started recording" etc)
// real audio recorder

// to be conformed by real AVAudioRecorder and my FakeAudioRecorder
protocol AudioRecorderType {
//  var recording: Observable<Bool> { get }
//  var available: Observable<Bool> { get }

//  func startRecording() -> Observable<Void>
//  func finishRecording() -> Action<Void, Void>
//  func cancelRecording() -> Action<Void, Void>
}

protocol AudioViewModelType {
  // inputs
  var toRecord: ObserverType<Bool> { get }

  // outputs
  var recording: Observable<Bool> { get }
  var available: Observable<Bool> { get }
  var interrupted: Observable<Bool> { get }
}

class FakeAudioViewModel: AudioViewModelType {
  // inputs
  private(set) let toRecord = ObserverType<Bool>() // Action<Conversation, AudioRecorder.Result>

  // outputs
  private(set) let recording = Observable<Bool>()
  private(set) let available: Observable<Bool>()
  private(set) let interrupted: Observable<Bool>()
}

// rx extensions
extension AudioRecorderType {

  init(url: URL, settings: [String: Any]) {
//    self.
  }

  private func prepare(url: URL, settings: [String: Any]) -> Single<AudioRecorderType> {
    let recorder: AudioRecorderType

    do {
      recorder = try AudioRecorderType(url: url, settings: settings)
    } catch {
      return Single.error(error)
    }

    return Single.create { single in
      DispatchQueue.global(qos: .userInitiated).async {
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        single(.success(recorder))
      }

      return Disposables.create()
    }
  }
}

// AVAudioRecorder -> to protocol

final class FakeAudioRecorder: AudioRecorderType {
//  func startRecording() -> Action<Void, Void> {
//    return Action { _ in
//      return Observable.create { observer in
//        print("started recording")
//        return Disposables.create()
//      }
//    }
//  }

  lazy private(set) var available: BehaviorSubject<Bool> {
    return BehaviorSubject.create { observer in
      observer.onNext(true)
      return Disposables.create()
    }
  }

  func startRecording(recorder: AVAudioRecorder) -> Observable<Void> {
    return Observable.create { observer in
      observer.onNext(())
      observer.onCompleted()
      return Disposables.create()
    }
  }


}

final class AudioRecorder: AudioRecorderType {

}

protocol AudioServiceType {
  // has recorder
  // has player
}

final class AudioService: AudioServiceType {
//  private lazy var session: AVAudioSession = {
//    do {
//      try AVAudioSession.sharedInstance().setCategory(
//        AVAudioSessionCategoryPlayAndRecord,
//        mode: AVAudioSessionModeVoiceChat,
//        options: [AVAudioSessionCategoryOptionMixWithOthers]
//      )
//    } catch {
//      print("Failed to set the audio session category and mode: \(error.localizedDescription)")
//    }
//  }()

  private bag = DisposeBag()
  let session: AVAudioSession

  func configure() throws {
    try session.setCategory(
      AVAudioSessionCategoryPlayAndRecord,
      mode: AVAudioSessionModeVoiceChat,
      options: [AVAudioSessionCategoryOptionMixWithOthers]
    )
//    try session.setPreferredSampleRate(44_100)
//    try session.setPreferredIOBufferDuration(0.005)
  }

  func activate() throws {
    try session.setActive(true)
  }

  func deactivate() throws {
    try session.setActive(false)
  }

  func requestPermission() {
    session.requestRecordPermission { granted in }
  }

  init() throws {
    session = AVAudioSession.sharedInstance()
    try configure()
    try activate()

    // AVAudioSessionRouteChangeNotification
    // merge different interruptions + AVAudioSessionMediaServicesWereResetNotification
//    NotificationCenter.default.rx
//      .notification(.AVAudioSessionInterruption, object: session)
//      .map { notification -> AVAudioSessionInterruptionType? in
//        guard let info = notification.userInfo,
//          let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
//          let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
//            return nil
//        }
//        return type
//      }
//      .filter { $0 != nil }
//      .map { $0! }
//      .subscribe(onNext: { type in
//        switch type {
//        case .began:
//          // Interruption began, take appropriate actions (save state, update user interface)
//          return
//        case .ended:
//          guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
//            return
//          }
//          let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
//          if options.contains(.shouldResume) {
//            // Interruption Ended - playback should resume
//          }
//          return
//        }
//      })
  }

  deinit throws {
    try deactivate()
  }
}

//let audioRecorder = FakeAudioRecorder()
//audioRecorder.available.subscribe(onNext: { isAvailable in
//  print("available?: \(isAvailable)")
//})

//PlaygroundPage.current.needsIndefiniteExecution = true
