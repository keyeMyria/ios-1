import UIKit

enum SettingsRow {
  case input(SettingsInput)
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

final class SettingsTableViewController: UITableViewController {
  private let settings: [SettingsSection]

  init(settings: [SettingsSection]) {
    self.settings = settings
    super.init(style: .grouped)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SettingsTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(cellType: DetailSettingsCell.self)
    tableView.register(cellType: SwitchSettingsCell.self)
    tableView.register(cellType: LabeledInputCell.self)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}

extension SettingsTableViewController {
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
    case let .detail(detail, action: _):
      let cell: DetailSettingsCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: detail)
      return cell

    case let .switch(info, action: _):
      let cell: SwitchSettingsCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: info)
      return cell

    case let .input(input):
      let cell: LabeledInputCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: input)
      return cell
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = settings[indexPath.section].rows[indexPath.row]
    switch row {
    case let .detail(_, action: action): action?()
    case let .switch(_, action: action): action?()
    default: ()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
//
//  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    <#code#>
//  }
}
