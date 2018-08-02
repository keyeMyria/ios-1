import UIKit

// TODO highlight the current cell (+ animation on selection change)
// TODO highlight the cells which have new messages? (or add a red small circle at the top-right corner)

final class ConversationsViewController: UICollectionViewController {
//  var viewModel: ConversationsViewModelType!
  private let reuseIdentifier = "ConversationCell"
  private let onConversationSelect: (Conversation) -> Void
  private let onConversationRecording: (LongpressState) -> Void
  private let onAddConversationSelect: () -> Void
  // TODO datasource?
  private var conversations: [Conversation]

  enum LongpressState {
    case started(conversation: Conversation)
    case ended
    case cancelled
  }

  enum InnerLongpressState {
    case idle
    case pressing(conversationID: Int64)
  }

  private var longpressState: InnerLongpressState = .idle

  init(conversations: [Conversation],
       onConversationSelect: @escaping (Conversation) -> Void,
       onAddConversationSelect: @escaping () -> Void,
       onConversationRecording: @escaping (LongpressState) -> Void) {
    self.conversations = conversations
    self.onConversationSelect = onConversationSelect
    self.onAddConversationSelect = onAddConversationSelect
    self.onConversationRecording = onConversationRecording
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    super.init(collectionViewLayout: layout)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ConversationsViewController {
  @objc private func handleLongGesture(_ sender: UIGestureRecognizer) {
    let pressedPoint = sender.location(in: collectionView)
    switch sender.state {
    case .began:
      if let pressedCellPath = collectionView?.indexPathForItem(at: pressedPoint) {
        if inCenter(point: pressedPoint) {
          let selectedConversation = conversations[pressedCellPath.row]
          longpressState = .pressing(conversationID: selectedConversation.id)
          onConversationRecording(.started(conversation: selectedConversation))
        }
      }
    case .ended:
      guard case let .pressing(conversationID: conversationID) = longpressState else {
          longpressState = .idle
          return
      }

      guard let pressedCellPath = collectionView?.indexPathForItem(at: pressedPoint) else {
        longpressState = .idle
        onConversationRecording(.cancelled)
        return
      }

      let selectedConversation = conversations[pressedCellPath.row]

      guard selectedConversation.id == conversationID else {
        longpressState = .idle
        onConversationRecording(.cancelled)
        return
      }

      longpressState = .idle
      onConversationRecording(.ended)
    default: ()
    }
  }

  private func inCenter(point: CGPoint) -> Bool {
    let center = view.convert(view.center, to: collectionView)
    return abs(center.x - point.x) <= CGFloat(75) / 2
  }
}

extension ConversationsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let longGesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(handleLongGesture))
    collectionView?.addGestureRecognizer(longGesture)
    collectionView?.backgroundColor = .clear // TODO remove
    collectionView?.showsHorizontalScrollIndicator = false // TODO or show it?
    collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    collectionView?.register(ConversationCell.self,
                             forCellWithReuseIdentifier: reuseIdentifier)
  }
}

// TODO refactor "+" cell
extension ConversationsViewController {
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return conversations.count + 1
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // swiftlint:disable force_cast
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! ConversationCell
    if indexPath.row == conversations.count {
      cell.configure(for: .new)
    } else {
      cell.configure(with: conversations[indexPath.row])
    }
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    // TODO don't let to scroll to "+" cell?
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    if indexPath.row < conversations.count {
      onConversationSelect(conversations[indexPath.row])
    } else if indexPath.row == conversations.count {
      onAddConversationSelect()
    }
  }
}

extension ConversationsViewController {
  // adapted from https://gist.github.com/benjaminsnorris/a19cb14082b28027d183
  // TODO redo
  private func snapToCenter() {
    guard let collectionView = collectionView else { return }
    var centerPoint = view.convert(view.center, to: collectionView)
    centerPoint.y = 50 // TODO
    var indexPath: IndexPath

    if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
      indexPath = centerIndexPath
    } else {
      guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
      let shiftPoint = CGPoint(x: layout.minimumLineSpacing / 2 + 1, y: 0)
      if let leftIndexPath = collectionView.indexPathForItem(at: centerPoint - shiftPoint) {
        indexPath = leftIndexPath
      } else if let rightIndexPath = collectionView.indexPathForItem(at: centerPoint + shiftPoint) {
        indexPath = rightIndexPath
      } else {
        indexPath = IndexPath(row: 0, section: 0) // TODO
      }
    }

    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    if indexPath.row < conversations.count {
      onConversationSelect(conversations[indexPath.row])
    } else if indexPath.row == conversations.count {
      onAddConversationSelect()
    }
  }
}

extension ConversationsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 75, height: 75) // TODO maybe make relative to view.frame.size
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    // TODO find a simpler way to center the first and last cells
    let sideInsetLength = view.frame.width / 2 - 75 / 2
    return UIEdgeInsets(top: 0, left: sideInsetLength, bottom: 0, right: sideInsetLength)
  }
}

// from https://gist.github.com/benjaminsnorris/a19cb14082b28027d183
extension ConversationsViewController {
  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    snapToCenter()
  }

  override func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                         willDecelerate decelerate: Bool) {
    if !decelerate { snapToCenter() }
  }
}
