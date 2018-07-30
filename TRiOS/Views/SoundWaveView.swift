import UIKit

// TODO use MetalKit or OpenGL
final class SoundWaveView: UIView {
  static let meteringLevelBarWidth: CGFloat = 2 // TODO fileprivate
  static let meteringLevelBarCornerRadius: CGFloat = 2
  static let meteringLevelBarInterItem: CGFloat = 2

  private var centerY: CGFloat {
    return frame.size.height / 2
  }

  private var maximumBarHeight: CGFloat {
    return frame.size.height / 2
  }

  override var intrinsicContentSize: CGSize {
//    print("someone asked for intrinsicContentSize")
//    print("returning \(currentWidth):\(75)")
    return CGSize(width: currentWidth, height: 75)
  }

  static func requiredWidth(meteringLevelsCount: Int) -> CGFloat {
    let meteringLevelsCountCGFloat = CGFloat(meteringLevelsCount)
    let totalBarWidth = meteringLevelsCountCGFloat * SoundWaveView.meteringLevelBarWidth
    let totalInterWidth = (meteringLevelsCountCGFloat - 1) * SoundWaveView.meteringLevelBarInterItem
    return totalBarWidth + totalInterWidth
  }

  var currentWidth: CGFloat {
    return SoundWaveView.requiredWidth(meteringLevelsCount: meteringLevels.count)
  }

  var meteringLevels: [Float] = [] {
    didSet {
      setNeedsDisplay()
    }
  }

  // TODO draws twice (empty meteringLevels and then non empty)
  override func draw(_ rect: CGRect) {
    if let context = UIGraphicsGetCurrentContext() {
//      print("[SoundWaveView] drawing in \(rect) for \(meteringLevels)\n")
      UIColor.white.set()
      drawBars(inContext: context, meteringLevels: meteringLevels)
    }
  }

  private func drawBars(inContext context: CGContext, meteringLevels: [Float]) {
    guard !meteringLevels.isEmpty else { return }

    for (index, meteringLevel) in meteringLevels.enumerated() {
      context.saveGState()

      let heightForMeteringLevel = height(for: CGFloat(meteringLevel))

      let barPath = UIBezierPath(
        roundedRect: CGRect(
          x: xPoint(for: index),
          y: centerY - heightForMeteringLevel,
          width: SoundWaveView.meteringLevelBarWidth,
          height: heightForMeteringLevel
        ),
        cornerRadius: SoundWaveView.meteringLevelBarCornerRadius
      )

      barPath.fill()
      context.restoreGState()
    }
  }

  private func xPoint(for index: Int) -> CGFloat {
    return CGFloat(index) * (SoundWaveView.meteringLevelBarWidth + SoundWaveView.meteringLevelBarInterItem)
  }

  private func height(for meteringLevel: CGFloat) -> CGFloat {
    return CGFloat(meteringLevel) * maximumBarHeight
  }
}
