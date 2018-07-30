import Foundation

protocol AppAccountType: class {
  static var hasSeenOnboarding: Bool { get set }
  var userID: Int { get }
  var cloudID: String { get }
}

protocol AppAccountStorage {
  var currentUserID: Int? { get }
  var currentCloudID: String? { get }
}

enum AppUserDefaultsKeys {
  static let hasSeenOnboarding = "hasSeenOnboarding"
  static let currentUserID = "currentUserID"
  static let currentCloudID = "currentCloudID"
  // has mic enabled (checked on startup)
}

extension UserDefaults: AppAccountStorage {
  var currentUserID: Int? {
    return UserDefaults.standard.object(forKey: AppUserDefaultsKeys.currentUserID) as? Int
  }

  var currentCloudID: String? {
    return UserDefaults.standard.string(forKey: AppUserDefaultsKeys.currentCloudID)
  }
}

final class AppAccount: AppAccountType {
//  enum AuthStatus {
//    case authenticated
//    case unauthenticated
//  }

  static var hasSeenOnboarding: Bool {
    get { return UserDefaults.standard.bool(forKey: AppUserDefaultsKeys.hasSeenOnboarding) }
    set { UserDefaults.standard.set(newValue, forKey: AppUserDefaultsKeys.hasSeenOnboarding) }
  }

  // Make into computed variable and use .authenticated(userID, apiToken, iCloudID)?
//  var authStatus: AuthStatus {
//    return .authenticated
//  }

  /// has one user id (user data can be looked up from the saved_users table)
  let userID: Int

  /// api token of the current account (stored in keychain)
//  var apiToken: String

  /// iCloudID of the user which helps to forgo typical registration flow
  ///
  /// See https://medium.com/@skreutzb/ios-onboarding-without-signup-screens-cb7a76d01d6e
  let cloudID: String

  init(userID: Int, cloudID: String) {
    self.userID = userID
//    self.apiToken = apiToken
    self.cloudID = cloudID
//    authStatus = .authenticated
  }

  init?(from storage: AppAccountStorage) {
    guard
      let userID = storage.currentUserID,
      let cloudID = storage.currentCloudID else {
        return nil
    }

    self.userID = userID
    self.cloudID = cloudID
  }
}
