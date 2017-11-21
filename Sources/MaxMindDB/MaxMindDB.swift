import Clibmaxminddb
import Foundation

enum MaxMindDBError: Error {
    case info(String)
}

func lookup(file: String, ip: String) throws {
    func showError(_ code: Int32) throws {
        if code != MMDB_SUCCESS {
            throw MaxMindDBError.info(String.init(cString: MMDB_strerror(code)))
        }
    }
    
    var mmdb: UnsafeMutablePointer<MMDB_s>!
    var entry_data_list: UnsafeMutablePointer<MMDB_entry_data_list_s>? = nil
    var status: Int32 = 0
    status = MMDB_open(file, UInt32(MMDB_MODE_MMAP), mmdb)
    defer {
        MMDB_free_entry_data_list(entry_data_list)
        MMDB_close(mmdb)
    }
    try showError(status)
    var gai_error: Int32 = 0
    var mmdb_error: Int32 = 0
    var result = MMDB_lookup_string(mmdb, ip, &gai_error, &mmdb_error)
    try showError(mmdb_error)
    if result.found_entry {
        status = MMDB_get_entry_data_list(&result.entry, &entry_data_list)
        try showError(status)
        if entry_data_list != nil {
            MMDB_dump_entry_data_list(stdout, entry_data_list, 2)
        }
    } else {
        throw MaxMindDBError.info("No entry for this IP address \(ip) was found")
    }
}
