import UIKit

protocol Bindable {
  associatedtype ViewModelType

  var viewModel: ViewModelType! { get set }

  func bindViewModel()
}

extension Bindable where Self: UIViewController {
  mutating func bindViewModel(to model: Self.ViewModelType) {
    viewModel = model
    loadViewIfNeeded()
    bindViewModel()
  }
}
