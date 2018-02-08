//
//  MaxMindDBResult.swift
//  MaxMindDB
//
//  Created by Kojirou on 2018/2/7.
//

import Foundation

public struct MaxMindDBResult: Codable {

    public struct RegisteredCountry: Codable {

        public var isoCode: String

        public struct Names: Codable {

            public var ja: String?

            public var zh_CN: String?

            public var pt_BR: String?

            public var en: String

            public var ru: String?

            public var es: String?

            public var de: String?

            public var fr: String?

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

        public var names: Names

        public var geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case isoCode = "iso_code"
            case names
            case geonameId = "geoname_id"
        }

    }

    public var registeredCountry: RegisteredCountry?

    public struct Subdivisions: Codable {

        public var isoCode: String

        public struct Names: Codable {

            public var fr: String?

            public var zh_CN: String?

            public var en: String

            private enum CodingKeys: String, CodingKey {
                case fr
                case zh_CN = "zh-CN"
                case en
            }

        }

        public var names: Names

        public var geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case isoCode = "iso_code"
            case names
            case geonameId = "geoname_id"
        }

    }

    public var subdivisions: [Subdivisions]?

    public struct City: Codable {

        public struct Names: Codable {

            public var ja: String?

            public var zh_CN: String?

            public var pt_BR: String?

            public var en: String

            public var ru: String?

            public var es: String?

            public var de: String?

            public var fr: String?

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

        public var names: Names

        public var geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case names
            case geonameId = "geoname_id"
        }

    }

    public var city: City?

    public struct Location: Codable {

        public var latitude: Double

        public var timeZone: String?

        public var longitude: Double

        public var accuracyRadius: Int

        private enum CodingKeys: String, CodingKey {
            case latitude
            case timeZone = "time_zone"
            case longitude
            case accuracyRadius = "accuracy_radius"
        }

    }

    public var location: Location?

    public struct Continent: Codable {

        public struct Names: Codable {

            public var ja: String?

            public var zh_CN: String?

            public var pt_BR: String?

            public var en: String

            public var ru: String?

            public var es: String?

            public var de: String?

            public var fr: String?

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

        public var names: Names

        public var code: String

        public var geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case names
            case code
            case geonameId = "geoname_id"
        }

    }

    public var continent: Continent?

    public struct Country: Codable {

        public var isoCode: String

        public struct Names: Codable {

            public var ja: String?

            public var zh_CN: String?

            public var pt_BR: String?

            public var en: String

            public var ru: String?

            public var es: String?

            public var de: String?

            public var fr: String?

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

        public var names: Names

        public var geonameId: Int

        private enum CodingKeys: String, CodingKey {
            case isoCode = "iso_code"
            case names
            case geonameId = "geoname_id"
        }

    }

    public var country: Country?

    private enum CodingKeys: String, CodingKey {
        case registeredCountry = "registered_country"
        case subdivisions
        case city
        case location
        case continent
        case country
    }

}

