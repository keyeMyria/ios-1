import PlaygroundSupport
import UIKit

@testable import TRAppProxy
import Anchorage

// setup

//extension UInt8 {
//  static func randomArray(maxLength: UInt32 = 50) -> [UInt8] {
//    return (0...arc4random_uniform(maxLength)).map { _ in
//      return UInt8(arc4random_uniform(UInt32(UInt8.max)))
//    }
//  }
//}

//UInt8.randomArray()

//class FakeVoiceMessagesViewModel: VoiceMessagesViewModelType {
//  let bag = DisposeBag()
//
//  var voiceMessages: Observable<[VoiceMessage]> {
//    return Observable.just((1...50).map {
//      VoiceMessage(
//        id: $0,
//        remoteID: $0,
//        audioFileRemoteURL: nil,
//        audioFileLocalPath: "",
//        authorID: $0,
//        conversationID: $0,
//        meterLevelsUnscaled: UInt8.randomArray()
//      )
//    })
//  }
//
//  let currentVoiceMessage = Variable<VoiceMessage?>(nil)
//
//  init() {
//    currentVoiceMessage.asObservable()
//      .subscribe(onNext: { voiceMessage in
//        if let voiceMessage = voiceMessage {
//          print("selected voiceMessage \(voiceMessage.id!)")
//        }
//      })
//      .disposed(by: bag)
//  }
//}

//let voiceMessages = (1...50).map {
//  VoiceMessage(id: $0, authorID: $0, conversationID: $0, insertedAt: nil)
////  VoiceMessage(
////    id: $0,
////    remoteID: $0,
////    audioFileRemoteURL: nil,
////    audioFileLocalPath: "",
////    authorID: $0,
////    conversationID: $0,
////    meterLevelsUnscaled: UInt8.randomArray()
////  )
//}
//let vc = SoundWavesViewController(voiceMessages: voiceMessages) { voiceMessage in
//  print("selected voiceMessage \(voiceMessage.id)")
//}

//let containerSize = CGSize(width: 375, height: 100)
//vc.view.frame.size = containerSize
//vc.preferredContentSize = containerSize
//
//let timeline = UIView()
//timeline.backgroundColor = .white
//vc.view.addSubview(timeline)
//timeline.trailingAnchor == vc.view.trailingAnchor
//timeline.leadingAnchor == vc.view.leadingAnchor
//timeline.centerYAnchor == vc.view.centerYAnchor
//timeline.heightAnchor == 1

let items = Array(1...20)
let reuseIdentifier = "Cell"

final class Cell: UICollectionViewCell {
  private let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(label)
    label.centerAnchors == contentView.centerAnchors
  }

  func configure(with item: Int) {
    contentView.backgroundColor = UIColor(red: CGFloat(item) * 10 / 255,
                                          green: CGFloat(item) * 10 / 255,
                                          blue: CGFloat(item) * 10 / 255,
                                          alpha: 1)
    label.text = "\(item)"
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class CollectionViewController: UICollectionViewController {
  private let items: [Int]
  init(items: [Int]) {
    self.items = items
    let layout = CollectionViewHorizontalInversedLayout()
//    let layout = UICollectionViewFlowLayout()
//    layout.minimumLineSpacing = 0
//    layout.scrollDirection = .horizontal
    super.init(collectionViewLayout: layout)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CollectionViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.register(Cell.self,
                             forCellWithReuseIdentifier: reuseIdentifier)
  }
}

extension CollectionViewController {
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! Cell
    cell.configure(with: items[indexPath.row])
    return cell
  }
}

//extension CollectionViewController: UICollectionViewDelegateFlowLayout {
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return collectionView.frame.size
//  }
//}

PlaygroundPage.current.liveView = CollectionViewController(items: items)
