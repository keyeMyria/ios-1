import UIKit

final class AppEnvironment {
  let buildVersion = Bundle.main.buildVersionNumber
  let releaseVersion = Bundle.main.releaseVersionNumber

  let iosVersion = UIDevice.current.systemVersion
  let hostDevice = UIDevice.current.model
}
