import PlaygroundSupport
import UIKit

@testable import TRAppProxy

//class FakeSoundWaveView: UIView {
//  let meteringLevelBarWidth: CGFloat = 3.0
//  let meteringLevelBarCornerRadius: CGFloat = 2.0
//  let meteringLevelBarInterItem: CGFloat = 2.0
//
//  private var centerY: CGFloat {
//    return frame.size.height / 2.0
//  }
//
//  private var maximumBarHeight: CGFloat {
//    return frame.size.height / 2.0
//  }
//
//  let meteringLevels = (1...41)
//    .map { Float($0) / 10 }
//    .map(sin)
//    .map(abs)
//
//  override func draw(_ rect: CGRect) {
//    if let context = UIGraphicsGetCurrentContext() {
//      UIColor.white.set()
//      drawBars(inContext: context, meteringLevels: meteringLevels)
//    }
//  }
//
//  private func drawBars(inContext context: CGContext, meteringLevels: [Float]) {
//    guard !meteringLevels.isEmpty else { return }
//
//    for (index, meteringLevel) in meteringLevels.enumerated() {
//      context.saveGState()
//
//      let heightForMeteringLevel = height(for: CGFloat(meteringLevel))
//
//      let barPath = UIBezierPath(
//        roundedRect: CGRect(
//          x: xPoint(for: index),
//          y: centerY - heightForMeteringLevel,
//          width: meteringLevelBarWidth,
//          height: heightForMeteringLevel
//        ),
//        cornerRadius: meteringLevelBarCornerRadius
//      )
//
//      barPath.fill()
//      context.restoreGState()
//    }
//  }
//
//  private func xPoint(for index: Int) -> CGFloat {
//    return CGFloat(index) * (meteringLevelBarWidth + meteringLevelBarInterItem)
//  }
//
//  private func height(for meteringLevel: CGFloat) -> CGFloat {
//    return CGFloat(meteringLevel) * maximumBarHeight
//  }
// }

let meteringLevels: [Float] = (1...100)
  .map { Float($0) / 25 }
  .map(sin)
  .map(abs)

let requiredWidth = SoundWaveView.requiredWidth(meteringLevelsCount: 100)
let frame = CGRect(x: 0, y: 0, width: requiredWidth, height: 300)

// FakeSoundWaveView(frame: frame)
let soundWave = SoundWaveView(frame: frame)
soundWave.meteringLevels = meteringLevels
//soundWave.currentWidth

PlaygroundPage.current.liveView = soundWave
