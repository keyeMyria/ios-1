//import UIKit
//import RxSwift
//
//final class AuthCoordinator: BaseCoordinator<Account> {
//  // tries to log in or fetch user id from user defaults and token from keychain
//  // if either fails?
//
//  private let window: UIWindow
//
//  init(window: UIWindow) {
//    self.window = window
//  }
//
//  override func start() -> Observable<Account> {
//    return Observable.just(Account())
//  }
//}

//// do this during the loading screen
//if self.currentUser == nil {
//  User.fetchRecordID { iCloudUserID, error in
//    if let iCloudUserID = iCloudUserID {
//      print("Fetched iCloudID is \(iCloudUserID)")
//      User.create(with: iCloudUserID) { user, error in
//        // store user_id and icloud_id and token in keychain (or user defaults for now)
//        guard let user = user, error == nil else {
//          print(error as Any)
//          return
//          // show the user the error
//          // if error (user already exists), show a banner or something with the error on it ...
//        }
//        print(user)
//        User.saveToUserDefaults(user: user)
//      }
//    } else {
//      // fail, ask the user to login with icloud
//      print("Fetched iCloudID was nil")
//    }
//  }
//} else {
//  print(currentUser?.iCloudID, currentUser?.id, currentUser?.token)
//}
