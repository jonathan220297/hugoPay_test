//
//  TypeAliases.swift
//  Hugo
//
//  Created by Developer on 6/10/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import Foundation

public typealias myParams = Dictionary<String, Any>
public typealias boolResponse = (_ success: Bool) -> ()
public typealias messageResponse = (_ success: Bool, _ message: String) -> ()

func createNewParams() -> myParams {
    var params = Dictionary<String, Any>()
    params["app"] = "IOS"
    params["build"] = buildVersion()
    params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
    
    return params
}

func createVersioningParams(version: Int) -> myParams {
    var params = Dictionary<String, Any>()
    params["app"] = "IOS"
    params["api"] = "V\(version)"
    params["build"] = buildVersion()
    params["lang"]   = UserDefaults.standard.object(forKey: UserDefaultKey.kCurrentLanguage)
    
    return params
}
