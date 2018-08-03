import UIKit
import Anchorage

final class UserListCell: UITableViewCell, Reusable {
  private let stack = UIStackView()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with user: User) {

  }
}
