import UIKit
import Anchorage

protocol OnboardingViewControllerType: class, Presentable {
  var onFinish: () -> Void { get }
}

// TODO
fileprivate let reuseIdentifier = "OnboardingCell"

final class OnboardingViewController: UICollectionViewController, OnboardingViewControllerType {
  private let pages: [OnboardingPage] = [
    .init(accent: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),
          title: "Don't waste your time going to work",
          message: ""),
    .init(accent: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),
          title: "Get a motorcycle and a sleeping bag",
          message: "👍"),
    .init(accent: #colorLiteral(red: 0.4653195058, green: 0.9082132448, blue: 0.8456412293, alpha: 1),
          title: "Jesus Christ died for your sins",
          message: "😇 This is the \"Onboarding screen\" btw")
  ]

  let onFinish: () -> Void

  init(onFinish: @escaping () -> Void) {
    self.onFinish = onFinish
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    super.init(collectionViewLayout: layout)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private lazy var pageControl = UIPageControl().then {
    $0.numberOfPages = pages.count
    $0.currentPage = 0
  }

  @objc private func onFinishTapped() { onFinish() }
  private let finishButton = UIButton(type: .system).then {
    $0.addTarget(self, action: #selector(onFinishTapped), for: .touchUpInside)
    $0.setTitle("Skip", for: .normal)
    $0.setTitleColor(.gray, for: .normal)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = .black
    collectionView?.showsHorizontalScrollIndicator = false
    collectionView?.isPagingEnabled = true
    //    collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //    collectionView?.contentOffset = CGPoint(x: 0, y: 0)
    collectionView?.register(cellType: OnboardingViewCell.self)

    view.addSubview(pageControl)
    pageControl.centerXAnchor == view.centerXAnchor
    pageControl.bottomAnchor == view.bottomAnchor - 30

    view.addSubview(finishButton)
    finishButton.trailingAnchor == view.trailingAnchor - 30
    finishButton.bottomAnchor == view.bottomAnchor - 30
  }
}

extension OnboardingViewController {
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int { return pages.count }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: OnboardingViewCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.configure(for: pages[indexPath.row])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat { return 0 }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    // TODO
//    print("view", view.frame.size)
//    print("collectionView", collectionView.frame.size)
    return collectionView.frame.size
  }
}

extension OnboardingViewController {
  override func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    pageControl.currentPage = Int(targetContentOffset.pointee.x / view.frame.width)
  }
}
