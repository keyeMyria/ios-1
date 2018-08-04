import UIKit

final class SettingsTableViewController: UITableViewController {
  private let sections: [SettingsViewModel.Section]

  init(sections: [SettingsViewModel.Section]) {
    self.sections = sections
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
    tableView.register(cellType: TextInputSettingsCell.self)
    tableView.register(cellType: ProfileCell.self)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}

extension SettingsTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].rows.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].header
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return sections[section].footer
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = sections[indexPath.section].rows[indexPath.row]

    switch row {
    case let .detail(detail):
      let cell: DetailSettingsCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: detail)
      return cell

    case let .profile(profile):
      let cell: ProfileCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: profile)
      return cell

    case let .switch(`switch`):
      let cell: SwitchSettingsCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: `switch`)
      return cell

    case let .textInput(input):
      let cell: TextInputSettingsCell = tableView.dequeueReusableCell(for: indexPath)
      cell.configure(for: input)
      return cell
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let row = sections[indexPath.section].rows[indexPath.row]
    switch row {
    case .profile: return 80
//    default: return UITableViewAutomaticDimension
      default: return 42
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = sections[indexPath.section].rows[indexPath.row]
    switch row {
    case let .detail(detail):
      detail.onClick?() // TODO test
    default: ()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

//  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return sections[section].headerView?.frame.size.height ?? 20
//  }
}
