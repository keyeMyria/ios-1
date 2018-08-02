import UIKit
import PlaygroundSupport

@testable import TRAppProxy
import Anchorage

let account = FakeAccount()
let vc = SettingsViewController(account: account, onDismiss: { print("dismissed") })

PlaygroundPage.current.liveView = playgroundWrapper(child: vc, device: .phone4inch)
