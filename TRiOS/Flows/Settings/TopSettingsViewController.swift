import UIKit
import Anchorage

// TODO settings bundle

protocol FakeAccountType {
  var notificationsEnabled: Bool { get set }
}

final class FakeAccount: FakeAccountType {
  var notificationsEnabled: Bool {
    get { return UserDefaults.standard.bool(forKey: "notificationsEnabled") }
    set { UserDefaults.standard.set(newValue, forKey: "notificationsEnabled") }
  }
}

final class TopSettingsViewController: UIViewController {
  private let account: FakeAccountType
  private let onDismiss: () -> Void
  private let sections: [SettingsViewModel.Section] = [
    .init(
      rows: [
        .profile(.init(avatar: nil, name: "John Doe", handle: nil)),
        .detail(.init(text: "Set Profile Photo", detail: nil, onClick: nil))
      ]
    ),
    .init(
      rows: [
        .detail(.init(text: "🎵  Notifications and Sounds", detail: nil, onClick: {})),
        .detail(.init(text: "🔒  Privacy and Security", detail: nil, onClick: {})),
        .detail(.init(text: "💾  Data and Storage", detail: nil, onClick: {})),
        .detail(.init(text: "🌍  Language", detail: "English", onClick: {}))
      ]
    ),
    .init(
      rows: [
        .detail(.init(text: "🤬  Complain", detail: nil, onClick: {})),
        .detail(.init(text: "🤔  FAQ", detail: nil, onClick: {})),
        .detail(.init(text: "🙌  Share", detail: nil, onClick: {}))
      ]
    )
  ]

  init(account: FakeAccountType, onDismiss: @escaping () -> Void) {
    self.account = account
    self.onDismiss = onDismiss
    super.init(nibName: nil, bundle: nil)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TopSettingsViewController {
  @objc private func doneClicked() {
    onDismiss()
  }
}

extension TopSettingsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // TODO can push within a nav controller?
    // then won't need to do this dance with nav bar ...
    view.backgroundColor = #colorLiteral(red: 0.977547657, green: 0.9692376636, blue: 0.9566834885, alpha: 1)

    let navBar = UINavigationBar()
    navBar.backgroundColor = #colorLiteral(red: 0.977547657, green: 0.9692376636, blue: 0.9566834885, alpha: 1)
    navBar.barTintColor = #colorLiteral(red: 0.977547657, green: 0.9692376636, blue: 0.9566834885, alpha: 1)
    navBar.tintColor = .black
    navBar.isTranslucent = false
    let doneItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClicked))
    let item = UINavigationItem()
    item.title = "Settings"
    item.rightBarButtonItem = doneItem
    navBar.setItems([item], animated: false)
    view.addSubview(navBar)
    navBar.topAnchor == view.layoutMarginsGuide.topAnchor
    navBar.leadingAnchor == view.leadingAnchor
    navBar.trailingAnchor == view.trailingAnchor

    let separator = UIView()
    separator.backgroundColor = .black
    view.addSubview(separator)
    separator.topAnchor == navBar.bottomAnchor
    separator.leadingAnchor == view.leadingAnchor
    separator.trailingAnchor == view.trailingAnchor
    separator.heightAnchor == 1

    let settingsTableViewController = SettingsTableViewController(sections: sections)
    settingsTableViewController.view.backgroundColor = #colorLiteral(red: 0.977547657, green: 0.9692376636, blue: 0.9566834885, alpha: 1)
    addChildViewController(settingsTableViewController)
    view.addSubview(settingsTableViewController.view)
    settingsTableViewController.view.topAnchor == separator.bottomAnchor
    settingsTableViewController.view.bottomAnchor == view.bottomAnchor
    settingsTableViewController.view.leadingAnchor == view.leadingAnchor
    settingsTableViewController.view.trailingAnchor == view.trailingAnchor
    settingsTableViewController.didMove(toParentViewController: self)
  }
}
