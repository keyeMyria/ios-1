//
//  AudioVisualizationView.swift
//  Pods
//
//  Created by Bastien Falcou on 12/6/16.
//

// TODO use metal or opengl instead

import UIKit

//final class AudioVisualizationView: UIView {
//  enum AudioVisualizationMode {
//    case read
//    case write
//  }
//
//  var meteringLevelBarWidth: CGFloat = 3.0 {
//    didSet {
//      setNeedsDisplay()
//    }
//  }
//
//  var meteringLevelBarInterItem: CGFloat = 2.0 {
//    didSet {
//      setNeedsDisplay()
//    }
//  }
//
//  var meteringLevelBarCornerRadius: CGFloat = 2.0 {
//    didSet {
//      setNeedsDisplay()
//    }
//  }
//
//  var audioVisualizationMode: AudioVisualizationMode = .read
//  var audioVisualizationTimeInterval: TimeInterval = 0.05 // Time interval between each metering bar representation
//
//  private var meteringLevelsArray: [Float] = []  // Mutating recording array (values are percentage: 0.0 to 1.0)
//  // Generated read mode array (values are percentage: 0.0 to 1.0)
//  private var meteringLevelsClusteredArray: [Float] = []
//
//  private var currentMeteringLevelsArray: [Float] {
//    if !meteringLevelsClusteredArray.isEmpty {
//      return meteringLevelsClusteredArray
//    }
//    return meteringLevelsArray
//  }
//
//  var meteringLevels: [Float]? {
//    didSet {
//      print("drawing")
//      if let meteringLevels = meteringLevels {
//        meteringLevelsClusteredArray = meteringLevels
//        _ = scaleSoundDataToFitScreen()
//      }
//      setNeedsDisplay()
//    }
//  }
//
//  override func draw(_ rect: CGRect) {
//    super.draw(rect)
//
//    if let context = UIGraphicsGetCurrentContext() {
//      print("drawing from draw: \(meteringLevelsClusteredArray)")
//      drawLevelBarsMask(inContext: context)
//    }
//  }
//
//  func reset() {
//    meteringLevels = nil
//    meteringLevelsClusteredArray.removeAll()
//    meteringLevelsArray.removeAll()
//    setNeedsDisplay()
//  }
//
//  // MARK: - Record Mode Handling
//
//  func addMeteringLevel(_ meteringLevel: Float) {
//    guard audioVisualizationMode == .write else {
//      fatalError("trying to populate audio visualization view in read mode")
//    }
//
//    meteringLevelsArray.append(meteringLevel)
//    setNeedsDisplay()
//  }
//
//  func scaleSoundDataToFitScreen() -> [Float] {
//    if meteringLevelsArray.isEmpty {
//      return []
//    }
//
//    meteringLevelsClusteredArray.removeAll()
//    var lastPosition: Int = 0
//
//    for index in 0..<maximumNumberBars {
//      let position: Float = Float(index) / Float(self.maximumNumberBars) * Float(self.meteringLevelsArray.count)
//      var hhahaha: Float = 0.0
//
//      if maximumNumberBars > meteringLevelsArray.count && floor(position) != position {
//        let low: Int = Int(floor(position))
//        let high: Int = Int(ceil(position))
//
//        if high < meteringLevelsArray.count {
//          hhahaha = meteringLevelsArray[low] + ((position - Float(low)) * (meteringLevelsArray[high] - meteringLevelsArray[low]))
//        } else {
//          hhahaha = meteringLevelsArray[low]
//        }
//      } else {
//        for nestedIndex in lastPosition...Int(position) {
//          hhahaha += meteringLevelsArray[nestedIndex]
//        }
//        let stepsNumber = Int(1 + position - Float(lastPosition))
//        hhahaha /= Float(stepsNumber)
//      }
//
//      lastPosition = Int(position)
//      meteringLevelsClusteredArray.append(hhahaha)
//    }
//
//    setNeedsDisplay()
//    return meteringLevelsClusteredArray
//  }
//
//  // MARK: - Mask + Gradient
//
//  func drawLevelBarsMask(inContext context: CGContext) {
//    if currentMeteringLevelsArray.isEmpty {
//      return
//    }
//
//    context.saveGState()
//
//    UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
//
//    let maskContext = UIGraphicsGetCurrentContext()
//    UIColor.red.set()
//
//    drawMeteringLevelBars(inContext: maskContext!)
//
//    let mask = UIGraphicsGetCurrentContext()?.makeImage()
//    UIGraphicsEndImageContext()
//
//    context.clip(to: bounds, mask: mask!)
//
//    context.restoreGState()
//  }
//
//  // MARK: - Bars
//
//  private func drawMeteringLevelBars(inContext context: CGContext) {
//    let offset = max(currentMeteringLevelsArray.count - maximumNumberBars, 0)
//
//    for index in offset..<currentMeteringLevelsArray.count {
//      drawBar(index - offset, meteringLevelIndex: index, context: context)
//    }
//  }
//
//  private func drawBar(_ barIndex: Int, meteringLevelIndex: Int, context: CGContext) {
//    context.saveGState()
//
//    var barPath: UIBezierPath!
//
//    let xPointForMeteringLevel = self.xPointForMeteringLevel(barIndex)
//    let heightForMeteringLevel = self.heightForMeteringLevel(currentMeteringLevelsArray[meteringLevelIndex])
//
//    barPath = UIBezierPath(
//      roundedRect: CGRect(
//        x: xPointForMeteringLevel,
//        y: centerY - heightForMeteringLevel,
//        width: meteringLevelBarWidth,
//        height: heightForMeteringLevel
//      ),
//      cornerRadius: meteringLevelBarCornerRadius
//    )
//
//    UIColor.white.set()
//    barPath.fill()
//
//    context.restoreGState()
//  }
//
//  // MARK: - Points Helpers
//
//  private var centerY: CGFloat {
//    return frame.size.height / 2.0
//  }
//
//  private var maximumBarHeight: CGFloat {
//    return frame.size.height / 2.0
//  }
//
//  private var maximumNumberBars: Int {
//    return Int(frame.size.width / (meteringLevelBarWidth + meteringLevelBarInterItem))
//  }
//
//  private func xLeftMostBar() -> CGFloat {
//    return xPointForMeteringLevel(min(maximumNumberBars - 1, currentMeteringLevelsArray.count - 1))
//  }
//
//  private func heightForMeteringLevel(_ meteringLevel: Float) -> CGFloat {
//    return CGFloat(meteringLevel) * maximumBarHeight
//  }
//
//  private func xPointForMeteringLevel(_ atIndex: Int) -> CGFloat {
//    return CGFloat(atIndex) * (meteringLevelBarWidth + meteringLevelBarInterItem)
//  }
//}
