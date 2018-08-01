import PlaygroundSupport
import UIKit

@testable import TRAppProxy

extension UInt8 {
  static func randomArray(maxLength: UInt32 = 50) -> [UInt8] {
    return (0...arc4random_uniform(maxLength)).map { i in  
      return UInt8(arc4random_uniform(UInt32(UInt8.max)))
    }
  }
}

func wave(length: Int, precision: Float) -> [UInt8] {
  let divisor = Float(length) * precision
  return (0...length).map { i -> UInt8 in
    let sinValue = sin(Float(i) / divisor) / 2 + 0.5
    return UInt8(floor(sinValue * Float(UInt8.max - 1)))
  }
}

let conversations = (0...3).map { Conversation(id: $0, converseeID: $0) }

let voiceMessages: [[VoiceMessage]] = conversations.map { conversation in
  (1...Int64(arc4random_uniform(50) + 1)).map {
    VoiceMessage(id: $0,
                 authorID: $0,
                 conversationID: conversation.id,
                 meterLevels: wave(length: Int(arc4random_uniform(50) + 1), precision: 0.3))
  }
}

final class FakeConversationService: LocalConversationServiceType {
  func loadVoiceMessages(for conversation: Conversation,
                         callback: @escaping (Result<[VoiceMessage], AnyError>) -> Void) {
    callback(.success(voiceMessages[Int(conversation.id)]))
  }

  func listConversations(callback: @escaping (Result<[Conversation], AnyError>) -> Void) {
    callback(.success(conversations))
  }
}

let messagingViewController = MessagingViewController(
  conversations: conversations,
  conversationService: FakeConversationService(),
  onSettingsTapped: { print("settings tapped") },
  onUserSearchTapped: { print("user search tapped") }
)

let parent = playgroundWrapper(
  child: messagingViewController,
  device: .phone4inch,
  orientation: .portrait
)

//CGSize(width: 375, height: 100)

//let containerSize = CGSize(width: 375, height: 400)

//messagingViewController.view.frame.size = containerSize
//messagingViewController.preferredContentSize = containerSize
//parent.preferredContentSize = parent.view.frame.size
//parent.view.frame.size

PlaygroundPage.current.liveView = parent
