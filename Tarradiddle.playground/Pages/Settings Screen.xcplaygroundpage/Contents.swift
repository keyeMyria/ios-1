import UIKit
import PlaygroundSupport
@testable import TRAppProxy

class FakeAccountService: AccountServiceType {
  func getCloudID(callback: @escaping (Result<String, AnyError>) -> Void) {
    callback(.success("_iwegfakjsdfhgaksdjhfg"))
  }
}

let accountService = FakeAccountService()
let vc = TopSettingsViewController(accountService: accountService, onDismiss: { print("dismissed") })

//let avatar = #imageLiteral(resourceName: "idiot.jpg")
//
//let sections: [SettingsViewModel.Section] = [
//  .init(
//    rows: [
//      .profile(.init(avatar: avatar, name: "John Doe", handle: nil)),
//      .detail(.init(text: "Set Profile Photo", detail: nil, onClick: nil))
//    ]
//  ),
//  .init(
//    rows: [
//      .detail(.init(text: "🎵  Notifications and Sounds", detail: nil, onClick: {})),
//      .detail(.init(text: "🔒  Privacy and Security", detail: nil, onClick: {})),
//      .detail(.init(text: "💾  Data and Storage", detail: nil, onClick: {})),
//      .detail(.init(text: "🌍  Language", detail: "English", onClick: {}))
//    ]
//  ),
//  .init(
//    rows: [
//      .detail(.init(text: "🤬  Complain", detail: nil, onClick: {})),
//      .detail(.init(text: "🤔  FAQ", detail: nil, onClick: {})),
//      .detail(.init(text: "🙌  Share", detail: nil, onClick: {}))
//    ]
//  )
//]

//let sections: [SettingsViewModel.Section] = [
//  .init(
//    header: "Message notifications",
//    rows: [
//      .switch(.init(text: "Alert", initialValue: true, onToggle: { isOn in
//        print("alert?:", isOn)
//      })),
//      .switch(.init(text: "Message Preview", initialValue: false, onToggle: { isOn in
//        print("preview?:", isOn)
//      })),
//      .detail(.init(text: "Sound", detail: "Alert", onClick: nil))
//    ],
//    footer: "You can set custom notifications for specific users on their info page."
//  ),
//  // TODO need more space here
//  .init(
//    header: "In-App notifications",
//    rows:[
//      .switch(.init(text: "In-App Sounds", initialValue: true, onToggle: { isOn in
//        print("sounds?:", isOn)
//      })),
//      .switch(.init(text: "In-App Vibrate", initialValue: false, onToggle: { isOn in
//        print("vibrate?:", isOn)
//      })),
//      .switch(.init(text: "In-App Preview", initialValue: true, onToggle: { isOn in
//        print("in app preview?:", isOn)
//      }))
//    ]
//  ),
//  .init(
//    rows: [
//      // TODO dangerDetail
//      .detail(.init(text: "Reset All Notifications", detail: nil, onClick: nil))
//    ],
//    footer: "Undo all custom notification settings for all your conversations."
//  )
//]

//let sections: [SettingsViewModel.Section] = [
//  .init(
//    header: "Privacy",
//    rows: [
//      .detail(.init(text: "Blocked Users", detail: nil, onClick: {
//        print("tapped blocked users")
//      })),
//      .detail(.init(text: "Last Seen", detail: "Everybody", onClick: {
//        print("tapped last seen")
//      })),
//      .detail(.init(text: "Show Timezone", detail: "Everybody", onClick: nil))
//    ],
//    footer: "Change what other people can see and do about you."
//  ),
//  .init(
//    header: "Security",
//    rows: [
//      .detail(.init(text: "Passcode Lock", detail: nil, onClick: nil)),
//      .detail(.init(text: "Active Sessions", detail: nil, onClick: nil))
//    ]
//  ),
//  .init(
//    header: "Delete my account",
//    rows: [
//      .detail(.init(text: "If Away For", detail: "3 months", onClick: nil))
//    ],
//    footer: "If you do not come online at least once within this period, your account will be deleted along with all messages and conversations."
//  ),
//  .init(
//    rows: [
//      .detail(.init(text: "Data Settings", detail: nil, onClick: nil))
//    ],
//    footer: "Control which of your data is stored in the cloud."
//  )
//  // TODO need more space here
//]


//let sections: [SettingsViewModel.Section] = [
//  .init(
//    rows: [
//      .textInput(
//        .init(
//          label: "Handle",
//          placeholder: "Your Handle",
//          initialValue: "idiot",
//          validation: { string in
//            print("handle:", string)
//            return .valid
//          }
//        )
//      )
//    ],
//    // TODO attributed string
//    footer: "You can choose a handle on Tarradiddle. If you do, other people will be able to find you by this username and contact you without knowing your phone number.\n\nYou can use a-z, 0-9 and underscores. Minimum length is 5 characters."
//  )
//]

//let vc = SettingsTableViewController(sections: sections)
PlaygroundPage.current.liveView = playgroundWrapper(child: vc, device: .phone4inch)
//vc.preferredContentSize = vc.view.frame.size
//PlaygroundPage.current.liveView = vc
