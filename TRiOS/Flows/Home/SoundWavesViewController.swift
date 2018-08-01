import UIKit

// TODO remember position for each conversation
// TODO more data (long message compressed) -> darker color
// TODO pinch, zoom
final class SoundWavesViewController: UICollectionViewController {
//  var viewModel: SoundWavesViewModelType!
//  var viewModel: VoiceMessagesViewModelType!
  private let reuseIdentifier = "SoundWaveCell"
  private let onVoiceMessageSelected: (VoiceMessage) -> Void
  // TODO a bar which separates sent and recorded messages
  private var currentWidths: [Int: CGFloat] = [:]

  var voiceMessages: [VoiceMessage] = [] {
    didSet {
      guard let collectionView = collectionView, !voiceMessages.isEmpty else { return }
      collectionView.reloadData()
      collectionViewLayout.invalidateLayout()
      let indexPath = IndexPath(item: 0, section: 0)
      collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
  }

  init(onVoiceMessageSelected: @escaping (VoiceMessage) -> Void) {
    self.onVoiceMessageSelected = onVoiceMessageSelected
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 2 // TODO
    layout.minimumInteritemSpacing = 2
    layout.estimatedItemSize = CGSize(width: 10, height: 175)
    //    layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
    super.init(collectionViewLayout: layout)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SoundWavesViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    collectionView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    collectionView?.showsHorizontalScrollIndicator = false // TODO or show it?
    collectionView?.register(VoiceMessageCell.self,
                             forCellWithReuseIdentifier: reuseIdentifier)
  }
}

extension SoundWavesViewController {
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return voiceMessages.count
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
// let requiredWidth = SoundWaveView.requiredWidth(meteringLevelsCount: voiceMessage.meterLevelsUnscaled.count)
// print("[currentWidths] setting \(row) to \(requiredWidth)")
// currentWidths[row] = requiredWidth
    // swiftlint:disable force_cast
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! VoiceMessageCell
    cell.configure(with: voiceMessages[indexPath.row])
    cell.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
//    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    onVoiceMessageSelected(voiceMessages[indexPath.row])
  }
}

extension SoundWavesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
  }
}

//extension SoundWavesViewController: UICollectionViewDelegateFlowLayout {
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
//}
