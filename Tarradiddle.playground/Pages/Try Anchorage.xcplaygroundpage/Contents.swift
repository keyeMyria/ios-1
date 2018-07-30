import PlaygroundSupport
import UIKit

// https://github.com/Raizlabs/Anchorage
import Anchorage

let background: UIView = {
  let view = UIView(frame: .init(x: 0, y: 0, width: 300, height: 300))
  view.backgroundColor = .red
  return view
}()

let rect: UIView = {
  let view = UIView()
  view.backgroundColor = .darkGray
  return view
}()

background.addSubview(rect)
let rectInsets = UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 170)
rect.edgeAnchors == background.edgeAnchors + rectInsets

let circle: UIView = {
  let view = UIView()
  view.backgroundColor = .white
  view.layer.cornerRadius = 75
  view.mask?.clipsToBounds = true
  return view
}()

background.addSubview(circle)
circle.centerAnchors == background.centerAnchors
circle.heightAnchor == background.heightAnchor / 2
circle.widthAnchor == background.widthAnchor / 2

let text: UILabel = {
  let label = UILabel()
  label.text = "Anchorage"
  return label
}()

circle.addSubview(text)
text.centerAnchors == circle.centerAnchors

PlaygroundPage.current.liveView = background
