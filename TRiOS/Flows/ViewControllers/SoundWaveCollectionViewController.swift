import UIKit
import RxSwift
import RxCocoa

final class SoundWaveCollectionViewController: UIViewController {
//  var viewModel: SoundWavesViewModelType!
  var viewModel: VoiceMessagesViewModelType!
  private let reuseIdentifier = "SoundWaveCell"
  private let bag = DisposeBag()

  lazy var collectionView: UICollectionView = { [unowned self] in
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 2 // TODO
    layout.minimumInteritemSpacing = 2
    layout.estimatedItemSize = CGSize(width: 10, height: 75)
//    layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
    let collectionView = UICollectionView(
      frame: self.view.frame,
      collectionViewLayout: layout
    )
    return collectionView
  }()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView.frame = view.frame // TODO need it?
//    collectionView.collectionViewLayout.invalidateLayout()
  }

  // TODO a bar which separates sent and recorded messages

  var currentWidths: [Int: CGFloat] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()

//    UICollectionViewFlowLayoutAutomaticSize

    collectionView.register(
      VoiceMessageCell.self,
      forCellWithReuseIdentifier: reuseIdentifier
    )
    view.addSubview(collectionView)

    collectionView.rx
      .setDelegate(self)
      .disposed(by: bag)

    viewModel.voiceMessages
      .bind(to: collectionView.rx.items(
        cellIdentifier: reuseIdentifier,
        cellType: VoiceMessageCell.self
      )) { row, voiceMessage, cell in
//        print("[currentWidths] setting \(row) to \(SoundWaveView.requiredWidth(meteringLevelsCount: voiceMessage.meterLevelsUnscaled.count))")
//        self.currentWidths[row] = SoundWaveView.requiredWidth(meteringLevelsCount: voiceMessage.meterLevelsUnscaled.count)
        cell.configure(with: voiceMessage)
      }
      .disposed(by: bag)

    collectionView.rx
      .modelSelected(VoiceMessage.self)
      .bind(to: viewModel.currentVoiceMessage)
      .disposed(by: bag)
  }
}

extension SoundWaveCollectionViewController: UICollectionViewDelegateFlowLayout {
//  func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    sizeForItemAt indexPath: IndexPath
//  ) -> CGSize {
//    if let width = currentWidths[indexPath.row] {
////      print("[sizeForItemAt] setting to \(indexPath.row) to \(width)")
//      // why no redraw?
//      return CGSize(width: width, height: 75) // TODO
//    } else {
////      print("[sizeForItemAt] can't find width for \(indexPath.row) in \(currentWidths)")
//      return CGSize(width: 75, height: 75)
//    }
//  }
}
