import Foundation
import RxSwift
import RxCocoa
import Action
import TRAPI

//protocol UserSearchViewModelType: ViewModelType {
//  struct Input {
//    var searchQuery: Observable<String>
//  }
//
//  struct Output {
//    var found
//  }
//}

final class UserSearchViewModel: ViewModelType {

  let sceneCoordinator: SceneCoordinatorType
  let userService: UserServiceType

  struct Input {
    let searchQuery: Observable<String>
  }

  struct Output {
    let foundUsers: Driver<[UsersQuery.Data.User]>
  }

  //  lazy var selectUserAction: Action<User, Void> = { this in
//    return Action { user in
//      let userInfoViewModel = UserInfoViewModel(
//        user: user,
//        coordinator: this.sceneCoordinator,
//        befriendAction: this.onBefriend(user: user)
//      )
//      return this.sceneCoordinator.transition(to: .userInfo(userInfoViewModel), type: .push)
//    }
//  }(self)

  init(userService: UserServiceType, coordinator: SceneCoordinatorType) {
    self.userService = userService
    self.sceneCoordinator = coordinator
  }

  func transform(input: Input) -> Output {
    let foundUsers = input.searchQuery.asObservable()
      .throttle(0.3, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .flatMapLatest { query in
        return self.userService.remoteUserSearch(query: query)
      }
      .map { data in
        return (data.users ?? []).compactMap { $0 }
      }
      .asDriver(onErrorJustReturn: [])

    return Output(foundUsers: foundUsers)
  }

  // TODO maybe just use inputs -> outputs instead
//  func onSearch() -> Action<String, UsersQuery.Data> {
//    return Action { query in
//      return self.userService.remoteUserSearch(query: query)
//    }
//  }

}
