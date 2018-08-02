final class UserSearchCoordinator: Coordinating {
  private let router: RouterType
  private let localUserService: LocalUserServiceType
  private let remoteUserService: RemoteUserServiceType

  var childCoordinators: [Coordinating] = []
  var finishFlow: (() -> Void)?

  init(router: RouterType,
       localUserService: LocalUserServiceType,
       remoteUserService: RemoteUserServiceType) {
    self.router = router
    self.localUserService = localUserService
    self.remoteUserService = remoteUserService
  }

  func start() {
    showUserSearch()
  }

  private func showUserSearch() {
    let vc = UserSearchViewController(
      localUserService: localUserService,
      remoteUserService: remoteUserService,
      onAction: { [unowned self] action in
        switch action {
        case .dismiss:
          self.router.popModule()
          self.finishFlow?()
        case let .selected(user):
          self.runUserInfoFlow(for: user)
        }
      }
    )
    router.push(vc)
  }

  private func runUserInfoFlow(for user: User) {
    let coordinator = UserInfoCoordinator(router: router, user: user)
    coordinator.onFinish = { [unowned self] in self.remove(childCoordinator: coordinator) }
    add(childCoordinator: coordinator)
    coordinator.start()
  }
}
