//import Apollo
import GRDB

// TODO fetch error /

enum LocalUserServiceError: Error {
  case creationFailed
  case updateFailed(User)
  case deletionFailed(User)
}

protocol LocalUserServiceType {
  func createUser(id: Int64, handle: String, callback: @escaping (Result<User, AnyError>) -> Void)

  // TODO need it?
  func delete(user: User, callback: @escaping () -> Void)
  func update(user: User, handle: String, callback: @escaping (User) -> Void)

  // TODO use Result
  func listUsers(callback: @escaping (Result<[User], AnyError>) -> Void)
  func getUser(id: Int64, callback: @escaping (Result<User?, AnyError>) -> Void)

  // TODO callback: ([User]) -> Void
//  func remoteUserSearch(query: String, callback: @escaping (UsersQuery.Data) -> Void)
}

final class LocalUserService: UserServiceType {
  private let dbQueue: DatabaseQueue

  init(dbPool: DatabasePool) {
    self.dbPool = dbPool
  }

  func createUser(id: Int64, handle: String, callback: @escaping (Result<User, AnyError>) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        let user = try self.dbQueue.write { try User(id: id, handle: handle).insert(db) }
        DispatchQueue.main.async { callback(.success(user)) }
      } catch {
        // TODO log error
        print("Failed to create user (id: \(id), handle: \(handle)) with error: \(error.localizedDescription)")
        DispatchQueue.main.async { callback(.failure(AnyError(LocalUserServiceError.creationFailed))) }
      }
    }
  }

  func delete(user: User, callback: @escaping () -> Void) {
    // TODO
  }

  func update(user: User, handle: String, callback: @escaping (User) -> Void) {
    // TODO
  }

  // TODO can be a box?
  // service.savedUsers: Box<[User]> computed property
  func savedUsers(callback: @escaping (Result<[User], AnyError>) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        let savedUsers = try self.dbQueue.read { try User.fetchAll($0) }
        DispatchQueue.main.async { callback(.success(savedUsers)) }
      } catch {
        DispatchQueue.main.async { callback(.failure(AnyError(error))) }
      }
    }
  }

  func localGetUser(id: Int64, callback: @escaping (Result<User?, AnyError>) -> Void) {
    // TODO correct qos?
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        let user = try self.dbQueue.read { try User.fetchOne($0, key: id) }
        DispatchQueue.main.async { callback(.success(user)) }
      } catch {
        DispatchQueue.main.async { callback(.failure(AnyError(error))) }
      }
    }
  }

//  func remoteUserSearch(query: String, callback: @escaping (UsersQuery.Data) -> Void) {
//    // TODO
//  }
}
