import Foundation

// TODO
// listen for NSUbiquityIdentityDidChangeNotification and out-of-storage?
// if get different token, save it (into the server database as well)
// if change was whe the app was offline, fetch the token every time still in
// "app did finish launching with options", compare it, and if it's different,
// save, and send to the backend as well

// or in account service?
enum AppAccountError: RankedError {
  var severity: RankedErrorSeverity {
    return .init(level: .medium, duration: .permanent)
  }

  case unavailableCloudID
//  case staleToken
}

protocol AppAccountType: class {
  var hasSeenOnboarding: Bool { get set }
  var isAuthenticated: Bool { get }
  var userID: Int? { get set }
  var cloudID: String? { get set }
  // token
}

protocol AppAccountStorage: class {
  var userID: Int? { get set }
  var cloudID: String? { get set }
  var hasSeenOnboarding: Bool { get set }
}

private enum AppUserDefaultsKeys {
  static let hasSeenOnboarding = "hasSeenOnboarding"
  static let currentUserID = "currentUserID"
  static let currentCloudID = "currentCloudID"
  // has mic enabled (checked on startup)
}

extension UserDefaults: AppAccountStorage {
  var userID: Int? {
    get { return UserDefaults.standard.object(forKey: AppUserDefaultsKeys.currentUserID) as? Int }
    set { UserDefaults.standard.set(newValue, forKey: AppUserDefaultsKeys.currentUserID) }
  }

  var cloudID: String? {
    get { return UserDefaults.standard.string(forKey: AppUserDefaultsKeys.currentCloudID) }
    set { UserDefaults.standard.set(newValue, forKey: AppUserDefaultsKeys.currentCloudID) }
  }

  var hasSeenOnboarding: Bool {
    get { return UserDefaults.standard.bool(forKey: AppUserDefaultsKeys.hasSeenOnboarding) }
    set { UserDefaults.standard.set(newValue, forKey: AppUserDefaultsKeys.hasSeenOnboarding) }
  }
}

final class AppAccount: AppAccountType {
//  enum AuthStatus {
//    case authenticated
//    case unauthenticated
//  }

  private let storage: AppAccountStorage

  var isAuthenticated: Bool {
    return userID != nil && cloudID != nil
  }

  // Make into computed variable and use .authenticated(userID, apiToken, iCloudID)?
//  var authStatus: AuthStatus {
//    return .authenticated
//  }

  /// can it be computable?
  /// has one user id (user data can be looked up from the saved_users table)
  var userID: Int? {
    didSet {
      if userID != oldValue {
        storage.userID = userID
      }
    }
  }

  /// api token of the current account (stored in keychain)
//  var apiToken: String

  /// iCloudID of the user which helps to forgo typical registration flow
  ///
  /// See https://medium.com/@skreutzb/ios-onboarding-without-signup-screens-cb7a76d01d6e
  var cloudID: String? {
    didSet {
      if cloudID != oldValue {
        storage.cloudID = cloudID
      }
    }
  }

  var hasSeenOnboarding: Bool {
    didSet {
      storage.hasSeenOnboarding = hasSeenOnboarding
    }
  }

  init(from storage: AppAccountStorage) {
    self.storage = storage
    userID = storage.userID
    cloudID = storage.cloudID
    hasSeenOnboarding = storage.hasSeenOnboarding
  }
}
