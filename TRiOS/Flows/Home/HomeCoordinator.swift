import class GRDB.DatabaseQueue

final class HomeCoordinator: Coordinating {
  private let router: RouterType
  private let dbQueue: DatabaseQueue
  var childCoordinators: [Coordinating] = []

  init(router: RouterType, dbQueue: DatabaseQueue) {
    self.router = router
    self.dbQueue = dbQueue
  }

  func start() {
    showMessaging()
  }

  private func showMessaging() {
    let messagingViewController = MessagingViewController(
      onSettingsTapped: { [unowned self] in self.runSettingsFlow() },
      onUserSearchTapped: { [unowned self] in self.runUserSearchFlow() }
    )
    router.setRoot(to: messagingViewController, hideBar: true)
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
