import UIKit
import Anchorage

final class ConversationCell: UICollectionViewCell {
  var viewModel: VoiceMessagesViewModelType! // TODO actually, maybe just pass actions to it
  var conversation: Conversation!
  let imageView = UIImageView()
  let nameLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    nameLabel.textColor = .white
    backgroundColor = .darkGray // TODO choose color based on the username / user id hash
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

    let longPress = UILongPressGestureRecognizer()
    addGestureRecognizer(longPress)

    longPress.rx.event
      .filter { _ in
        // TODO what if longpress is not on the currently selected cell
        // move or move and start recording?
//        return conversation.id == viewModel.currentConversation.value.id
        return true
      }
      .map { $0.state }
      .subscribe(onNext: { state in
        switch state {
        case .began:
          // TODO longpress on a cell -> start recording
          // start recording
          return
        case .ended:
          // TODO longpress ended -> finish recording, start sending (service detail)
          // finish recording
          return
        case .cancelled:
          // TODO longpress cancel -> cancel recording
          // cancel recording
          return
        default:
          return
        }
      })
//      .bind(to: viewModel.)
      .disposed(by: bag) // TODO use some dispose tricks from the book
  }

  func configure(with conversation: Conversation) {
    self.conversation = conversation
    nameLabel.text = "\(conversation.converseeID)"
//    imageView.image = UIImage(imageLiteralResourceName: "idiot.jpg")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
