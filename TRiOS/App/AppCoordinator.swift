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

final class AppCoordinator: Coordinating {
  var childCoordinators: [Coordinating] = []
  private let router: RouterType
  private let account: AppAccountType

  // TODO pass Services struct?

  init(router: RouterType, account: AppAccountType = AppAccount(from: UserDefaults.standard)) {
    self.router = router
    self.account = account
  }

  func start() {
    if account.hasSeenOnboarding {
      if account.isAuthenticated {
        do {
          let dbQueue = try setupDatabase()
          let audioSession = try AudioSession()
          runMainFlow(dbQueue: dbQueue, audioSession: audioSession)
        } catch {
          runErrorFlow(for: error)
        }
      } else {
        runAuthenticationFlow(for: account)
      }
    } else {
      // TODO and try to authenticate meanwhile
      runOnboardingFlow()
    }
  }

  private func runOnboardingFlow() {
    let coordinator = OnboardingCoordinator(router: router)
    coordinator.finishFlow = { [unowned self, unowned coordinator] in
      self.account.hasSeenOnboarding = true
      self.start()
      self.remove(childCoordinator: coordinator)
    }
    add(childCoordinator: coordinator)
    coordinator.start()
  }

  // TODO authentication is not a flow -- no screen are shown to the user
  // other than maybe a popup with an error
  private func runAuthenticationFlow(for account: AppAccountType) {
    let coordinator = AuthenticationCoordinator(account: account, accountService: AccountService())
    coordinator.finishFlow = { [unowned self, unowned coordinator] result in
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

  private func runErrorFlow(for error: Error) {
//  } catch AppFSError.database(error: _) {
//  // TODO show ErrorCoordinator explaining the error
//  } catch AppDatabaseError.migration(error: _) {
//  // TODO show ErrorCoordinator explaining the error
    let coordinator = ErrorCoordinator(router: router, error: error)
    // onFInish
    add(childCoordinator: coordinator)
    coordinator.start()
  }
}
