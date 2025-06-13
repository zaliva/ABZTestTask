import UIKit

let Persistance = PersistanceEntity.shared

class PersistanceEntity {
    
    static let shared = PersistanceEntity()
    private let defaults = UserDefaults.standard
    
    //MARK: Keys
    
    //General
    private let kIsLogin = "Persistance.kIsLogin"
    private let KLanguageCode = "Persistance.KLanguageCode"

    //Token
    private let kToken = "Persistance.kToken"
    private let kAvatarData = "Persistance.avatarData"
    
    //MARK: Values
    
    //General
    var isLogin: Bool {
        get { defaults.bool(forKey: kIsLogin) }
        set { setValue(newValue, withKey: kIsLogin) }
    }

    var languageCode: String? {
        get { defaults.string(forKey: KLanguageCode) }
        set { setValue(newValue, withKey: KLanguageCode) }
    }
 
    //Token
    var token: String? {
        get { defaults.string(forKey: kToken) }
        set { setValue(newValue, withKey: kToken) }
    }
}

extension PersistanceEntity {
    private func setValue<T>(_ value: T, withKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func clearAllUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
    
    func removeForKey(_ key: String) {
        defaults.removeObject(forKey: key)
    }
}
