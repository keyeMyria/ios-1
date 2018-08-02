import UIKit

final class SwitchCell: UITableViewCell, Reusable {
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

  func configure(isOn: Bool, onToggle: @escaping (Bool) -> Void) {
    textLabel?.text = "Should I kick you?"
    switchControl.isOn = isOn
    self.onToggle = onToggle
  }
}
