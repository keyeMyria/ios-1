import UIKit

final class CollectionViewHorizontalInversedLayout: UICollectionViewLayout {
  private var cellHeight: CGFloat = 100

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()

    if let collectionView = collectionView {
      for section in 0..<collectionView.numberOfSections {
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        for item in 0..<numberOfItems {
          let indexPath = IndexPath(item: item, section: section)
          let layoutAttr = layoutAttributesForItem(at: indexPath)
          if let layoutAttr = layoutAttr, layoutAttr.frame.intersects(rect) {
            layoutAttributes.append(layoutAttr)
          }
        }
      }
    }

    return layoutAttributes
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    let contentSize = collectionViewContentSize
    layoutAttr.frame = CGRect(x: collectionViewContentSize.width - CGFloat(indexPath.item) * collectionView!.frame.width,
                              y: 0,
                              width: collectionView!.frame.width,
                              height: cellHeight)

    return layoutAttr
  }

  func numberOfItemsInSection(_ section: Int) -> Int? {
    guard
      let collectionView = collectionView,
      let numberOfItemsInSection = collectionView.dataSource?.collectionView(collectionView,
                                                                             numberOfItemsInSection: section) else {
        return 0
    }

    return numberOfItemsInSection
  }

  override var collectionViewContentSize: CGSize {
    guard let collectionView = collectionView else { return .zero }

    var width: CGFloat = 0
    var bounds: CGRect = .zero

    for section in 0..<collectionView.numberOfSections {
      if let numberOfItemsInSection = numberOfItemsInSection(section) {
        width += CGFloat(numberOfItemsInSection) * collectionView.frame.width
      }
    }

    bounds = collectionView.bounds
    return CGSize(width: max(width, bounds.width), height: bounds.height)
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    guard let oldBounds = collectionView?.bounds else { return false }
    return oldBounds.width != newBounds.width || oldBounds.height != newBounds.height
  }
}
