import Foundation

final class AppUserDefaults {

  private static let userIDKey = "userID"

  // move to keychain?
  private static let userTokenKey = "userToken"
  private static let userICloudIDKey = "userICloudID"

  static var userID: Int? {
    get { return UserDefaults.standard.object(forKey: userIDKey) as? Int }
    set { UserDefaults.standard.set(newValue, forKey: userIDKey) }
  }

  static var userToken: String? {
    get { return UserDefaults.standard.object(forKey: userTokenKey) as? String }
    set { UserDefaults.standard.set(newValue, forKey: userTokenKey) }
  }

  static var userICloudID: String? {
    get { return UserDefaults.standard.object(forKey: userICloudIDKey) as? String }
    set { UserDefaults.standard.set(newValue, forKey: userICloudIDKey) }
  }
}
