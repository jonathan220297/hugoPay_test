//
//  Profile.swift
//  Hugo
//
//  Created by Juan Jose Maceda on 12/9/16.
//  Copyright © 2016 Clever Mobile Apps. All rights reserved.
//

import Foundation
import Parse

class Profile: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Profile"
    }
    
    var name: String? {
        get { return self["name"] as? String }
        set { self["name"] = newValue }
    }
    
    var email: String? {
        get { return self["email"] as? String }
        set { self["email"] = newValue }
    }
    
    var phone: String? {
        get { return self["phone"] as? String }
        set { self["phone"] = newValue }
    }
    
    var avatar: String? {
        get { return self["avatar"] as? String }
        set { self["avatar"] = newValue }
    }
    
    var type: String? {
        get { return self["type"] as? String }
        set { self["type"] = newValue }
    }
    
    var position: String? {
        get { return self["position"] as? String }
        set { self["position"] = newValue }
    }
    
    var user: PFUser? {
        get { return self["user"] as? PFUser }
        set { self["user"] = newValue }
    }
    
    var player_id: String? {
        get { return self["player_id"] as? String }
        set { self["player_id"] = newValue }
    }
    
    var address: [[String: Any]]? {
        get { return self["address"] as? [[String: Any]] }
        set { self["address"] = newValue }
    }
    
    var enabled: Bool? {
        get { return self["enabled"] as? Bool }
        set { self["enabled"] = newValue }
    }
    
    var nit: String? {
        get { return self["nit"] as? String }
        set { self["nit"] = newValue }
    }
}
