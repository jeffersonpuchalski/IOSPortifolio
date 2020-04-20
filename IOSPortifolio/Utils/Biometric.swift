//
//  Biometric.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 18/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

/// Biometric delegate for responses from LAContext.
protocol BiometricDelegate {
    /**
     Check if we can access authentication police.
     - Parameters:
     - error: A `NSError` result from check parameter,
     if this is null, we dont have enough perimission to use biometric.
     */
    func policyValidationResult(_ error: NSError?)
    /**
     Validate if user's biometric is valid and match.
     
     If we have permission and user's biometric match. we delegate this method.
     */
    func authenticationSuccess()
    /**
     Called when user or device has error to validate biometric.
     
     If user's authentication is falied and something goes wrongs, we delegate this method.
     */
    func authenticationError(errorMessage: String)
}
/// Class for holding all biometric events in device
class Biometric {
    
    var authError: NSError?
    var delegate: BiometricDelegate?
    
    /**
     Authenticate user with his fingerprint or face.
     */
    func authenticationWithTouchID() -> Void {
        // Instanciate localk authentication and config LAContext
        let localAuthenticationContext = LAContext()
        let reasonString = "To access the secure data"
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        // Check policy and delegate results
        authError = canAuthenticateByTouchId(for: localAuthenticationContext)
        self.delegate?.policyValidationResult(authError)
        
        if authError == nil {
            return
        }
        // Try auth with user biometric.
        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,localizedReason: reasonString) {
            (sucess, error) in
                if sucess {
                    self.delegate?.authenticationSuccess()
                }
                switch error {
                case LAError.authenticationFailed?:
                    self.delegate?.authenticationError(errorMessage: "Não conseguimos verificar a sua digital.")
                    
                case LAError.userCancel?:
                    self.delegate?.authenticationError(errorMessage: "Usuário(a) cancelou está operação.")
                    
                case LAError.userFallback?:
                    self.delegate?.authenticationError(errorMessage: "Usuário(a) cancelou está operação digitando um password.")
                    
                case LAError.biometryNotAvailable?:
                    self.delegate?.authenticationError(errorMessage: "Face ID/Touch ID não disponível para esse aparelho.")
                    
                case LAError.biometryNotEnrolled?:
                    self.delegate?.authenticationError(errorMessage: "Face ID/Touch ID não está cadastrado para esse dispositivo.")
                    
                case LAError.biometryLockout?:
                    self.delegate?.authenticationError(errorMessage: "Ocorreu muitas tentativas para uso, por favor tente usar o passcode.")
                    
                default:
                    self.delegate?.authenticationError(errorMessage: "Occoreu um erro desconhecido, tente novamente mais tarde.")
                }
        }
    }
    
    /**
     Check if we can authenticate by using Touch / Face id.
     - Returns:
     True if device is able to authenticate, otherwise not.
     */
    private func canAuthenticateByTouchId(for localAuthenticationContext: LAContext) -> NSError?{
        var authError: NSError?
        localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
        return authError
    }
    
}
