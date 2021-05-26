import Foundation
import CMaxMindDB

public enum MMDBEntryDataListParserError: Error {
  case lackingEntryData
  case extraEntryData
  case unsupportedDataType
  case invalidString
}

extension MMDB_entry_data_s {
  var utf8String: String? {
    guard type == MMDB_DATA_TYPE_UTF8_STRING, has_data else {
      return nil
    }
    return String(decoding: Data(bytesNoCopy: UnsafeMutableRawPointer(mutating: utf8_string), count: numericCast(data_size), deallocator: .none), as: UTF8.self)
  }
}

class MMDBEntryDataListParser {
  static let shared = MMDBEntryDataListParser()

  struct ParsedResult<V> {
    let value: V
    let next: UnsafeMutablePointer<MMDB_entry_data_list_s>?
  }

  func parse(list: UnsafeMutablePointer<MMDB_entry_data_list_s>, strict: Bool = false) throws -> [String: Any] {
    precondition(numericCast(list.pointee.entry_data.type) == MMDB_DATA_TYPE_MAP)
    let result = try parseDictionary(list: list)
    if strict, result.next != nil {
      throw MMDBEntryDataListParserError.extraEntryData
    }
    return result.value
  }

  private func parseDictionary(list: UnsafeMutablePointer<MMDB_entry_data_list_s>) throws -> ParsedResult<[String: Any]> {
    var result = [String: Any]()
    var size = list.pointee.entry_data.data_size

    var currentList = list.pointee.next
    while size > 0 {
      guard let keyList = currentList, let valueData = keyList.pointee.next else {
        throw MMDBEntryDataListParserError.lackingEntryData
      }
      precondition(numericCast(keyList.pointee.entry_data.type) == MMDB_DATA_TYPE_UTF8_STRING)
      guard let key = keyList.pointee.entry_data.utf8String else {
        throw MMDBEntryDataListParserError.invalidString
      }
      let value = try parseValue(list: valueData)
      result[key] = value.value
      currentList = value.next
      size -= 1
    }
    return .init(value: result, next: currentList)
  }

  private func parseValue(list: UnsafeMutablePointer<MMDB_entry_data_list_s>) throws
  -> ParsedResult<Any> {
    switch Int32(list.pointee.entry_data.type) {
    case MMDB_DATA_TYPE_UTF8_STRING:
      guard let str = list.pointee.entry_data.utf8String else {
        throw MMDBEntryDataListParserError.invalidString
      }
      return .init(value: str, next: list.pointee.next)
    case MMDB_DATA_TYPE_BOOLEAN:
      return .init(value: list.pointee.entry_data.boolean, next: list.pointee.next)
    case MMDB_DATA_TYPE_UINT16:
      return .init(value: list.pointee.entry_data.uint16, next: list.pointee.next)
    case MMDB_DATA_TYPE_UINT32:
      return .init(value: list.pointee.entry_data.uint32, next: list.pointee.next)
    case MMDB_DATA_TYPE_DOUBLE:
      return .init(value: list.pointee.entry_data.double_value, next: list.pointee.next)
    case MMDB_DATA_TYPE_MAP:
      let dic = try parseDictionary(list: list)
      return .init(value: dic.value, next: dic.next)
    case MMDB_DATA_TYPE_ARRAY:
      var array = [Any]()
      var dataSize = list.pointee.entry_data.data_size
      array.reserveCapacity(numericCast(dataSize))
      var currentList = list.pointee.next
      while dataSize > 0 {
        guard let nextValue = currentList else {
          throw MMDBEntryDataListParserError.lackingEntryData
        }
        let value = try parseValue(list: nextValue)
        array.append(value.value)
        currentList = value.next
        dataSize -= 1
      }
      return .init(value: array, next: currentList)
    default:
      throw MMDBEntryDataListParserError.unsupportedDataType
    }
  }
}
