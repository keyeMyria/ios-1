import Quick
import Nimble

@testable import TRAppProxy

class DetailSettingsCellSpec: QuickSpec {
  override func spec() {
    var cell: DetailSettingsCell!
    var detail: SettingsViewModel.Detail!

    beforeEach {
      cell = DetailSettingsCell(style: .value1, reuseIdentifier: nil)
    }

    describe("text") {
      it("is properly configured") {
        detail = SettingsViewModel.Detail(text: "Notifications like", detail: nil, onClick: nil)
        expect(detail.text) == "Notifications like" // TODO move to its own test

        cell.configure(for: detail)
        expect(cell.textLabel?.text) == detail.text
      }
    }

    describe("detail") {
      it("is there if it should be") {
        detail = SettingsViewModel.Detail(text: "Privacy and stuff", detail: "yo", onClick: nil)
        expect(detail.detail) == "yo" // TODO

        cell.configure(for: detail)
        expect(cell.detailTextLabel?.text) == detail.detail
      }

      it("isn't there if it shouldn't be") {
        detail = SettingsViewModel.Detail(text: "You can't complain", detail: nil, onClick: nil)
        expect(detail.detail).to(beNil()) // TODO

        cell.configure(for: detail)
        expect(cell.detailTextLabel?.text).to(beNil())
      }
    }

    describe("accessoryType") {
      it("is there if if should be") {
        detail = SettingsViewModel.Detail(text: "Privacy and stuff", detail: "yo", onClick: {})
        expect(detail.hasMoreInfo) == true // TODO

        cell.configure(for: detail)
        expect(cell.accessoryType) == .disclosureIndicator
      }

      it("isn't there if it shouldn't be") {
        detail = SettingsViewModel.Detail(text: "Privacy and stuff", detail: "yo", onClick: nil)
        expect(detail.hasMoreInfo) == false

        cell.configure(for: detail)
        expect(cell.accessoryType) == UITableViewCellAccessoryType.none
      }
    }
  }
}
