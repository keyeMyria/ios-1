import Foundation
//import GRDB /// to get uder from userID

/// Models the account of the current user of the app
struct Account {

  /// Authentication status of the current account
  enum Status {
    /// Has an API token, iCloudID, and a user ID
    case authenticated

    /// Doesn't have an API token, iCloudID, and a user ID
    case unauthenticated
  }

  // Make into computed variable and use .authenticated(userID, apiToken, iCloudID)?
  var status: Status = .unauthenticated

  /// has one user id (user data can be looked up from the saved_users table)
  let userID: Int64

  /// api token of the current account (stored in keychain)
  var apiToken: String

  /// iCloudID of the user which helps to forgo typical registration flow
  ///
  /// See https://medium.com/@skreutzb/ios-onboarding-without-signup-screens-cb7a76d01d6e
  var iCloudID: String

  init(userID: Int64, apiToken: String, iCloudID: String) {
    self.userID = userID
    self.apiToken = apiToken
    self.iCloudID = iCloudID
    status = .authenticated
  }

  /// Models current account's settings
  struct Settings {
    struct Notifications {
      
    }

    var notifications = Notifications()
  }
}

// move out networking to TarradiddleAPI?
