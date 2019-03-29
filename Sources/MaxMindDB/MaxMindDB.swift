#if SWIFT_PACKAGE
@_exported import Clibmaxminddb
#endif
import Foundation

public enum MaxMindDBError: Error {
    case noEntry
    case noEntryData
    case mmdbError(String)
}

public class MaxMindDB {

    var mmdb: MMDB_s

    public init(mmdbPath: String) throws {
        mmdb = MMDB_s()
        try showError(MMDB_open(mmdbPath, UInt32(MMDB_MODE_MMAP), &mmdb))
    }

    deinit {
        MMDB_close(&mmdb)
    }

    public func lookupJSON(ip: String) throws -> String {
        let entry_data_list = try lookup(ip: ip)
        defer {
            MMDB_free_entry_data_list(entry_data_list)
        }
        return try MMDBEntryDataListParser.shared.parseJSON(list: entry_data_list)
    }

    public func lookupResult(ip: String) throws -> MaxMindDBResult {
        let entry_data_list = try lookup(ip: ip)
        defer {
            MMDB_free_entry_data_list(entry_data_list)
        }
        return try MMDBEntryDataListParser.shared.parseResult(list: entry_data_list)
    }

    private func lookup(ip: String) throws -> UnsafeMutablePointer<MMDB_entry_data_list_s> {

        var entry_data_list: UnsafeMutablePointer<MMDB_entry_data_list_s>? = nil

        var gai_error: Int32 = 0
        var mmdb_error: Int32 = 0
        var result = MMDB_lookup_string(&mmdb, ip, &gai_error, &mmdb_error)
        try showError(mmdb_error)
        guard result.found_entry else {
            throw MaxMindDBError.noEntry
        }
        try showError(MMDB_get_entry_data_list(&result.entry, &entry_data_list))
        if entry_data_list == nil {
            throw MaxMindDBError.noEntryData
        }
        return entry_data_list!
    }

    private func showError(_ code: Int32) throws {
        if code != MMDB_SUCCESS {
            throw MaxMindDBError.mmdbError(String.init(cString: MMDB_strerror(code)))
        }
    }
}
