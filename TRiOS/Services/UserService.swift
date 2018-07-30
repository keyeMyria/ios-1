import RxSwift
import Apollo; import RxApollo
import GRDB; import RxGRDB
import TRAPI

enum UserServiceError: Error {
  case creationFailed
  case updateFailed(User)
  case deletionFailed(User)
}

protocol UserServiceType {
//  @discardableResult
//  func createUser(id: Int64, handle: String) -> Observable<User>

// TODO need it?
//  @discardableResult
//  func delete(user: User) -> Observable<Void>

// TODO
//  @discardableResult
//  func update(user: User, handle: String) -> Observable<User>
//
//  func savedUsers() -> Observable<[User]>
//
//  func getUser(id: Int64) -> Observable<User?>

  // TODO return Observable<[User]>
  func remoteUserSearch(query: String) -> Observable<UsersQuery.Data>
}

class UserService: UserServiceType {

//  let tarradiddleAPI
  private let apollo: ApolloClient
  private let dbPool: DatabasePool

  init(apollo: ApolloClient, dbPool: DatabasePool) {
    self.apollo = apollo
    self.dbPool = dbPool
  }

  // TODO refactor (shouldn't return anything unless subscribed to)
//  func createUser(id: Int64, handle: String) -> Observable<User> {
//    do {
//      let user = try dbPool. { db -> User in
//        var user = User(id: id, handle: handle)
//        try user.insert(db)
//        return user
//      }
//      return .just(user)
//    } catch let error {
//      // log instead of print?
//      print("Failed to create user (id: \(id), handle: \(handle)) with error: \(error.localizedDescription)")
//      return .error(UserServiceError.creationFailed)
//    }
//  }

  // TODO can be a one time call, not an observable,
  // an observable can be service.savedUsers computed property
//  func savedUsers() -> Observable<[User]> {
//    return User.all().rx.fetchAll(in: dbQueue)
//  }
//
//  func getUser(id: Int64) -> Observable<User?> {
//    return User.filter(key: id).rx.fetchOne(in: dbQueue)
//  }

  func remoteUserSearch(query: String) -> Observable<UsersQuery.Data> {
    return apollo.rx
      .fetch(query: UsersQuery(searchQuery: query))
      .asObservable()
  }
}
