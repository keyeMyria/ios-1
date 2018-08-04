final class FAQCoordinator: Coordinating {
  var childCoordinators: [Coordinating] = []
  private let router: RouterType

  init(router: RouterType) {
    self.router = router
  }

  func start() {}
}
