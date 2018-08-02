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

struct SettingsDetail {
  let text: String
  let moreInfo: Bool
  let detail: String?
}

enum SettingsRow {
  case textInput
  case detail(SettingsDetail)
}

struct SettingsSection {
  let header: String?
  let rows: [SettingsRow]
  let footer: String?

  // swiftlint:disable:next function_default_parameter_at_end
  init(header: String? = nil, rows: [SettingsRow], footer: String? = nil) {
    self.rows = rows
    self.header = header
    self.footer = footer
  }
}

final class SettingsViewController: UIViewController {
  private let account: FakeAccountType
  private let onDismiss: () -> Void
  private let settings: [SettingsSection] = [
    .init(
      header: "Hello header",
      rows: [
        .detail(.init(text: "hello", moreInfo: true, detail: "wat")),
        .textInput
      ]
    ),
    .init(
      rows: [
        .detail(.init(text: "hello again", moreInfo: true, detail: "wat"))
      ]
    ),
    .init(
      rows: [
        .textInput,
        .textInput
      ],
      footer: "asdf"
    ),
    .init(
      rows: [
        .textInput
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

extension SettingsViewController {
  @objc private func doneClicked() {
    onDismiss()
  }
}

extension SettingsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    let navBar = UINavigationBar()
    let doneItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClicked))
    navBar.topItem?.rightBarButtonItem = doneItem
    view.addSubview(navBar)
    navBar.topAnchor == view.layoutMarginsGuide.topAnchor
    navBar.leadingAnchor == view.leadingAnchor
    navBar.trailingAnchor == view.trailingAnchor

    let settingsTableViewController = SettingsTableViewController(settings: settings)
    addChildViewController(settingsTableViewController)
    view.addSubview(settingsTableViewController.view)
    settingsTableViewController.view.topAnchor == navBar.bottomAnchor
    settingsTableViewController.view.bottomAnchor == view.bottomAnchor
    settingsTableViewController.view.leadingAnchor == view.leadingAnchor
    settingsTableViewController.view.trailingAnchor == view.trailingAnchor
  }
}
