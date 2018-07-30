import XCTest
@testable import TRAppProxy
import GRDB

class LocalUserServicePerformanceTest: XCTestCase {
  var userService: LocalUserServiceType!
  var dbQueue: DatabaseQueue!

  override func setUp() {
    super.setUp()
    dbQueue = try! AppDatabase.openDatabase(.onDisk(path: ""))
    userService = LocalUserService(dbQueue: dbQueue)
  }

  func testUsers_listPerformance() {
    try! (1...3600).forEach { id in
      _ = try User.fixture(dbQueue: dbQueue, attrs: ["id": id, "handle": "user #\(id)"])
    }

    let expectation = XCTestExpectation(description: "listUsers")

    measure {
      userService.listUsers { _ in expectation.fulfill() }
      wait(for: [expectation], timeout: 10.0)
    }
  }
}
