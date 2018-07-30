final class UserSearchCoordinator: Coordinating {
  private let router: RouterType
  var childCoordinators: [Coordinating] = []
  var finishFlow: (() -> Void)?

  init(router: RouterType) {
    self.router = router
  }

  func start() {
    showUserSearch()
  }

  private func showUserSearch() {
    // TODO
  }
}
