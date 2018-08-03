import UIKit

final class DetailSettingsCell: UITableViewCell, Reusable {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(for detail: SettingsViewModel.Detail) {
    textLabel?.text = detail.text
    detailTextLabel?.text = detail.detail
    if detail.hasMoreInfo {
      accessoryType = .disclosureIndicator
    } else {
      accessoryType = .none
    }
  }
}
