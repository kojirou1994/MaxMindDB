import Foundation

public struct MaxMindDBResult: Codable {
    public struct RegisteredCountry: Codable {
        public let isoCode: String

        public struct Names: Codable {
            public let ja: String?

            public let zh_CN: String?

            public let pt_BR: String?

            public let en: String

            public let ru: String?

            public let es: String?

            public let de: String?

            public let fr: String?

            private enum CodingKeys: String, CodingKey {
                case ja
                case zh_CN = "zh-CN"
                case pt_BR = "pt-BR"
                case en
                case ru
                case es
                case de
                case fr
            }
        }

        public let names: Names

        public let geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case isoCode = "iso_code"
            case names
            case geonameId = "geoname_id"
        }
    }

    public let registeredCountry: RegisteredCountry?

    public struct Subdivisions: Codable {
        public let isoCode: String

        public struct Names: Codable {
            public let fr: String?

            public let zh_CN: String?

            public let en: String

            private enum CodingKeys: String, CodingKey {
                case fr
                case zh_CN = "zh-CN"
                case en
            }
        }

        public let names: Names

        public let geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case isoCode = "iso_code"
            case names
            case geonameId = "geoname_id"
        }
    }

    public let subdivisions: [Subdivisions]?

    public struct City: Codable {
        public struct Names: Codable {
            public let ja: String?

            public let zh_CN: String?

            public let pt_BR: String?

            public let en: String

            public let ru: String?

            public let es: String?

            public let de: String?

            public let fr: String?

            private enum CodingKeys: String, CodingKey {
                case ja
                case zh_CN = "zh-CN"
                case pt_BR = "pt-BR"
                case en
                case ru
                case es
                case de
                case fr
            }
        }

        public let names: Names

        public let geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case names
            case geonameId = "geoname_id"
        }
    }

    public let city: City?

    public struct Location: Codable {
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

    public struct Continent: Codable {
        public struct Names: Codable {
            public let ja: String?

            public let zh_CN: String?

            public let pt_BR: String?

            public let en: String

            public let ru: String?

            public let es: String?

            public let de: String?

            public let fr: String?

            private enum CodingKeys: String, CodingKey {
                case ja
                case zh_CN = "zh-CN"
                case pt_BR = "pt-BR"
                case en
                case ru
                case es
                case de
                case fr
            }
        }

        public let names: Names

        public let code: String

        public let geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case names
            case code
            case geonameId = "geoname_id"
        }
    }

    public let continent: Continent?

    public struct Country: Codable {
        public let isoCode: String

        public struct Names: Codable {
            public let ja: String?

            public let zh_CN: String?

            public let pt_BR: String?

            public let en: String

            public let ru: String?

            public let es: String?

            public let de: String?

            public let fr: String?

            private enum CodingKeys: String, CodingKey {
                case ja
                case zh_CN = "zh-CN"
                case pt_BR = "pt-BR"
                case en
                case ru
                case es
                case de
                case fr
            }
        }

        public let names: Names

        public let geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case isoCode = "iso_code"
            case names
            case geonameId = "geoname_id"
        }
    }

    public let country: Country?

    private enum CodingKeys: String, CodingKey {
        case registeredCountry = "registered_country"
        case subdivisions
        case city
        case location
        case continent
        case country
    }
}
