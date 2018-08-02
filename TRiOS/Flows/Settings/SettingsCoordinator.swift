final class SettingsCoordinator: Coordinating {
  private let router: RouterType
  var childCoordinators: [Coordinating] = []
  var finishFlow: (() -> Void)?

  init(router: RouterType) {
    self.router = router
  }

  func start() {
    showSettings()
  }

  private func showSettings() {
    let vc = SettingsViewController(account: FakeAccount(), onDismiss: { [unowned self] in
      self.router.dismissModule()
      self.finishFlow?()
    })
    router.present(vc)
  }
}
