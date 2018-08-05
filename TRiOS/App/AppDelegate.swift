import UIKit

// TODO https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPInternational/Introduction/Introduction.html#//apple_ref/doc/uid/10000171i
// + accessibility

// TODO store cached files (like user pics) in sqlite or /Caches or still in /Application Support?
// TODO what about audio files (voice messages), in /Application Support but ignored during backup?
// TODO need to backup audio files? they are not stored on the backend.
// TODO maybe in /Documents and use the filesystem enctyprion?
// https://developer.apple.com/library/content/documentation/Security/Conceptual/SecureCodingGuide/Introduction.html#//apple_ref/doc/uid/TP40002415
// then the user would be able to see them in icloud
// TODO but not just audio files, maybe a custom file like a <username>.conversation (file package) which would contain multiple audio files?
// TODO what about backup? srote files in a separate database? and mark as not-for-backup?

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  private lazy var rootController: UINavigationController = {
    UINavigationController()
  }()

  private lazy var appCoordinator: AppCoordinator = {
    AppCoordinator(router: Router(rootController: rootController))
  }()

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootController
    window?.makeKeyAndVisible()
    appCoordinator.start()
    return true
  }
}
