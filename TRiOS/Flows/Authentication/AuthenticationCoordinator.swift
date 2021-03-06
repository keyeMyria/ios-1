//import UIKit
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

import Foundation

protocol AuthenticationCoordinatorResult: class {
  var finishFlow: ((Result<AppAccountType, AnyError>) -> Void)? { get set }
}

final class AuthenticationCoordinator: Coordinating, AuthenticationCoordinatorResult {
  var finishFlow: ((Result<AppAccountType, AnyError>) -> Void)?
  var childCoordinators: [Coordinating] = []

  private let accountService: AccountServiceType
  private let account: AppAccountType

  init(account: AppAccountType, accountService: AccountServiceType) {
    self.accountService = accountService
    self.account = account
  }

  func start() {
    if account.isAuthenticated {
      finishFlow?(.success(account))
    } else {
      account.cloudID = "asdfasdf"
      account.userID = 123
      finishFlow?(.success(account))
//      accountService.getCloudID { [weak self] result in
//        guard let `self` = self else { return }
//        switch result {
//        case let .success(cloudID):
//          // TODO
//          self.finishFlow?(.success(AppAccount(userID: 123, cloudID: cloudID)))
//        case let .failure(error):
//          self.finishFlow?(.failure(error))
//        }
//      }
    }
  }
}
