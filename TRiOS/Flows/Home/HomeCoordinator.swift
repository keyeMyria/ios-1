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
  var childCoordinators: [Coordinating] = []

  let conversations = (0...3).map { Conversation(id: $0, converseeID: $0) }

  init(router: RouterType, dbQueue: DatabaseQueue) {
    self.router = router
    self.dbQueue = dbQueue
  }

  func start() {
    showMessaging()
  }

  private func showMessaging() {
//    let conversationService = LocalConversationService(dbQueue: dbQueue)
//    // TODO
//    conversationService.listConversations { result in
//      if case let .success(conversations) = result {
//        let messagingViewController = MessagingViewController(
//          conversations: conversations,
//          conversationService: conversationService,
//          onSettingsTapped: { [unowned self] in self.runSettingsFlow() },
//          onUserSearchTapped: { [unowned self] in self.runUserSearchFlow() }
//        )
//        self.router.setRoot(to: messagingViewController, hideBar: true)
//      }
//    }
    let conversationService = FakeConversationService()
    let messagingViewController = MessagingViewController(
      conversations: conversationService.conversations,
      conversationService: conversationService,
      onSettingsTapped: { print("settings tapped") },
      onUserSearchTapped: { print("user search tapped") }
    )
    self.router.setRoot(to: messagingViewController, hideBar: true)
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
    let coordinator = UserSearchCoordinator(router: router)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.router.popModule()
      self.remove(childCoordinator: coordinator)
    }
    add(childCoordinator: coordinator)
    coordinator.start()
  }

  //  private func runNewRunFlow() {
  //    let coordinator = NewRunCoordinator(
  //      router: router,
  //      underlyingMapView: underlyingMapView,
  //      runService: RunService(dbQueue: dbQueue)
  //    )
  //    coordinator.finishFlow = { [weak self, weak coordinator] run in
  //      self?.router.dismissModule()
  //      self?.remove(childCoordinator: coordinator)
  //      if let run = run {
  //        self?.runDetailsFlow(for: run)
  //      } else {
  //        self?.router.present(self?.homeViewController)
  //      }
  //    }
  //    add(childCoordinator: coordinator)
  //    router.dismissModule()
  //    coordinator.start()
  //  }

  //  private func runDetailsFlow(for run: Run) {
  //    let coordinator = RunDetailsCoordinator(router: router, run: run, underlyingMapView: underlyingMapView)
  //    coordinator.finishFlow = { [weak self, weak coordinator] in
  //      self?.router.dismissModule()
  //      self?.router.present(self?.homeViewController)
  //      self?.remove(childCoordinator: coordinator)
  //    }
  //    add(childCoordinator: coordinator)
  //    coordinator.start()
  //  }
}
