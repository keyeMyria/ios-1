import UIKit
import Anchorage

final class ProfileCell: UITableViewCell, Reusable {
  private let nameLabel = UILabel()

  private let handleLabel = UILabel().then {
    $0.textColor = .gray
    $0.font = .systemFont(ofSize: 14)
  }

  private let avatarView = UIImageView().then {
    $0.layer.masksToBounds = true
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    accessoryType = .disclosureIndicator

    avatarView.layer.cornerRadius = 32 // TODO

    contentView.addSubview(avatarView)
    avatarView.leadingAnchor == contentView.layoutMarginsGuide.leadingAnchor
    avatarView.heightAnchor == 0.8 * contentView.heightAnchor
    avatarView.widthAnchor == avatarView.heightAnchor
    avatarView.centerYAnchor == contentView.centerYAnchor

    let namesStack = UIStackView(arrangedSubviews: [nameLabel, handleLabel])
    namesStack.axis = .vertical
    namesStack.distribution = .fillEqually

    contentView.addSubview(namesStack)
    namesStack.leadingAnchor == avatarView.trailingAnchor + 8
    namesStack.centerYAnchor == contentView.centerYAnchor
    namesStack.trailingAnchor == contentView.trailingAnchor
    namesStack.heightAnchor == 0.8 * contentView.heightAnchor
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(for profile: SettingsViewModel.Profile) {
    nameLabel.text = profile.name

    if let handle = profile.handle {
      handleLabel.text = "@" + handle
      handleLabel.isHidden = false
    } else {
      handleLabel.isHidden = true
    }

    if let avatar = profile.avatar {
      avatarView.image = avatar
    } else {
      // TODO flickers when seleted
      avatarView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    }
  }
}
