final class ErrorCoordinator: Coordinating {
  private let router: RouterType
  private let error: Error

  var childCoordinators: [Coordinating] = []

  init(router: RouterType, error: Error) {
    self.router = router
    self.error = error
  }

  func start() {
    showErrorModal()
  }

  private func showErrorModal() {
  }
}
