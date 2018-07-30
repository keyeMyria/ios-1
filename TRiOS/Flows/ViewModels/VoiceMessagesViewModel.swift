import Foundation
import RxSwift
import RxCocoa

protocol VoiceMessagesViewModelType {

  var voiceMessages: Observable<[VoiceMessage]> { get }
  var currentVoiceMessage: Variable<VoiceMessage?> { get } // TODO
//  var currentVoiceMessageProgress: BehaviorRelay<Int> { get } // TODO

//  var conversations: Observable<[Conversation]> { get }
//  var currentConversation: BehaviorRelay<Conversation> { get }

  // input (action?)
  // conversation is currentConversation?
//  func startRecording(_ conversation: Conversation) -> Observable<Void>

  // func cancelRecording()
//  func finishRecording()
  // func stop? pause? finish?

  // or maybe
//  var recording: Variable<Bool> // Variable<RecordingStatus> // .started, .cancelled, .finished
  // or var recording: Variable<(Bool, Conversation)> // to visualize the currently recorded conversation somehow

  // after the recording is finished, what happens?
  // it is rendered(live), sent(after finished), then somehow indicated that is was successfully sent
}

// currentConversation drives voiceMessages
//

final class VoiceMessagesViewModel: VoiceMessagesViewModelType {
//  var currentVoiceMessage: Variable<VoiceMessage>

  let voiceMessages = Observable.just((1...10).map {
    return VoiceMessage(
      id: $0,
      authorID: $0,
      conversationID: $0,
      meterLevelsUnscaled: (1...20).map { $0 * 10 }
    )
  })

  let currentVoiceMessage = Variable<VoiceMessage?>(nil)

  // audioService, db
  init() {

  }
}
