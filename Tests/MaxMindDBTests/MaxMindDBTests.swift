import XCTest
@testable import MaxMindDB

class MaxMindDBTests: XCTestCase {
    let db = try! MaxMindDB(mmdbPath: "/Users/Kojirou/Downloads/GeoLite2-City_20180102/GeoLite2-City.mmdb")
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        for _ in 0..<120000 {
            do {
                _ = try db.lookupResult(ip: "\(arc4random() % 256).\(arc4random() % 256).\(arc4random() % 256).\(arc4random() % 256)")
            } catch {
                print(error)
            }
        }

    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
