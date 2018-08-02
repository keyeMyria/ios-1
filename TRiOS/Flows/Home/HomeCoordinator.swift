import class GRDB.DatabaseQueue
import Foundation

func wave(length: Int, precision: Float) -> [UInt8] {
  let divisor = Float(length) * precision
  return (1...length).map { iasdf -> UInt8 in
    let sinValue = sin(Float(iasdf) / divisor) / 2 + 0.5
    return UInt8(floor(sinValue * Float(UInt8.max - 1)))
  }
}

final class FakeConversationService: LocalConversationServiceType {
  let conversations: [Conversation]
  let voiceMessages: [[VoiceMessage]]

  init() {
    conversations = (0...3).map { Conversation(id: $0, converseeID: $0) }
    voiceMessages = conversations.map { conversation in
      (1...Int64(arc4random_uniform(50) + 1)).map {
        VoiceMessage(id: $0,
                     authorID: $0,
                     conversationID: conversation.id,
                     meterLevels: wave(length: Int(arc4random_uniform(50) + 1), precision: 0.3))
      }
    }
  }

  func loadVoiceMessages(for conversation: Conversation,
                         callback: @escaping (Result<[VoiceMessage], AnyError>) -> Void) {
    callback(.success(voiceMessages[Int(conversation.id)]))
  }

  func listConversations(callback: @escaping (Result<[Conversation], AnyError>) -> Void) {
    callback(.success(conversations))
  }
}

final class HomeCoordinator: Coordinating {
  private let router: RouterType
  private let dbQueue: DatabaseQueue
  private let audioSession: AudioSessionType
  private let apolloMommy = ApolloClientMommy()
  var childCoordinators: [Coordinating] = []

  let conversations = (0...3).map { Conversation(id: $0, converseeID: $0) }

  init(router: RouterType, dbQueue: DatabaseQueue, audioSession: AudioSessionType) {
    self.router = router
    self.dbQueue = dbQueue
    self.audioSession = audioSession
  }

  func start() {
    showMessaging()
  }

  private func showMessaging() {
    let conversationService = LocalConversationService(dbQueue: dbQueue)
    conversationService.listConversations { [weak self] result in
      guard let `self` = self else { return }
      if case let .success(conversations) = result {
        let messagingViewController = MessagingViewController(
          conversations: conversations,
          conversationService: conversationService,
          audioService: AudioService(audioSession: self.audioSession),
          onSettingsTapped: { [unowned self] in self.runSettingsFlow() },
          onUserSearchTapped: { [unowned self] in self.runUserSearchFlow() }
        )
        self.router.setRoot(to: messagingViewController, hideBar: true)
      }
    }
  }

  private func runSettingsFlow() {
    let coordinator = SettingsCoordinator(router: router)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.router.popModule()
      self.remove(childCoordinator: coordinator)
    }
    add(childCoordinator: coordinator)
    coordinator.start()
  }

  private func runUserSearchFlow() {
    let coordinator = UserSearchCoordinator(router: router,
                                            localUserService: LocalUserService(dbQueue: dbQueue),
                                            remoteUserService: RemoteUserService(apollo: apolloMommy.authedClient))
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.router.popModule()
      self.remove(childCoordinator: coordinator)
    }
    add(childCoordinator: coordinator)
    coordinator.start()
  }
}
