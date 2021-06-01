//
//  BiometricType.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 7/7/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation
import LocalAuthentication

public func biometricType() -> BiometricType {
    let authContext = LAContext()
    if #available(iOS 11, *) {
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        default:
            return .none
        }
    } else {
        return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none

    }
}

public enum BiometricType {
    case none
    case touch
    case face
}
