import RxSwift
import Apollo; import RxApollo
import GRDB; import RxGRDB

enum UserServiceError: Error {
  case creationFailed
  case updateFailed(User)
  case deletionFailed(User)
}

protocol UserServiceType {
  @discardableResult
  func createUser(remoteID: Int64, handle: String) -> Observable<User>

// TODO need it?
//  @discardableResult
//  func delete(user: User) -> Observable<Void>

// TODO
//  @discardableResult
//  func update(user: User, handle: String) -> Observable<User>

  func savedUsers() -> Observable<[User]>

  func getUser(by id: Int64) -> Observable<User?>
}

class UserService: UserServiceType {

//  let tarradiddleAPI
//  private let apollo: ApolloClient
  private let dbQueue: DatabaseQueue

  init(dbQueue: DatabaseQueue) {
//    self.apollo = apollo
    self.dbQueue = dbQueue
  }

  // TODO refactor
  func createUser(remoteID: Int64, handle: String) -> Observable<User> {
    do {
      let user = try dbQueue.inDatabase { db -> User in
        var user = User(id: nil, remoteID: remoteID, handle: handle)
        try user.insert(db)
        return user
      }
      return .just(user)
    } catch let error {
      // log instead of print?
      print("Failed to create user (remoteID: \(remoteID), handle: \(handle)) with error: \(error.localizedDescription)")
      return .error(UserServiceError.creationFailed)
    }
  }

  func savedUsers() -> Observable<[User]> {
    return User.all().rx.fetchAll(in: dbQueue)
  }

  func getUser(by id: Int64) -> Observable<User?> {
    return User.filter(key: id).rx.fetchOne(in: dbQueue)
  }
}
