protocol UserInfoCoordinatorResult {
  var onFinish: (() -> Void)? { get set }
}

final class UserInfoCoordinator: Coordinating, UserInfoCoordinatorResult {
  private let router: RouterType
  private let user: User

  var childCoordinators: [Coordinating] = []
  var onFinish: (() -> Void)?

  init(router: RouterType, user: User) {
    self.router = router
    self.user = user
  }

  func start() {
    showDetails(for: user)
  }

  private func showDetails(for user: User) {
    let vc = UserInfoViewController(user: user, onDismiss: { [unowned self] in
      self.router.popModule()
      self.onFinish?()
    })
    router.push(vc)
  }
}
