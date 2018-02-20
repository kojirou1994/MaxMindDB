import XCTest
@testable import MaxMindDB

class MaxMindDBTests: XCTestCase {
    let cityDB = try! MaxMindDB(mmdbPath: "./GeoLite2-City.mmdb")
    let countryDB = try! MaxMindDB(mmdbPath: "./GeoLite2-Country.mmdb")
    
    func generateRandomIP() -> String {
        #if os(macOS)
        return "\(arc4random_uniform(256)).\(arc4random_uniform(256)).\(arc4random_uniform(256)).\(arc4random_uniform(256))"
        #elseif os(Linux)
        return "\(random() % (256)).\(random() % (256)).\(random() % (256)).\(random() % (256))"
        #endif
    }
    
    func testCountryDB() {
        for _ in 0..<120000 {
            do {
                _ = try countryDB.lookupResult(ip: generateRandomIP())
            } catch {
//                print(error)
            }
        }
    }
    
    func testCityDB() {
        for _ in 0..<120000 {
            do {
                _ = try cityDB.lookupResult(ip: generateRandomIP())
            } catch {
//                print(error)
            }
        }
    }

    static var allTests = [
        ("testCountryDB", testCountryDB),
        ("testCityDB", testCityDB)
    ]
}
