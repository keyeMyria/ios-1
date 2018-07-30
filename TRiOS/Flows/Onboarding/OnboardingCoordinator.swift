protocol OnboardingCoordinatorResult: class {
  var finishFlow: (() -> Void)? { get set }
}

final class OnboardingCoordinator: Coordinating, OnboardingCoordinatorResult {
  var finishFlow: (() -> Void)?
  var childCoordinators: [Coordinating] = []

  private let router: RouterType

  init(router: RouterType) {
    self.router = router
  }

  func start() {
    showOnboarding()
  }

  private func showOnboarding() {
    let onboardingViewController = OnboardingViewController(onFinish: { [weak self] in
      self?.finishFlow?()
    })
    router.setRoot(to: onboardingViewController, hideBar: true)
  }
}
