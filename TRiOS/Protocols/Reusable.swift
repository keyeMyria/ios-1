// see https://github.com/AliSoftware/Reusable/blob/master/Sources/View/UITableView%2BReusable.swift

import UIKit

protocol Reusable: class {
  static var reuseIdentifier: String { get }
}

extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UITableView {
  final func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
    self.register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
  }

  final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) where T: Reusable {
    self.register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
  }

  final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: Reusable {
    guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
        + "and that you registered the cell beforehand")
    }
    return cell
  }

  final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T? where T: Reusable {
    guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
      fatalError("Failed to dequeue a header/footer with identifier \(viewType.reuseIdentifier) "
        + "matching type \(viewType.self). "
        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
        + "and that you registered the header/footer beforehand")
    }
    return view
  }
}

extension UICollectionView {
  final func register<T: UICollectionViewCell>(cellType: T.Type)  where T: Reusable {
    self.register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
  }

  final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String) where T: Reusable {
    self.register(supplementaryViewType.self,
                  forSupplementaryViewOfKind: elementKind,
                  withReuseIdentifier: supplementaryViewType.reuseIdentifier)
  }

  final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: Reusable {
    let bareCell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
    guard let cell = bareCell as? T else {
      fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
        + "and that you registered the cell beforehand")
    }
    return cell
  }

  final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
    (ofKind elementKind: String, for indexPath: IndexPath, viewType: T.Type = T.self) -> T
    where T: Reusable {
      let view = self.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                       withReuseIdentifier: viewType.reuseIdentifier,
                                                       for: indexPath)
      guard let typedView = view as? T else {
        fatalError("Failed to dequeue a supplementary view with identifier \(viewType.reuseIdentifier) "
          + "matching type \(viewType.self). "
          + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
          + "and that you registered the supplementary view beforehand")
      }
      return typedView
  }
}
