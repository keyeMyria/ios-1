//import Foundation
//import RxSwift
//
///// See https://github.com/uptechteam/Coordinator-MVVM-Rx-Example
//protocol Coordinating {
//  associatedtype ResultType
//
//  /// Starts job of the coordinator.
//  ///
//  /// - Returns: Result of coordinator job.
//  func start() -> Observable<ResultType>
//}
//
//extension Coordinating {
//
//  /// Utility `DisposeBag` used by the subclasses.
//  let disposeBag = DisposeBag()
//
//  /// Unique identifier.
//  private let identifier = UUID()
//
//  /// Dictionary of the child coordinators. Every child coordinator should be added
//  /// to that dictionary in order to keep it in memory.
//  /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
//  /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
//  private var childCoordinators = [UUID: Any]()
//
//
//  /// Stores coordinator to the `childCoordinators` dictionary.
//  ///
//  /// - Parameter coordinator: Child coordinator to store.
//  private func store<T>(coordinator: Coordinating<T>) {
//    childCoordinators[coordinator.identifier] = coordinator
//  }
//
//  /// Release coordinator from the `childCoordinators` dictionary.
//  ///
//  /// - Parameter coordinator: Coordinator to release.
//  private func free<T>(coordinator: Coordinating<T>) {
//    childCoordinators[coordinator.identifier] = nil
//  }
//
//  /// 1. Stores coordinator in a dictionary of child coordinators.
//  /// 2. Calls method `start()` on that coordinator.
//  /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
//  ///
//  /// - Parameter coordinator: Coordinator to start.
//  /// - Returns: Result of `start()` method.
//  func coordinate<T>(to coordinator: Coordinating<T>) -> Observable<T> {
//    store(coordinator: coordinator)
//    return coordinator.start().do(onNext: { [weak self] _ in
//      self?.free(coordinator: coordinator)
//    })
//  }
//}

protocol Coordinating: class {
  var childCoordinators: [Coordinating] { get set }

  func start()
}

extension Coordinating {
  func add(childCoordinator: Coordinating) {
    for element in childCoordinators { if element === childCoordinator { return } }
    childCoordinators.append(childCoordinator)
  }

  func remove(childCoordinator: Coordinating?) {
    guard let childCoordinator = childCoordinator, !childCoordinators.isEmpty else { return }
    childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
  }
}

