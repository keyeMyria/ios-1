import class GRDB.DatabaseQueue

final class HomeCoordinator: Coordinating {
  private let router: RouterType
  private let dbQueue: DatabaseQueue
  private let audioSession: AudioSessionType
  private let conversationService: LocalConversationServiceType
  // need to be able to work offline? NetworkBoundary?
  private let apolloMommy = ApolloClientMommy(token: "asdfasdf")
  var childCoordinators: [Coordinating] = []

  init(router: RouterType, dbQueue: DatabaseQueue, audioSession: AudioSessionType) {
    self.router = router
    self.dbQueue = dbQueue
    self.audioSession = audioSession
    conversationService = LocalConversationService(dbQueue: dbQueue)
  }

  func start() {
    conversationService.listConversations { [weak self] result in
      guard let `self` = self else { return }
      switch result {
      case let .success(conversations): self.showMessaging(with: conversations)
      case let .failure(error): self.runErrorFlow(for: error)
      }
    }
  }

  private func showMessaging(with conversations: [Conversation]) {
    let messagingViewController = MessagingViewController(
      conversations: conversations, // ?
      conversationService: conversationService,
      audioService: AudioService(audioSession: self.audioSession),
      onAction: { [unowned self] action in
        switch action {
        case .settingsTapped: self.runSettingsFlow()
        case .userSearchTapped: self.runUserSearchFlow()
        }
      }
    )
    self.router.setRoot(to: messagingViewController, hideBar: true)
  }

  private func runSettingsFlow() {
    let settingsCoordinator = SettingsCoordinator(router: router)
    settingsCoordinator.finishFlow = { [unowned self, unowned settingsCoordinator] in
      self.router.popModule()
      self.remove(childCoordinator: settingsCoordinator)
    }
    add(childCoordinator: settingsCoordinator)
    settingsCoordinator.start()
  }

  private func runUserSearchFlow() {
    let userSearchCoordinator = UserSearchCoordinator(
      router: router,
      localUserService: LocalUserService(dbQueue: dbQueue),
      remoteUserService: RemoteUserService(apollo: apolloMommy.authedClient)
    )
    userSearchCoordinator.finishFlow = { [unowned self, unowned userSearchCoordinator] in
      self.router.popModule()
      self.remove(childCoordinator: userSearchCoordinator)
    }
    add(childCoordinator: userSearchCoordinator)
    userSearchCoordinator.start()
  }

//  private func runErrorFlow(for error: RankedError) {
  private func runErrorFlow(for error: Error) {
    let errorCoordinator = ErrorCoordinator(router: router, error: error)
    errorCoordinator.finishFlow = { [unowned self, unowned errorCoordinator] in
      self.remove(childCoordinator: errorCoordinator)
    }
    add(childCoordinator: errorCoordinator)
    errorCoordinator.start()
  }
}
