/*
*   Abstract: The package's main source file.
*   Copyright (C) 2022 Alejandro Modroño Vara <alex@sureservice.es>
*
*   This program is free software: you can redistribute it and/or
*   modify it under the terms of the GNU General Public License as
*   published by the Free Software Foundation, either version 3 of
*   the License, or (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program. If not, see <https://www.gnu.org/licenses/>.
*/
import Foundation
import os

/// The class in charge of all the Deep-linking process.
/// For a detailed explanation of how this works, go to `Deeplinker.swift`
public class Deeplinker {

    /// The types of deeplinks that the application expects.
    public enum Deeplink: Equatable, CaseIterable {

        public static var allCases: [Deeplinker.Deeplink] {
            return [.home, .oauth(code: ""), .profile(id: "")]
        }

        case home
        case oauth(code: String)
        case profile(id: String)

        /// The keyword of the deeplink.
        public var description: String {
            switch self {
            case .home:
                return "home"
            case .oauth:
                return "oauth"
            case .profile:
                return "profile"
            }
        }

        var expectsAssociatedValues: Int? {
            switch self {
            case .home:
                return nil
            case .oauth:
                return 1
            case .profile:
                return 1
            }
        }
        
    }

    /// A singleton everybody can access to.
    static public let shared = Deeplinker()

    /// The class' main logger.
    public static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Deeplinker.self)
    )

    static public var urlPrefix: String = "deeplinker"

    public func manage(url: URL) throws -> Deeplink {

        guard url.scheme == Deeplinker.urlPrefix else {
            throw DeeplinkError.unknownScheme(received: url.scheme)
        }

        for deeplink in Deeplink.allCases {
            if deeplink.description == url.host {

                //  We check that there are no other query parameters
                guard let queryItems = url.queryParameters else {

                    //  We make sure that the deeplink was not expecting any
                    //  parameter, and if so, we return the deeplink.
                    //
                    //  If the deeplink was actually expecting them, we return
                    //  error.
                    guard let values = deeplink.expectsAssociatedValues else {
                        return deeplink
                    }

                    throw DeeplinkError.expectedQueryParameters(expecting: values, received: 0)
                }

                //  Now, we make sure that the deeplink was actually expecting
                //  parameters, or else we return an error.
                guard deeplink.expectsAssociatedValues != nil else {
                    throw DeeplinkError.expectedQueryParameters(expecting: 0, received: queryItems.count)
                }

                switch url.host {
                case "oauth":
                    guard let code = queryItems.first(where: { $0.key == "code" })?.value else {
                        throw DeeplinkError.unknownQueryParameter(expecting: "code")
                    }
                    return .oauth(code: code)
                case "profile":
                    guard let id = queryItems.first(where: { $0.key == "id" })?.value else {
                        throw DeeplinkError.unknownQueryParameter(expecting: "id")
                    }
                    return .profile(id: id)
                default:
                    throw DeeplinkError.unknownDeeplink(received: url.host)
                }
            }

        }

        throw DeeplinkError.unknownDeeplink(received: url.host)

    }

    /// Refreshes a deeplink
    public func refresh(_ deeplink: inout Deeplink?) {

        //  It is important to reset the deeplink or else if a user opens
        //  the same link twice, it won't work.

        deeplink = nil
    }

    public func setRequestPrefix(to urlPrefix: String) {
        Deeplinker.logger.info("URL prefix changed from \(Deeplinker.urlPrefix) to \(urlPrefix).")
        Deeplinker.urlPrefix = urlPrefix
    }

}

