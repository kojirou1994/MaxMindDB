import XCTest
@testable import MaxMindDB

class MaxMindDBTests: XCTestCase {
  let testDB = try! MaxMindDB(mmdbPath: #filePath.dropLast(#fileID.count) + "../GeoLite2-City.mmdb")
  let ip = "223.5.5.5"

  func testGetResult() {
    XCTAssertNoThrow(try testDB.lookupResult(ip: ip))
    measure {
      _ = try! testDB.lookupResult(ip: ip)
    }
  }

  func testGetJSON() {
    XCTAssertNoThrow(try testDB.lookupJSON(ip: ip))
    measure {
      _ = try! testDB.lookupJSON(ip: ip)
    }
  }
}
