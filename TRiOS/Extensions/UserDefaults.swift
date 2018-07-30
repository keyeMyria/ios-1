import Foundation

// TODO probably a bad idea, just create a new class
extension UserDefaults {

  private enum MuhKey {
    static let iCloudToken = "iCloudToken"
    static let userID = "userID"
  }

  // listen for NSUbiquityIdentityDidChangeNotification and out-of-storage?
  // if get different token, save it (into the server database as well)
  // if change was whe the app was offline, fetch the token every time still in
  // "app did finish launching with options", compare it, and if it's different,
  // save, and send to the backend as well

  /// The iCloud token of the current user (used for authentication)
  var iCloudToken: String? {
    get { return string(forKey: MuhKey.iCloudToken) }
    set { set(newValue, forKey: MuhKey.iCloudToken) }
  }

  /// The ID (as stored on the backend) of the current user
  var userID: Int? {
    get { return value(forKey: MuhKey.userID) as? Int }
    set { set(newValue, forKey: MuhKey.userID) }
  }
}
