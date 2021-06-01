//
//  LanguageManager.swift
//  THGCEM
//
//  Created by Nirav Jariwala on 15/11/18.
//  Copyright © 2018 Nirav Jariwala. All rights reserved.
//

import UIKit


/// Language enum
///
/// - en: language
/// - ja: language

enum Language: String {
    case en = "en"
    case es = "es"
    
}

struct UserDefaultKey
{
    static let kCurrentLanguage = "CurrentLanguage"
    static let kCurrentLanguageId = "CurrentLanguageId"
}

/// Localization language manager class
class LanguageManager: NSObject {
    static let shared = LanguageManager()
    var currentLangBundle:Bundle
    override init() {
        //UserDefaults.language.rawValue
        if Bundle.main.preferredLocalizations.first == Language.en.rawValue {
             currentLangBundle = Bundle(url: Bundle.main.url(forResource: Language.en.rawValue, withExtension: "lproj")!)!
            UserDefaults.languageString = Language.en.rawValue
        }else{
            currentLangBundle = Bundle(url: Bundle.main.url(forResource: Language.es.rawValue, withExtension: "lproj")!)!
            UserDefaults.languageString = Language.es.rawValue
        }
       
    }
    
    func saveCurrentLanguageInDefault() {
        currentLangBundle = Bundle(url: Bundle.main.url(forResource: UserDefaults.language.rawValue, withExtension: "lproj")!)!
    }
       
}

// MARK: - return localization language string
extension String {
    var localizedString: String {
        print("localizedString : \(self)")
        return LanguageManager.shared.currentLangBundle.localizedString(forKey: self, value: "", table: nil)
    }
}

// MARK: - UserDefaults
extension UserDefaults{
    static var languageString: String {
        get {
            if let lang = UserDefaults.standard.string(forKey: UserDefaultKey.kCurrentLanguage), let language = Language(rawValue: lang) {
                return Language.en.rawValue
            }
            else {
                //Set Default Language and return
                UserDefaults.standard.set(Language.en.rawValue, forKey: UserDefaultKey.kCurrentLanguage)
                return Language.es.rawValue
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.kCurrentLanguage)
        }
    }
    static var language: Language {
        get {
            if let lang = UserDefaults.standard.string(forKey: UserDefaultKey.kCurrentLanguage), let language = Language(rawValue: lang) {
                return language
            }
            else {
                //Set Default Language and return
                UserDefaults.standard.set(Language.en.rawValue, forKey: UserDefaultKey.kCurrentLanguage)
                return .es
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultKey.kCurrentLanguage)
        }
    }
    static var languageId: String {
        get {
            if let langId = UserDefaults.standard.string(forKey: UserDefaultKey.kCurrentLanguageId) {
                return langId
            }
            else {
                //Set Default Language and return
                UserDefaults.standard.set("1", forKey: UserDefaultKey.kCurrentLanguageId)
                return "1"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.kCurrentLanguageId)
        }
    }
}
