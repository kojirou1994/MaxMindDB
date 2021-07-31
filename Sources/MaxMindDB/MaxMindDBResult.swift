import Foundation

public typealias MaxMindDBResultNames = [String: String]

public struct MaxMindDBResult: Decodable {

  public struct CountrySubdivisionData: Decodable {

    public let isoCode: String
    public let names: MaxMindDBResultNames
    public let geonameId: Int

    private enum CodingKeys: String, CodingKey {
      case isoCode = "iso_code"
      case names
      case geonameId = "geoname_id"
    }
  }

  public let registeredCountry: CountrySubdivisionData?

  public let subdivisions: [CountrySubdivisionData]?

  public struct City: Decodable {

    public let names: MaxMindDBResultNames
    public let geonameId: Int

    private enum CodingKeys: String, CodingKey {
      case names
      case geonameId = "geoname_id"
    }
  }

  public let city: City?

  public struct Location: Decodable {

    public let latitude: Double
    public let timeZone: String?
    public let longitude: Double
    public let accuracyRadius: Int

    private enum CodingKeys: String, CodingKey {
      case latitude
      case timeZone = "time_zone"
      case longitude
      case accuracyRadius = "accuracy_radius"
    }
  }

  public let location: Location?

  public struct Continent: Decodable {

    public let names: MaxMindDBResultNames
    public let code: String
    public let geonameId: Int

    private enum CodingKeys: String, CodingKey {
      case names
      case code
      case geonameId = "geoname_id"
    }
  }

  public let continent: Continent?

  public let country: CountrySubdivisionData?

  private enum CodingKeys: String, CodingKey {
    case registeredCountry = "registered_country"
    case subdivisions
    case city
    case location
    case continent
    case country
  }
}
