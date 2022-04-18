/*
*   Abstract: Errors thrown when the deeplinking process fails.
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

public enum DeeplinkError: Error {

    // Thrown when the received scheme does not match with the specified scheme.
    case unknownScheme(received: String?)

    // Thrown when the received link is not defined in the Deeplink enum.
    case unknownDeeplink(received: String?)

    // Thrown when the received link should have query parameters but none, or not enough
    // were passed.
    case expectedQueryParameters(expecting: Int, received: Int)

    // Thrown when an unknown query parameter is passed.
    case unknownQueryParameter(expecting: String)

    // Throw when an expected resource is not found
    case notFound

    // Throw in all other cases
    case unexpected(code: Int)
}

extension DeeplinkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknownScheme(let received):
            return "The received scheme (\"\(received ?? "undefined")\") does not match with the one specified."
        case .unknownDeeplink(let received):
            return "The received link \(received != nil ? "(\"\(received ?? "undefined")\")" : "") does not match with any of the ones defined in the Deeplink enum."
        case .expectedQueryParameters(let count, let received):
            return "The received link should have \(count) query parameters, but \(count > received ? "only" : "") \(received) \(received == 1 ? "was" : "were") received."
        case .unknownQueryParameter(let expecting):
            return "The deeplink expects at least a query parameter named \"\(expecting)\"."
        case .notFound:
            return "The specified item could not be found."
        case .unexpected(let code):
            return "An unexpected error occurred. Code: \(code)."
        }
    }
}

