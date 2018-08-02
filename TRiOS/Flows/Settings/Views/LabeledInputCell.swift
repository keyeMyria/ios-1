import UIKit
import Anchorage

final class LabeledInputCell: UITableViewCell, Reusable {
  private let textField = UITextField()
  private let label = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    textField.delegate = self // TODO

//    contentView.addSubview(label)
//    contentView.addSubview(textField)
    let stackView = UIStackView()
    contentView.addSubview(stackView)
    stackView.edgeAnchors == contentView.layoutMarginsGuide.edgeAnchors

    stackView.addArrangedSubview(label)
    stackView.addArrangedSubview(textField)
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally

    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
//    label.leadingAnchor == contentView.layoutMarginsGuide.leadingAnchor
//    label.centerYAnchor == contentView.centerYAnchor
    label.backgroundColor = .red

    textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//    textField.leadingAnchor == label.trailingAnchor
//    textField.trailingAnchor == contentView.layoutMarginsGuide.trailingAnchor
//    textField.centerYAnchor == contentView.centerYAnchor
    textField.backgroundColor = .yellow
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(for input: SettingsInput) {
    label.text = input.title
    textField.text = "idiot"
  }
}

extension LabeledInputCell: UITextFieldDelegate {
}
