import CMaxMindDB
import DictionaryCoding
import Foundation

public enum MaxMindDBError: Error {
    case noEntry
    case noEntryData
    case mmdbError(String)
}

public class MaxMindDB {
    private var mmdb: MMDB_s

    public init(mmdbPath: String) throws {
        mmdb = MMDB_s()
        try showError(MMDB_open(mmdbPath, UInt32(MMDB_MODE_MMAP), &mmdb))
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
        return try MMDBEntryDataListParser.shared.parse(list: entry_data_list)
    }

    public func lookupResult(ip: String) throws -> MaxMindDBResult {
        let dic = try lookupJSON(ip: ip)
        let decoder = DictionaryDecoder()
        return try decoder.decode(MaxMindDBResult.self, from: dic)
    }

    internal func lookup(ip: String) throws -> UnsafeMutablePointer<MMDB_entry_data_list_s> {
        var entry_data_list: UnsafeMutablePointer<MMDB_entry_data_list_s>?

        var gai_error: Int32 = 0
        var mmdb_error: Int32 = 0
        var result = MMDB_lookup_string(&mmdb, ip, &gai_error, &mmdb_error)
        try showError(mmdb_error)
        guard result.found_entry else {
            throw MaxMindDBError.noEntry
        }
        try showError(MMDB_get_entry_data_list(&result.entry, &entry_data_list))
        guard let list = entry_data_list else {
            throw MaxMindDBError.noEntryData
        }
        return list
    }

    @inlinable
    func showError(_ code: Int32) throws {
        if code != MMDB_SUCCESS {
            throw MaxMindDBError.mmdbError(String(cString: MMDB_strerror(code)))
        }
    }
}
