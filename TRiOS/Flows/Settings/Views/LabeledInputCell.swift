import UIKit
import Anchorage

final class LabeledInputCell: UITableViewCell, Reusable {
  private let textField = UITextField().then {
    $0.placeholder = "Your Handle"
  }
  private let label = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    textField.delegate = self // TODO

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

  func configure(for input: Settings.Input) {
    label.text = input.title
    textField.text = input.value
  }
}

extension LabeledInputCell: UITextFieldDelegate {
}
