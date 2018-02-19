import XCTest
@testable import MaxMindDB

class MaxMindDBTests: XCTestCase {
    let db = try! MaxMindDB(mmdbPath: "./GeoLite2-City.mmdb")
    
    func generateRandomIP() -> String {
        #if os(macOS)
        return "\(arc4random_uniform(256)).\(arc4random_uniform(256)).\(arc4random_uniform(256)).\(arc4random_uniform(256))"
        #elseif os(Linux)
        return "\(random() % (256)).\(random() % (256)).\(random() % (256)).\(random() % (256))"
        #endif
    }
    
    func testDB() {
        
        
        for _ in 0..<120000 {
            do {
                _ = try db.lookupResult(ip: generateRandomIP())
            } catch {
                print(error)
            }
        }

    }

    static var allTests = [
        ("testExample", testDB),
    ]
}
