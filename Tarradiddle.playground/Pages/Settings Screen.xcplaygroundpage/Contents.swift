import UIKit
import PlaygroundSupport

@testable import TRAppProxy
import Anchorage

// Account

protocol FakeAccountType {
  var notificationsEnabled: Bool { get set }
}

final class FakeAccount: FakeAccountType {
  var notificationsEnabled: Bool {
    get { return UserDefaults.standard.bool(forKey: "notificationsEnabled") }
    set { UserDefaults.standard.set(newValue, forKey: "notificationsEnabled")}
  }
}

// View Cells

final class FakeSettingsCell: UITableViewCell {

}

final class DetailSettingsCell: UITableViewCell, Reusable {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    accessoryType = .none
  }

  func configure(for detail: SettingsDetail) {
    textLabel?.text = detail.text
    detailTextLabel?.text = detail.detail
    if detail.moreInfo {
      accessoryType = .disclosureIndicator
    }
  }
}

//var cell = DetailSettingsCell(style: .value1,
//                              reuseIdentifier: DetailSettingsCell.reuseIdentifier)
//cell.configure(for: .init(text: "👎  Rate it", moreInfo: true, detail: "What?"))

//let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 45))
//view.backgroundColor = .white
//view.addSubview(cell)
//
//PlaygroundPage.current.liveView = view

final class SwitchCell: UITableViewCell, Reusable {
  private var onToggle: ((Bool) -> Void)?
  @objc private func didToggleSwitch(_ sender: UISwitch) { onToggle?(sender.isOn) }
  private let switchControl = UISwitch()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    switchControl.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
    accessoryView = switchControl
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(isOn: Bool, onToggle: @escaping (Bool) -> Void) {
    textLabel?.text = "Should I kick you?"
    switchControl.isOn = isOn
    self.onToggle = onToggle
  }
}

//var cell = SwitchCell(style: .value1, reuseIdentifier: SwitchCell.reuseIdentifier)
//cell.configure(isOn: true, onToggle: { isOn in print("is on?", isOn)})
//
//let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 45))
//view.backgroundColor = .white
//view.addSubview(cell)
//
//PlaygroundPage.current.liveView = view

// Settings Item and Section

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

  init(header: String? = nil, rows: [SettingsRow], footer: String? = nil) {
    self.rows = rows
    self.header = header
    self.footer = footer
  }
}

// View Controller

final class FakeSettingsViewController: UITableViewController {
  private let account: FakeAccountType
  private let settings: [SettingsSection] = [
    .init(
      header: "Hello header",
      rows: [
        .detail(.init(text: "hello", moreInfo: true, detail: "wat")),
        .textInput
      ]
    )
//    .init(
//      rows: [
//        .detail(.init(title: "hello again"))
//      ]
//    ),
//    .init(
//      rows: [
//        .textInput,
//        .textInput
//      ],
//      footer: "asdf"
//    ),
//    .init(
//      rows: [
//        .textInput
//      ]
//    )
  ]

  init(account: FakeAccountType) {
    self.account = account
    super.init(style: .grouped)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension FakeSettingsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(cellType: DetailSettingsCell.self)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
}

extension FakeSettingsViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return settings.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings[section].rows.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return settings[section].header
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return settings[section].footer
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let setting = settings[indexPath.section].rows[indexPath.row]

    switch setting {
    case let .detail(detail):
      let cell: DetailSettingsCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: detail)
      return cell

    case .textInput:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                               for: indexPath)
      return cell
    }
  }
}

let account = FakeAccount()
let vc = FakeSettingsViewController(account: account)
PlaygroundPage.current.liveView = vc
