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

struct SettingsSwitch {
  let text: String
  let isOn: Bool
}

enum SettingsRow {
  case textInput
  case detail(SettingsDetail, action: (() -> Void)?)
  case `switch`(SettingsSwitch, action: (() -> Void)?)
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
        .detail(.init(text: "hello", moreInfo: true, detail: "wat"), action: nil),
        .textInput
      ]
    ),
    .init(
      rows: [
        .detail(.init(text: "hello again", moreInfo: true, detail: "wat"), action: nil)
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

    let settingsTableViewController = SettingsTableViewController(settings: settings)
    settingsTableViewController.view.backgroundColor = #colorLiteral(red: 0.977547657, green: 0.9692376636, blue: 0.9566834885, alpha: 1)
    addChildViewController(settingsTableViewController)
    view.addSubview(settingsTableViewController.view)
    settingsTableViewController.view.topAnchor == separator.bottomAnchor
    settingsTableViewController.view.bottomAnchor == view.bottomAnchor
    settingsTableViewController.view.leadingAnchor == view.leadingAnchor
    settingsTableViewController.view.trailingAnchor == view.trailingAnchor
  }
}
