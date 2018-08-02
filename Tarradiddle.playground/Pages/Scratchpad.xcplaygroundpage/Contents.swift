import PlaygroundSupport
import UIKit

//import RxSwift
//import RxCocoa

//Observable.from(["hello", "darkness", "my", "old", "friend"])
//  .map { $0.uppercased() }
//  .subscribe(onNext: { print($0) })

//import Apollo
//import RxApollo
//@testable import Tarradiddle

//
//apollo.rx
//  .fetch(query: UsersQuery(searchQuery: "idiot"))
//  .subscribe(onSuccess: { data in
//    print(data.users)
//  })
//
//PlaygroundPage.current.needsIndefiniteExecution = true

//import Foundation
//import GRDB

//extension Array<Int>: DatabaseValueConvertible {
//  var databaseValue: DatabaseValue {
//    return self.
//  }
//
//
//}

//let meteringLevels = [1, 2, 3]
//
//meteringLevels.encode(to: JSONEncoder())

//(meteringLevels as NSArray).

//let view = UIView(frame: .init(x: 0, y: 0, width: 100, height: 100))
//let barbutton = UIBarButtonItem
//view.addSubview(barbutton)

//FileManager.default.ubiquityIdentityToken

//UserDefaults.standard.userID = nil
//UserDefaults.standard.userID
//UserDefaults.standard.userID = 1
//UserDefaults.standard.userID
//
//UserDefaults.standard.iCloudToken = nil
//UserDefaults.standard.iCloudToken
//UserDefaults.standard.iCloudToken = "asdfadsf"
//UserDefaults.standard.iCloudToken

//PlaygroundPage.current.liveView = view

@testable import TRAppProxy

let nav = UINavigationController()
nav.navigationBar.barTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
nav.navigationBar.tintColor = .white
//nav.navigationBar.
let vc = SettingsViewController(account: FakeAccount(), onDismiss: { print("dismissed") })
vc.title = "Settings"
nav.pushViewController(vc, animated: true)

PlaygroundPage.current.liveView = playgroundWrapper(
  child: nav,
  device: .phone4inch
)
