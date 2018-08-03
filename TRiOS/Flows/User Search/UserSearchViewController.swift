import UIKit
import Anchorage

final class UserSearchViewController: UIViewController {
  private let localUserService: LocalUserServiceType
  private let remoteUserService: RemoteUserServiceType
  private let onAction: (Action) -> Void
  private var foundUsers: [User] = [] {
    didSet { usersViewController.users = foundUsers }
  }

  init(localUserService: LocalUserServiceType,
       remoteUserService: RemoteUserServiceType,
       onAction: @escaping (Action) -> Void) {
    self.localUserService = localUserService
    self.remoteUserService = remoteUserService
    self.onAction = onAction
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

  private let searchBar = UISearchBar().then {
    $0.autocapitalizationType = .none
  }

  // MARK: - Children

  private lazy var usersViewController = UsersViewController(users: [], onUserSelected: { [unowned self] user in
    self.onAction(.selected(user))
  })
}

// MARK: -
extension UserSearchViewController {
  @objc private func handleDismiss() {
    onAction(.dismiss)
  }
}

extension UserSearchViewController {
  enum Action {
    case selected(User)
    case dismiss
  }
}

extension UserSearchViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self

    addChildViewController(usersViewController)
    view.addSubview(usersViewController.view)
    usersViewController.view.topAnchor == view.topAnchor
    // TODO etc
    usersViewController.didMove(toParentViewController: self)

    view.addSubview(dismissButton)
    // TODO layout
  }
}

extension UserSearchViewController: UISearchBarDelegate {
  
}
