import UIKit

final class SettingsTableViewController: UITableViewController {
  private let settings: [Settings.Section]

  init(settings: [Settings.Section]) {
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
    tableView.register(cellType: InputSettingsCell.self)
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
    case let .detail(detail):
      let cell: DetailSettingsCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: detail)
      return cell

    case let .switch(`switch`):
      let cell: SwitchSettingsCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: `switch`)
      return cell

    case let .input(input):
      let cell: InputSettingsCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: input)
      return cell
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = settings[indexPath.section].rows[indexPath.row]
    switch row {
    case let .detail(detail): detail.onClick?() // TODO test
    default: ()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
//
//  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    <#code#>
//  }
}
