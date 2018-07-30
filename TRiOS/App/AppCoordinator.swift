import UIKit
import class GRDB.DatabaseQueue

private func setupDatabase() throws -> DatabaseQueue {
  let databaseURL = try FileManager.default
    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    .appendingPathComponent("db.sqlite")

  let dbQueue = try AppDatabase.openDatabase(.onDisk(path: databaseURL.path))

  // Be a nice iOS citizen, and don't consume too much memory
  // See https://github.com/groue/GRDB.swift/#memory-management
  dbQueue.setupMemoryManagement(in: .shared)

  return dbQueue
}

fileprivate var isAuthenticated = false

final class AppCoordinator: Coordinating {
  var childCoordinators: [Coordinating] = []
  private let router: RouterType
  private let dbQueue: DatabaseQueue

  // TODO pass Services struct?

  init(router: RouterType) {
    self.router = router
    // TODO is there a better way?
    // swiftlint:disable:next force_try
    dbQueue = try! setupDatabase()
  }

  func start() {
    if AppAccount.hasSeenOnboarding {
      if isAuthenticated {
        runMainFlow()
      } else {
        runAuthenticationFlow()
      }
    } else {
      // TODO and try to authenticate meanwhile
      runOnboardingFlow()
    }
  }

  // TODO or coordinate(to: )?
  private func runOnboardingFlow() {
    let coordinator = OnboardingCoordinator(router: router)
    coordinator.finishFlow = { [weak self, weak coordinator] in
      guard let `self` = self, let coordinator = coordinator else { return }
      Account.hasSeenOnboarding = true
      self.start()
      self.remove(childCoordinator: coordinator)
    }
    add(childCoordinator: coordinator)
    coordinator.start()
  }

  // TODO authentication is not a flow -- no screen are shown to the user
  // other than maybe a popup with an error
  private func runAuthenticationFlow() {
    let coordinator = AuthenticationCoordinator(accountService: AccountService())
    coordinator.finishFlow = { [weak self, weak coordinator] result in
      guard let `self` = self, let coordinator = coordinator else { return }
      isAuthenticated = true
      self.start()
      self.remove(childCoordinator: coordinator)
    }
    add(childCoordinator: coordinator)
    coordinator.start()
  }

  private func runMainFlow() {
    let coordinator = HomeCoordinator(router: router, dbQueue: dbQueue)
    add(childCoordinator: coordinator)
    coordinator.start()
  }
}
