import class GRDB.DatabaseQueue
import Foundation

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
