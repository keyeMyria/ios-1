import Foundation
import AVFoundation
import RxSwift

//https://developer.apple.com/documentation/avfoundation/avaudiosession/1616463-recordpermission
//https://developer.apple.com/documentation/avfoundation/avaudiosession/1616601-requestrecordpermission

//protocol AudioRecorderType {
//  func setup() -> Observable<Void>
//  func record() -> Observable<Void> // Observable<VoiceMessage> // Observable<Audio>
//  func stop() -> Observable<Void>
//
//  var meter: Variable<Int>
//}
//
//class AudioRecorder: AudioRecorderType {
//
//  var meter = Variable<Int>(0)
//
//  func setup() -> Observable<Void> {
//    // setup meter
//    return Observable.create { observer in
//
//      let audioSession = AVAudioSession.sharedInstance()
//
//      do {
//        try audioSession.setCategory(AVAudioSessionCategoryRecord)
//        try audioSession.setMode(AVAudioSessionModeMeasurement)
//        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
//      } catch let error {
//        observer.onError(error)
//      }
//
//      return Disposables.create {
//        self.stop()
//      }
//    }
//  }
//
//  func stop() -> Observable<Void> {
//    return Observable.just(())
//  }
//
//  func record() -> Observable<Void> {
//    return Observable.just(())
//  }
//}
