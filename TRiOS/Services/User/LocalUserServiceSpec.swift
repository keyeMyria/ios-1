// swiftlint:disable force_try identifier_name
import Quick
import Nimble
import GRDB

@testable import TRAppProxy

class LocalUserServiceSpec: QuickSpec {
  override func spec() {
    var dbQueue: DatabaseQueue!
    var userService: LocalUserServiceType!

    describe("persisted users") {
      beforeEach {
        dbQueue = try! AppDatabase.openDatabase(.inMemory)
        userService = LocalUserService(dbQueue: dbQueue)
      }

      it("gets user by id") {
        let u1 = try! User.fixture(dbQueue: dbQueue)

        userService.getUser(id: u1.id) { result in
          // TODO cleaner way?
          if case let .success(value: maybeFetchedUser) = result, let fetchedUser = maybeFetchedUser {
            expect(fetchedUser.id) == u1.id
            expect(fetchedUser.insertedAt).toNot(beNil())
          } else {
            fail("invalid result \(result)")
          }
        }

        // TODO fetch non existent
      }

      it("lists all saved users") {
        // TODO
        //        let savedRuns = (10 * Run.self).insert(self.dbQueue)
        //        let savedRuns = 10.of(Run.self).insert(in: self.dbQueue)

        let u1 = try! User.fixture(dbQueue: dbQueue)
        let u2 = try! User.fixture(dbQueue: dbQueue)
        let u3 = try! User.fixture(dbQueue: dbQueue)

        let fakeUsers = [u1, u2, u3]

        userService.listUsers { result in
          if case let .success(value: listedUsers) = result {
            expect(listedUsers.map { $0.id }) == fakeUsers.map { $0.id }
          } else {
            fail("invalid result \(result)")
          }
        }
      }
    }
  }
}
