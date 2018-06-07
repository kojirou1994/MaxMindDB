import Foundation
import MaxMindDB

func usage() {
    print("MaxMindDB-cli [ip] [mmdb]")
}

guard CommandLine.argc > 1 else {
    print("No input!")
    exit(1)
}

let ip = CommandLine.arguments[1]
let mmdbPath: String
if CommandLine.argc > 2 {
    mmdbPath = CommandLine.arguments[2]
} else {
    mmdbPath = "./GeoLite2-City.mmdb"
}

let mmdb = try MaxMindDB.init(mmdbPath: mmdbPath)

do {
    let result = try mmdb.lookupResult(ip: ip)
    dump(result)
} catch MaxMindDBError.noEntry {
    print("No Entry for IP: \(ip).")
} catch MaxMindDBError.noEntryData {
    print("No Data for IP: \(ip).")
} catch MaxMindDBError.mmdbError(let info) {
    print("MMDB Error: \(info).")
} catch {
    print(error)
}
