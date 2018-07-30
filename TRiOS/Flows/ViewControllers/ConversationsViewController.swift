import UIKit

// TODO highlight the current cell (+ animation on selection change)
// TODO highlight the cells which have new messages? (or add a red small circle at the top-right corner)

final class ConversationsViewController: UICollectionViewController {
//  var viewModel: ConversationsViewModelType!
  private let reuseIdentifier = "ConversationCell"
  private let onConversationSelect: (Conversation) -> Void
  // TODO datasource?
  private var conversations: [Conversation]

  init(conversations: [Conversation], onConversationSelect: @escaping (Conversation) -> Void) {
    self.conversations = conversations
    self.onConversationSelect = onConversationSelect
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
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = .gray // TODO remove
    collectionView?.showsHorizontalScrollIndicator = false // TODO or show it?
    collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    collectionView?.register(ConversationCell.self,
                             forCellWithReuseIdentifier: reuseIdentifier)
  }
}

extension ConversationsViewController {
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return conversations.count
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // swiftlint:disable force_cast
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! ConversationCell
    cell.configure(with: conversations[indexPath.row])
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    onConversationSelect(conversations[indexPath.row])
  }
}

extension ConversationsViewController {
  // adapted from https://gist.github.com/benjaminsnorris/a19cb14082b28027d183
  // TODO redo
  private func snapToCenter() {
    var centerPoint = view.convert(view.center, to: collectionView)
    centerPoint.y = 50 // TODO
    var indexPath: IndexPath

    if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
      indexPath = centerIndexPath
    } else {
      let shiftPoint = CGPoint(x: collectionViewLayout.minimumLineSpacing / 2 + 1, y: 0)
      if let leftIndexPath = collectionView.indexPathForItem(at: centerPoint - shiftPoint) {
        indexPath = leftIndexPath
      } else if let rightIndexPath = collectionView.indexPathForItem(at: centerPoint + shiftPoint) {
        indexPath = rightIndexPath
      } else {
        indexPath = IndexPath(row: 0, section: 0) // TODO
      }
    }

    collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    onConversationSelect(conversations[indexPath.row])
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
extension ConversationsViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    snapToCenter()
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      snapToCenter()
    }
  }
}
