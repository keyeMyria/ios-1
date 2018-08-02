import UIKit
import class GRDB.DatabaseQueue

private func setupDatabase() throws -> DatabaseQueue {
  let databaseURL = try AppFS.mainDatabaseURL()
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

  // TODO pass Services struct?

  init(router: RouterType) {
    self.router = router
  }

  func start() {
    if AppAccount.hasSeenOnboarding {
      if isAuthenticated {
        do {
          let dbQueue = try setupDatabase()
          let audioSession = AudioSession(onDeniedRecordPermission: { print("denied record permission") })
          try audioSession.setup()
          runMainFlow(dbQueue: dbQueue, audioSession: audioSession)
        } catch AppFSError.database(error: _) {
          // TODO show ErrorCoordinator explaining the error
        } catch AppDatabaseError.migration(error: _) {
          // TODO show ErrorCoordinator explaining the error
        } catch {
          // TODO
        }
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
      AppAccount.hasSeenOnboarding = true
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

  private func runMainFlow(dbQueue: DatabaseQueue, audioSession: AudioSessionType) {
    let coordinator = HomeCoordinator(router: router, dbQueue: dbQueue, audioSession: audioSession)
    add(childCoordinator: coordinator)
    coordinator.start()
  }
}
