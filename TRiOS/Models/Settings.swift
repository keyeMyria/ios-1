struct Settings {
  struct Input {
    enum ValidationState {
      case valid
      case invalid(errorMessage: String)
    }

    let label: String?
    let placeholder: String
    let initialValue: String
    let validation: ((String) -> ValidationState)?
  }

  struct Detail {
    let text: String
    let detail: String?
    let onClick: (() -> Void)?

    var isSelectable: Bool { return onClick != nil }
    var hasMoreInfo: Bool { return onClick != nil }
  }

  struct Switch {
    let text: String
    let initialValue: Bool
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
