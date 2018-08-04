import UIKit

final class ErrorModalViewController: UIViewController {
  private let error: Error
  private let onDismiss: (Decision) -> Void

  private let titleLabel = UILabel().then {
    // TODO don't panic
    $0.text = "👋 Something went legit wrong."
  }

  private let errorDescriptionLabel = UILabel().then {
    // TODO put error.localizedDescription .. here, try out in playgrounds
    // with errors from database, audio session, authentication
    $0.text = "The error is, as reported by the system: "
  }

  private let directionsLabel = UILabel().then {
    $0.text = "You can report this error over email (just shake the phone or push that red report button) or just ignore"
    // TODO "the app won't work without it, though"
  }

  // TODO allowToProceeed? severity?
  init(error: Error, onDismiss: @escaping (Decision) -> Void) {
    self.error = error
    self.onDismiss = onDismiss
    super.init(nibName: nil, bundle: nil)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ErrorModalViewController {
  enum Decision {
    case report
    case complain
    case ignore
  }
}
