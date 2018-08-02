import UIKit
import Anchorage

final class UserInfoViewController: UIViewController {
  private let user: User
  private let onDismiss: () -> Void

  // TODO conversations with that user?
  init(user: User, onDismiss: @escaping () -> Void) {
    self.user = user
    self.onDismiss = onDismiss
    super.init(nibName: nil, bundle: nil)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UI

  private let dismissButton = UIButton(type: .system).then {
    $0.setTitle("❌", for: .normal)
    $0.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
  }

  private let stackView = UIStackView().then {
    $0.axis = .vertical
  }

  private lazy var profileImageView: UIImageView? = {
    guard let userImageURL = user.imageURL else { return nil }
    // TODO async download
    do {
      let data = try Data(contentsOf: userImageURL)
      let image = UIImage(data: data)
      return UIImageView(image: image)
    } catch {
      return nil
    }
  }()

  private let usernameLabel = UILabel()
}

extension UserInfoViewController {
  @objc private func handleDismiss() {
    onDismiss()
  }
}

extension UserInfoViewController {
  override func loadView() {
    view = UIView()
    view.addSubview(stackView)
    view.addSubview(dismissButton)

    if let profileImageView = profileImageView {
      stackView.addArrangedSubview(profileImageView)
    }

    stackView.addArrangedSubview(usernameLabel)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    dismissButton.leadingAnchor == view.leadingAnchor + 20
    dismissButton.topAnchor == view.topAnchor + 20

    stackView.leadingAnchor == view.leadingAnchor
    stackView.trailingAnchor == view.trailingAnchor
    stackView.bottomAnchor == view.bottomAnchor
    stackView.topAnchor == view.topAnchor + 20
  }
}
