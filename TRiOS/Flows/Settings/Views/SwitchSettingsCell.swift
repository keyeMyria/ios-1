import UIKit

final class SwitchSettingsCell: UITableViewCell, Reusable {
  private var onToggle: ((Bool) -> Void)?
  @objc private func didToggleSwitch(_ sender: UISwitch) { onToggle?(sender.isOn) }
  private let switchControl = UISwitch()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    switchControl.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
    accessoryView = switchControl
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(for `switch`: Settings.Switch) {
    textLabel?.text = `switch`.text
    switchControl.isOn = `switch`.initialValue
    self.onToggle = `switch`.onToggle
  }
}
