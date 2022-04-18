/*
*   Abstract: Environment values to use with SwiftUI.
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
import SwiftUI

public struct DeeplinkKey: EnvironmentKey {
    public static var defaultValue: Deeplinker.Deeplink? {
        return nil
    }
}

extension EnvironmentValues {
    public var deeplink: Deeplinker.Deeplink? {
        get {
            self[DeeplinkKey.self]
        }
        set {
            self[DeeplinkKey.self] = newValue
        }
    }
}

