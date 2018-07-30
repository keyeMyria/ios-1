import UIKit
import Anchorage

final class VoiceMessageCell: UICollectionViewCell {
  let soundWaveView = SoundWaveView()
  private var meteringLevelsCount: Int = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
    clipsToBounds = true
    addSubview(soundWaveView)
    let separatorLine = UIView()
    separatorLine.backgroundColor = .yellow
    addSubview(separatorLine)
    separatorLine.topAnchor == contentView.topAnchor
    separatorLine.bottomAnchor == contentView.bottomAnchor
    separatorLine.widthAnchor == 2
    separatorLine.trailingAnchor == contentView.trailingAnchor
//    backgroundColor = .blue // TODO
    soundWaveView.edgeAnchors == contentView.edgeAnchors
//    soundWaveView.backgroundColor = .red
  }

  func configure(with voiceMessage: VoiceMessage) {
    meteringLevelsCount = voiceMessage.meterLevelsUnscaled.count
//    print("[VoiceMessageCell.configure] meteringLevelsCount: \(meteringLevelsCount)")
    soundWaveView.meteringLevels = voiceMessage.meterLevelsScaled
//    sizeThatFits(.init(width: 0, height: 75))
  }

  override func preferredLayoutAttributesFitting(
    _ layoutAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutAttributes {
//    print("[preferredLayoutAttributesFitting] \(layoutAttributes)")
    let returned = super.preferredLayoutAttributesFitting(layoutAttributes)
//    print("[preferredLayoutAttributesFitting] meteringLevelsCount \(meteringLevelsCount)")
    returned.size.width = SoundWaveView.requiredWidth(meteringLevelsCount: meteringLevelsCount)
//    print("[preferredLayoutAttributesFitting] \(returned)")
    return returned
  }

  // TODO doesn't work (is not even called)
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    if let superview = superview {
      superview.layoutIfNeeded()
    }

    let width = SoundWaveView.requiredWidth(meteringLevelsCount: meteringLevelsCount)
    print("[VoiceMessageCell.sizeThatFits] width \(width), meteringLevelsCount \(meteringLevelsCount)")
    return CGSize(width: width, height: size.height)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
