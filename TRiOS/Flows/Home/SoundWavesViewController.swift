import UIKit

final class SoundWavesViewController: UICollectionViewController {
//  var viewModel: SoundWavesViewModelType!
//  var viewModel: VoiceMessagesViewModelType!
  private let reuseIdentifier = "SoundWaveCell"
  private let onVoiceMessageSelected: (VoiceMessage) -> Void
  // TODO a bar which separates sent and recorded messages
  private var currentWidths: [Int: CGFloat] = [:]

  var voiceMessages: [VoiceMessage] = [] {
    didSet { collectionView?.reloadData() }
  }

  init(onVoiceMessageSelected: @escaping (VoiceMessage) -> Void) {
    self.onVoiceMessageSelected = onVoiceMessageSelected
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 2 // TODO
    layout.minimumInteritemSpacing = 2
    layout.estimatedItemSize = CGSize(width: 10, height: 75)
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
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
//    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    onVoiceMessageSelected(voiceMessages[indexPath.row])
  }
}

extension SoundWavesViewController: UICollectionViewDelegateFlowLayout {
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
