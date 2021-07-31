import CMaxMindDB
import DictionaryCoding
import Foundation

public enum MaxMindDBError: Error, CustomStringConvertible {
  case noEntry
  case noEntryData
  case gaiError(CInt)
  case mmdbError(String)

  public var description: String {
    switch self {
    case .noEntry:
      return "No entry."
    case .noEntryData:
      return "No entry data."
    case .gaiError(let error):
      return "Error from getaddrinfo: \(error)."
    case .mmdbError(let info):
      return "Error from libmaxminddb: \(info)."
    }
  }
}

public final class MaxMindDB {

  public static let version = PACKAGE_VERSION

  private var mmdb: MMDB_s

  public init(mmdbPath: String) throws {
    mmdb = MMDB_s()
    try showError(MMDB_open(mmdbPath, numericCast(MMDB_MODE_MMAP), &mmdb))
  }

  public convenience init(mmdbURL: URL) throws {
    assert(mmdbURL.isFileURL)
    try self.init(mmdbPath: mmdbURL.path)
  }

  deinit {
    MMDB_close(&mmdb)
  }

  public func lookupJSON(ip: String) throws -> [String: Any] {
    let entry_data_list = try lookup(ip: ip)
    defer {
      MMDB_free_entry_data_list(entry_data_list)
    }
    return try MMDBEntryDataListParser.parse(list: entry_data_list)
  }

  public func lookupResult(ip: String) throws -> MaxMindDBResult {
    let dic = try lookupJSON(ip: ip)
    let decoder = DictionaryDecoder()
    return try decoder.decode(MaxMindDBResult.self, from: dic)
  }

  public func lookupJSON(saddr: inout sockaddr) throws -> [String: Any] {
    let entry_data_list = try lookup(saddr: &saddr)
    defer {
      MMDB_free_entry_data_list(entry_data_list)
    }
    return try MMDBEntryDataListParser.parse(list: entry_data_list)
  }

  public func lookupResult(saddr: inout sockaddr) throws -> MaxMindDBResult {
    let dic = try lookupJSON(saddr: &saddr)
    let decoder = DictionaryDecoder()
    return try decoder.decode(MaxMindDBResult.self, from: dic)
  }

  internal func lookup(ip: String) throws -> UnsafeMutablePointer<MMDB_entry_data_list_s> {

    var gaiError: CInt = 0
    var mmdbError: CInt = 0
    var result = MMDB_lookup_string(&mmdb, ip, &gaiError, &mmdbError)
    if gaiError != 0 {
      throw MaxMindDBError.gaiError(gaiError)
    }
    try showError(mmdbError)

    return try getEntryDataList(result: &result)
  }

  internal func lookup(saddr: UnsafePointer<sockaddr>) throws -> UnsafeMutablePointer<MMDB_entry_data_list_s> {

    var mmdbError: CInt = 0
    var result = MMDB_lookup_sockaddr(&mmdb, saddr, &mmdbError)
    try showError(mmdbError)

    return try getEntryDataList(result: &result)
  }

  func getEntryDataList(result: inout MMDB_lookup_result_s) throws -> UnsafeMutablePointer<MMDB_entry_data_list_s> {
    guard result.found_entry else {
      throw MaxMindDBError.noEntry
    }

    var entryDataList: UnsafeMutablePointer<MMDB_entry_data_list_s>?
    try showError(MMDB_get_entry_data_list(&result.entry, &entryDataList))

    guard let list = entryDataList else {
      throw MaxMindDBError.noEntryData
    }

    return list
  }

  func showError(_ code: Int32) throws {
    if code != MMDB_SUCCESS {
      throw MaxMindDBError.mmdbError(String(cString: MMDB_strerror(code)))
    }
  }
}
