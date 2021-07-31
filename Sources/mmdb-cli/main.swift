import Foundation
import MaxMindDB
import ArgumentParser


struct MmdbCli: ParsableCommand {

  @Option
  var mmdb: String = "./GeoLite2-City.mmdb"

  @Argument
  var ip: String

  func run() throws {
    let mmdb = try MaxMindDB(mmdbPath: mmdb)

    let result = try mmdb.lookupResult(ip: ip)
    dump(result)
  }
}
