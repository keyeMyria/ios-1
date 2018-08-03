import UIKit

final class UsersViewController: UITableViewController {
//  private var viewModel: UserSearchViewModel!
  private let onUserSelected: (User) -> Void
  var users: [User] {
    didSet {
      if users != oldValue {
        // TODO diff?
        tableView.reloadData()
      }
    }
  }

  init(users: [User], onUserSelected: @escaping (User) -> Void) {
    self.users = users
    self.onUserSelected = onUserSelected
    super.init(style: .plain)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UsersViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(cellType: UserListCell.self)
  }
}

extension UsersViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    onUserSelected(users[indexPath.row])
    // TODO deselect?
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UserListCell = tableView.dequeueReusableCell(for: indexPath)
    cell.configure(with: users[indexPath.row])
    return cell
  }
}
