import UIKit
import Anchorage

final class OnboardingViewCell: UICollectionViewCell, Reusable {
  var picture = UIView()

  var title = UILabel().then {
    $0.numberOfLines = 0
    $0.font = UIFont.boldSystemFont(ofSize: 30)
    $0.textColor = .white
    $0.textAlignment = .right
  }

  var message = UILabel().then {
    $0.numberOfLines = 0
    $0.textColor = .gray
    $0.textAlignment = .center
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    let pictureGuide = UILayoutGuide()
    contentView.addLayoutGuide(pictureGuide)
    pictureGuide.topAnchor == contentView.topAnchor
    pictureGuide.leadingAnchor == contentView.leadingAnchor
    pictureGuide.trailingAnchor == contentView.trailingAnchor
    pictureGuide.heightAnchor == 0.55 * contentView.heightAnchor

    let messageGuide = UILayoutGuide()
    contentView.addLayoutGuide(messageGuide)
    messageGuide.topAnchor == pictureGuide.bottomAnchor
    messageGuide.leadingAnchor == contentView.leadingAnchor
    messageGuide.trailingAnchor == contentView.trailingAnchor
    messageGuide.bottomAnchor == contentView.bottomAnchor

    contentView.addSubview(picture)
    picture.centerAnchors == pictureGuide.centerAnchors
    picture.widthAnchor == 0.7 * pictureGuide.widthAnchor
    picture.heightAnchor == 0.7 * pictureGuide.heightAnchor

    contentView.addSubview(title)
    contentView.addSubview(message)

    title.topAnchor == messageGuide.topAnchor + 20
    title.centerXAnchor == messageGuide.centerXAnchor
    title.widthAnchor == 0.7 * messageGuide.widthAnchor
    message.topAnchor == title.layoutMarginsGuide.bottomAnchor + 40
    message.centerXAnchor == messageGuide.centerXAnchor
    message.widthAnchor == 0.7 * messageGuide.widthAnchor
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(for page: OnboardingPage) {
    picture.backgroundColor = page.accent
    title.text = page.title
    message.text = page.message
  }
}
