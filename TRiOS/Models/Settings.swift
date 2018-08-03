struct Settings {
  struct Input {
    let title: String
    let value: String
  }

  struct Detail {
    let text: String
    let detail: String?
    // TODO isSelectable only if has action
    let onClick: (() -> Void)?
  }

  struct Switch {
    let text: String
    let isOn: Bool
    let onToggle: (Bool) -> Void
  }

  struct Section {
    enum Row {
      case input(Input)
      case detail(Detail)
      case `switch`(Switch)
    }

    let header: String?
    let rows: [Row]
    let footer: String?

    // swiftlint:disable:next function_default_parameter_at_end
    init(header: String? = nil, rows: [Row], footer: String? = nil) {
      self.rows = rows
      self.header = header
      self.footer = footer
    }
  }
}
