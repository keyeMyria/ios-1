import UIKit
import Anchorage

final class ConversationCell: UICollectionViewCell, Reusable {
  private var conversation: Conversation?
  private let imageView = UIImageView()
  private let nameLabel = UILabel()
//  private let longPress = UILongPressGestureRecognizer()
//  private var state: UIGestureRecognizerState? {
//    didSet {
//      if let state = state, state != oldValue {
//        onStateChange?(state)
//      }
//    }
//  }

//  var isCurrent = false { didSet { longPress.isEnabled = isSelected } }
//  var onStateChange: ((UIGestureRecognizerState) -> Void)?

  enum Kind {
    case new
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    nameLabel.textColor = .white
    backgroundColor = #colorLiteral(red: 0.158314443, green: 0.158314443, blue: 0.158314443, alpha: 1) // TODO choose color based on the username / user id hash
    let minSideLength = min(frame.width, frame.height)
    layer.cornerRadius = minSideLength / 2
    mask?.clipsToBounds = true
    clipsToBounds = true
    addSubview(imageView)
    addSubview(nameLabel)
    imageView.edgeAnchors == contentView.edgeAnchors
    imageView.sizeToFit()
    imageView.contentMode = .scaleAspectFill
    nameLabel.centerAnchors == contentView.centerAnchors

//    addGestureRecognizer(longPress)
//    longPress.isEnabled = false
//    longPress.addTarget(self, action: #selector(handleLongPress))

//    longPress.rx.event
//      .filter { _ in
//        // TODO what if longpress is not on the currently selected cell
//        // move or move and start recording?
////        return conversation.id == viewModel.currentConversation.value.id
//        return true
//      }
//      .map { $0.state }
//      .subscribe(onNext: { state in
//        switch state {
//        case .began:
//          // TODO longpress on a cell -> start recording
//          // start recording
//          return
//        case .ended:
//          // TODO longpress ended -> finish recording, start sending (service detail)
//          // finish recording
//          return
//        case .cancelled:
//          // TODO longpress cancel -> cancel recording
//          // cancel recording
//          return
//        default:
//          return
//        }
//      })
////      .bind(to: viewModel.)
//      .disposed(by: bag) // TODO use some dispose tricks from the book
  }

//  @objc private func handleLongPress(_ sender: UIGestureRecognizer) {
//    state = sender.state
//  }

  func configure(with conversation: Conversation) {
    self.conversation = conversation
    nameLabel.text = "\(conversation.converseeID)"
//    imageView.image = UIImage(imageLiteralResourceName: "idiot.jpg")
  }

  func configure(for kind: Kind) {
    switch kind {
    case .new:
      self.conversation = nil
      nameLabel.text = "+"
    }
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
