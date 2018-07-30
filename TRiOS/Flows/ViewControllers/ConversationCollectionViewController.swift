import UIKit
import RxSwift
import RxCocoa

// TODO remove scroll bar?
// TODO highlight the current cell (+ animation on selection change)
// TODO highlight the cells which have new messages? (or add a red small circle at the top-right corner)

/// Controls the collection view of active conversations on the main screen.
final class ConversationCollectionViewController: UIViewController {
  var viewModel: ConversationsViewModelType!
  private let bag = DisposeBag()
  private let reuseIdentifier = "ConversationCell"

  // TODO can be not lazy?
  private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return layout
  }()

  private lazy var collectionView: UICollectionView = { [unowned self] in
    let collectionView = UICollectionView(
      frame: self.view.frame, // TODO use .zero initially?
      collectionViewLayout: collectionViewLayout
    )
    print("frame in collectionView", self.view.frame)
    collectionView.backgroundColor = .gray // TODO remove
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    return collectionView
  }()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView.frame = view.frame // TODO need it?
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .red // TODO remove

    collectionView.register(
      ConversationCell.self,
      forCellWithReuseIdentifier: reuseIdentifier
    )
    view.addSubview(collectionView)

    collectionView.rx
      .setDelegate(self)
      .disposed(by: bag)

    viewModel.conversations
      .bind(to: collectionView.rx.items(
        cellIdentifier: reuseIdentifier,
        cellType: ConversationCell.self
      )) { _, conversation, cell in
        cell.configure(with: conversation)
      }
      .disposed(by: bag)

    collectionView.rx
      .itemSelected
      .subscribe(onNext: { indexPath in
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      })
      .disposed(by: bag)

    // TODO finish (should notify viewModel whenever the cell at the center changes)
    collectionView.rx
      .modelSelected(Conversation.self)
      .bind(to: viewModel.currentConversation)
      .disposed(by: bag)
  }

  // adapted from https://gist.github.com/benjaminsnorris/a19cb14082b28027d183
  func snapToCenter() {
    // TODO redo

    var centerPoint = view.convert(view.center, to: collectionView)
    centerPoint.y = 50 // TODO
//    print("[centerPoint] \(centerPoint)")
    var indexPath: IndexPath

    if let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) {
      indexPath = centerIndexPath
//      print("[centerIndexPath] \(centerIndexPath)")
    } else {
      let shiftPoint = CGPoint(x: collectionViewLayout.minimumLineSpacing / 2 + 1, y: 0)
      if let leftIndexPath = collectionView.indexPathForItem(at: centerPoint - shiftPoint) {
//        print("[leftIndexPath] \(leftIndexPath)")
        indexPath = leftIndexPath
      } else if let rightIndexPath = collectionView.indexPathForItem(at: centerPoint + shiftPoint) {
        indexPath = rightIndexPath
//        print("[rightIndexPath] \(rightIndexPath)")
      } else {
        indexPath = IndexPath(row: 0, section: 0) // TODO
      }
    }

    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

    // TODO currentIndexPath: Observable<IndexPath>
    // swiftlint:disable force_try
    viewModel.currentConversation.value = try! collectionView.rx.model(at: indexPath) // TODO
  }
}

extension ConversationCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 75, height: 75) // TODO
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    // TODO find a simpler way to center the first and last cells
    let sideInsetLength = view.frame.width / 2 - 75 / 2
    return UIEdgeInsets(top: 0, left: sideInsetLength, bottom: 0, right: sideInsetLength)
  }
}

// from https://gist.github.com/benjaminsnorris/a19cb14082b28027d183
extension ConversationCollectionViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    snapToCenter()
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      snapToCenter()
    }
  }
}
