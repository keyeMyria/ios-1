import UIKit

final class UsersViewController: UITableViewController {
//  private var viewModel: UserSearchViewModel!
  private let reuseIdentifier = "UserCell"
  private let onUserSelected: (User) -> Void
  private var users: [User]

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
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }
}

extension UsersViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    onUserSelected(users[indexPath.row])
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    return cell
  }
}
