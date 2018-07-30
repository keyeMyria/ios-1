import UIKit

protocol RouterType: Presentable {
  func present(_ module: Presentable?)
  func present(_ module: Presentable?, animated: Bool)

  func push(_ module: Presentable?)
  func push(_ module: Presentable?, animated: Bool)
  func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)

  func popModule()
  func popModule(animated: Bool)

  func dismissModule()
  func dismissModule(animated: Bool)
  func dismissModule(animated: Bool, completion: (() -> Void)?)

  func setRoot(to module: Presentable?)
  func setRoot(to module: Presentable?, hideBar: Bool)

  func popToRootModule()
  func popToRootModule(animated: Bool)
}

final class Router: RouterType {
  private weak var rootController: UINavigationController?
  private var completions: [UIViewController: () -> Void] = [:]

  init(rootController: UINavigationController) {
    self.rootController = rootController
  }

  func toPresent() -> UIViewController? {
    return rootController
  }

  func present(_ module: Presentable?) { present(module, animated: true) }
  func present(_ module: Presentable?, animated: Bool) {
    guard let controller = module?.toPresent() else { return }
    rootController?.present(controller, animated: animated)
  }

  func push(_ module: Presentable?) { push(module, animated: true) }
  func push(_ module: Presentable?, animated: Bool) { push(module, animated: true, completion: nil) }
  func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
    guard let controller = module?.toPresent(), !(controller is UINavigationController) else {
      assertionFailure("Deprecated push UINavigationController.")
      return
    }

    if let completion = completion { completions[controller] = completion }

    rootController?.pushViewController(controller, animated: animated)
  }

  func popModule() { popModule(animated: true) }
  func popModule(animated: Bool) {
    if let controller = rootController?.popViewController(animated: animated) {
      runCompletion(for: controller)
    }
  }

  func dismissModule() { dismissModule(animated: true) }
  func dismissModule(animated: Bool) { dismissModule(animated: true, completion: nil) }
  func dismissModule(animated: Bool, completion: (() -> Void)?) {
    rootController?.dismiss(animated: animated, completion: completion)
  }

  func setRoot(to module: Presentable?) { setRoot(to: module, hideBar: false) }
  func setRoot(to module: Presentable?, hideBar: Bool) {
    guard let controller = module?.toPresent() else { return }
    rootController?.setViewControllers([controller], animated: false)
    rootController?.isNavigationBarHidden = hideBar
  }

  func popToRootModule() { popToRootModule(animated: true) }
  func popToRootModule(animated: Bool) {
    if let controllers = rootController?.popToRootViewController(animated: animated) {
      controllers.forEach(runCompletion)
    }
  }

  private func runCompletion(for controller: UIViewController) {
    if let completion = completions.removeValue(forKey: controller) {
      completion()
    }
  }
}
