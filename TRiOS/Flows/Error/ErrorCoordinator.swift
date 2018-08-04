final class ErrorCoordinator: Coordinating {
  private let router: RouterType
  private let error: Error

  // (UserDecision) -> Void
  var finishFlow: (() -> Void)?

  var childCoordinators: [Coordinating] = []

  init(router: RouterType, error: Error) {
    self.router = router
    self.error = error
  }

  convenience init(router: Router, error: AnyError) {
    self.init(router: router, error: error.error)
  }

  func start() {
    showModal(for: error)
  }

//  enum ErrorPresentation {
//    case appDatabase
//    case appFS
//    case audioSession
//    case audioRecorder
//    case audioPlayer
//    case account
//    case network
//  }

  private func showModal(for error: Error) {
//    switch error {
//    case is AppDatabaseError: ()
//    case is AppFSError: ()
//      case is
//    }
//    if let rankedError = error as? RankedError {
//      switch  {
//      }
//    } else {
//      // show generic modal
//    }
  }

  private func showPopup(for error: Error) {

  }
}
