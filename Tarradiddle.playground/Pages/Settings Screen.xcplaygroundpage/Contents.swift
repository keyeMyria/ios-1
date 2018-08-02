import UIKit
import PlaygroundSupport
@testable import TRAppProxy

//let account = FakeAccount()
//let vc = SettingsViewController(account: account, onDismiss: { print("dismissed") })

//let settings: [SettingsSection] = [
//  .init(
//    rows: [
//      .detail(.init(text: "hello", moreInfo: true, detail: "wat")),
//      .textInput
//    ]
//  ),
//  .init(
//    rows: [
//      .detail(.init(text: "🎵  Notifications and Sounds", moreInfo: true, detail: nil)),
//      .detail(.init(text: "🔒  Privacy and Security", moreInfo: true, detail: nil)),
//      .detail(.init(text: "💾  Data and Storage", moreInfo: true, detail: nil)),
//      .detail(.init(text: "🌍  Language", moreInfo: true, detail: "English")),
//    ]
//  ),
//  .init(
//    rows: [
//      .detail(.init(text: "🤬  Complain", moreInfo: true, detail: nil)),
//      .detail(.init(text: "🤔  FAQ", moreInfo: true, detail: nil)),
//      .detail(.init(text: "🙌  Share", moreInfo: true, detail: nil))
//    ]
//  )
//]

//let settings: [SettingsSection] = [
//  .init(
//    header: "Message notifications",
//    rows: [
//      .switch(.init(text: "Alert", isOn: true)),
//      .switch(.init(text: "Message Preview", isOn: false)),
//      .detail(.init(text: "Sound", moreInfo: true, detail: "Alert"))
//    ],
//    footer: "You can set custom notifications for specific users on their info page."
//  ),
//  // TODO need more space here
//  .init(
//    header: "In-App notifications",
//    rows:[
//      .switch(.init(text: "In-App Sounds", isOn: true)),
//      .switch(.init(text: "In-App Vibrate", isOn: false)),
//      .switch(.init(text: "In-App Preview", isOn: true)),
//    ]
//  ),
//  .init(
//    rows: [
//      // TODO dangerDetail
//      .detail(.init(text: "Reset All Notifications", moreInfo: false, detail: nil))
//    ],
//    footer: "Undo all custom notification settings for all your conversations."
//  )
//]

let settings: [SettingsSection] = [
  .init(
    header: "Privacy",
    rows: [
      .detail(.init(text: "Blocked Users", moreInfo: true, detail: nil), action: {
        print("tapped blocked users")
      }),
      .detail(.init(text: "Last Seen", moreInfo: true, detail: "Everybody"), action: {
        print("tapped last seen")
      }),
      .detail(.init(text: "Show Timezone", moreInfo: true, detail: "Everybody"), action: nil)
    ],
    footer: "Change what other people can see and do about you."
  ),
  .init(
    header: "Security",
    rows: [
      .detail(.init(text: "Passcode Lock", moreInfo: true, detail: nil), action: nil),
      .detail(.init(text: "Active Sessions", moreInfo: true, detail: nil), action: nil)
    ]
  ),
  .init(
    header: "Delete my account",
    rows: [
      .detail(.init(text: "If Away For", moreInfo: true, detail: "3 months"), action: nil)
    ],
    footer: "If you do not come online at least once within this period, your account will be deleted along with all messages and conversations."
  ),
  .init(
    rows: [
      .detail(.init(text: "Data Settings", moreInfo: true, detail: nil), action: nil)
    ],
    footer: "Control which of your data is stored in the cloud."
  )
  // TODO need more space here
]

let vc = SettingsTableViewController(settings: settings)

PlaygroundPage.current.liveView = playgroundWrapper(child: vc, device: .phone4inch)
