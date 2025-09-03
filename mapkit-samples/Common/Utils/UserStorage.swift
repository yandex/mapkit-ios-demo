import Foundation

final class UserStorage {
    private enum Keys {
        static let isCellularNetwork = "Is cellular network"
        static let isAutoUpdate = "Is auto update"
    }

    static var isCellularNetwork: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isCellularNetwork)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isCellularNetwork)
        }
    }

    static var isAutoUpdate: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isAutoUpdate)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isAutoUpdate)
        }
    }
}
