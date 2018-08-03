import UIKit

struct SettingsDetail {
  let text: String
  let moreInfo: Bool
  let detail: String?
}

final class DetailSettingsCell: UITableViewCell, Reusable {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    accessoryType = .none
  }

  func configure(for detail: SettingsDetail) {
    textLabel?.text = detail.text
    detailTextLabel?.text = detail.detail
    if detail.moreInfo {
      accessoryType = .disclosureIndicator
    }
  }
}
