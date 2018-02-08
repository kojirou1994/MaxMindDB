//
//  MMDBEntryDataListParser.swift
//  MaxMindDB
//
//  Created by Kojirou on 2018/2/5.
//

import Foundation
import Clibmaxminddb

public enum MMDBEntryDataListParserError: Error {
    case lackingEntryData
    case extraEntryData
    case unsupportedDataType
}

extension MMDB_entry_data_s {

    var utf8String: String? {
        guard type == MMDB_DATA_TYPE_UTF8_STRING, has_data,
            let stringValue = String.init(bytes: Data.init(bytes: UnsafeRawPointer(utf8_string), count: Int(data_size)), encoding: .utf8) else {
                return nil
        }
        return stringValue
    }
}

class MMDBEntryDataListParser {

    static let shared = MMDBEntryDataListParser()

    func parse(list: UnsafeMutablePointer<MMDB_entry_data_list_s>, strict: Bool = false) throws -> Any {
        let result = try dumpList(list: list)
        if strict, result.1 != nil {
            throw MMDBEntryDataListParserError.extraEntryData
        }
        return result.0
    }

    func parseJSON(list: UnsafeMutablePointer<MMDB_entry_data_list_s>, strict: Bool = false) throws -> String {
        var json = ""
        let last = try dumpList(list: list, to: &json)
        if strict, last != nil {
            throw MMDBEntryDataListParserError.extraEntryData
        }
        return json
    }

    func parseResult(list: UnsafeMutablePointer<MMDB_entry_data_list_s>, strict: Bool = false) throws -> MaxMindDBResult {
        var json = ""
        let last = try dumpList(list: list, to: &json)
        if strict, last != nil {
            throw MMDBEntryDataListParserError.extraEntryData
        }
        #if os(Linux)
        return try JSONDecoder().decode(MaxMindDBResult.self, from: json.data(using: .utf8)!)
        #else
        return try autoreleasepool { () -> MaxMindDBResult in
            return try JSONDecoder().decode(MaxMindDBResult.self, from: json.data(using: .utf8)!)
        }
        #endif
    }

    private func dumpList(list: UnsafeMutablePointer<MMDB_entry_data_list_s>) throws
        -> (Any, UnsafeMutablePointer<MMDB_entry_data_list_s>?) {
            let entryData = list.pointee.entry_data
            switch Int32(entryData.type) {
            case MMDB_DATA_TYPE_MAP:
//                print("Map size: \(entryData.data_size)")
                var result = [String: Any]()
                var size = entryData.data_size
                var next = list.pointee.next
                while size > 0 {
                    guard next != nil, let valueP = next!.pointee.next else {
                        throw MMDBEntryDataListParserError.lackingEntryData
                    }
                    let key = next!.pointee.entry_data.utf8String!
                    let value = try dumpList(list: valueP)
                    result[key] = value.0
                    next = value.1
                    size -= 1
                }
                return (result, next)
            case MMDB_DATA_TYPE_UTF8_STRING:
//                print("\(entryData.utf8String!) <utf8-string>")
                return (entryData.utf8String!, list.pointee.next)
            case MMDB_DATA_TYPE_UINT32:
//                print("\(entryData.uint32) <uint32>")
                return (entryData.uint32, list.pointee.next)
            case MMDB_DATA_TYPE_DOUBLE:
//                print("\(entryData.double_value) <double>")
                return (entryData.double_value, list.pointee.next)
            case MMDB_DATA_TYPE_UINT16:
//                print("\(entryData.uint16) <uint16>")
                return (entryData.uint16, list.pointee.next)
            case MMDB_DATA_TYPE_ARRAY:
//                print("Array size: \(entryData.data_size)")
                var array = [Any]()
                var size = entryData.data_size
                var next = list.pointee.next
                while size > 0 {
                    guard next != nil else {
                        throw MMDBEntryDataListParserError.lackingEntryData
                    }
                    let value = try dumpList(list: next!)
                    array.append(value.0)
                    next = value.1
                    size -= 1
                }
                return (array, next)
            case MMDB_DATA_TYPE_BOOLEAN:
//                print("\(entryData.boolean) <boolean>")
                return (entryData.boolean, list.pointee.next)
            default:
                throw MMDBEntryDataListParserError.unsupportedDataType
            }
    }

    private func dumpList(list: UnsafeMutablePointer<MMDB_entry_data_list_s>, to json: inout String) throws
        -> UnsafeMutablePointer<MMDB_entry_data_list_s>? {
            let entryData = list.pointee.entry_data
            switch Int32(entryData.type) {
            case MMDB_DATA_TYPE_MAP:
                json += "{"
                var size = entryData.data_size
                var next = list.pointee.next
                while size > 0 {
                    guard next != nil, let valueP = next!.pointee.next else {
                        throw MMDBEntryDataListParserError.lackingEntryData
                    }
                    let key = next!.pointee.entry_data.utf8String!
                    json += "\"\(key)\":"
                    next = try dumpList(list: valueP, to: &json)
                    size -= 1
                    if size > 0 {
                        json += ","
                    }
                }
                json += "}"
                return next
            case MMDB_DATA_TYPE_UTF8_STRING:
                json += "\"\(entryData.utf8String!)\""
                return list.pointee.next
            case MMDB_DATA_TYPE_UINT32:
                json += entryData.uint32.description
                return list.pointee.next
            case MMDB_DATA_TYPE_DOUBLE:
                json += entryData.double_value.description
                return list.pointee.next
            case MMDB_DATA_TYPE_UINT16:
                json += entryData.uint16.description
                return list.pointee.next
            case MMDB_DATA_TYPE_ARRAY:
                json += "["
                var size = entryData.data_size
                var next = list.pointee.next
                while size > 0 {
                    guard next != nil else {
                        throw MMDBEntryDataListParserError.lackingEntryData
                    }
                    next = try dumpList(list: next!, to: &json)
                    size -= 1
                    if size > 0 {
                        json += ","
                    }
                }
                json += "]"
                return next
            case MMDB_DATA_TYPE_BOOLEAN:
                json += entryData.boolean.description
                return list.pointee.next
            default:
                throw MMDBEntryDataListParserError.unsupportedDataType
            }
    }
}
