import UIKit
import Anchorage

final class TextInputSettingsCell: UITableViewCell, Reusable {
  private let textField = UITextField().then {
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
  }

  private let label = UILabel()
  // TODO don't need return type?
  // TEST
  private var validation: ((String) -> SettingsViewModel.TextInput.ValidationState)? // TEST
  // TODO errorMsgLabel

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    textField.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)

    contentView.addSubview(label)
    contentView.addSubview(textField)

    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    label.leadingAnchor == contentView.layoutMarginsGuide.leadingAnchor
    label.centerYAnchor == contentView.centerYAnchor

    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    textField.leadingAnchor == label.trailingAnchor + 10
    textField.trailingAnchor == contentView.layoutMarginsGuide.trailingAnchor
    textField.centerYAnchor == contentView.centerYAnchor
  }
  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(for input: SettingsViewModel.TextInput) {
    label.text = input.label
    textField.placeholder = input.placeholder
    textField.text = input.initialValue
    self.validation = input.validation
  }

  @objc private func onEditingChanged(_ sender: UITextField) {
    _ = validation?(sender.text ?? "")
  }
}
