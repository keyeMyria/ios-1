import PlaygroundSupport
import UIKit
import RxSwift
import RxCocoa
import Anchorage

@testable import TRApp

// setup

extension UInt8 {
  static func randomArray(maxLength: UInt32 = 50) -> [UInt8] {
    return (0...arc4random_uniform(maxLength)).map { _ in
      return UInt8(arc4random_uniform(UInt32(UInt8.max)))
    }
  }
}

//UInt8.randomArray()

class FakeVoiceMessagesViewModel: VoiceMessagesViewModelType {
  let bag = DisposeBag()

  var voiceMessages: Observable<[VoiceMessage]> {
    return Observable.just((1...50).map {
      VoiceMessage(
        id: $0,
        remoteID: $0,
        audioFileRemoteURL: nil,
        audioFileLocalPath: "",
        authorID: $0,
        conversationID: $0,
        meterLevelsUnscaled: UInt8.randomArray()
      )
    })
  }

  let currentVoiceMessage = Variable<VoiceMessage?>(nil)

  init() {
    currentVoiceMessage.asObservable()
      .subscribe(onNext: { voiceMessage in
        if let voiceMessage = voiceMessage {
          print("selected voiceMessage \(voiceMessage.id!)")
        }
      })
      .disposed(by: bag)
  }
}

let fakeViewModel = FakeVoiceMessagesViewModel()

// try it out

let vc = SoundWaveCollectionViewController()
vc.viewModel = fakeViewModel

// makes view small
// about the same size as in the container vc
let containerSize = CGSize(width: 375, height: 100)
vc.view.frame.size = containerSize
vc.preferredContentSize = containerSize

let timeline = UIView()
timeline.backgroundColor = .white
vc.view.addSubview(timeline)
timeline.trailingAnchor == vc.view.trailingAnchor
timeline.leadingAnchor == vc.view.leadingAnchor
timeline.centerYAnchor == vc.view.centerYAnchor
timeline.heightAnchor == 1

PlaygroundPage.current.liveView = vc
