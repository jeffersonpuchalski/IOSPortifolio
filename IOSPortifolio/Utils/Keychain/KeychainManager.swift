//
//  KeychainManager.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 19/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import Foundation

protocol KeychainManagerProtocol {
    var bundleName: String { get }
    func save(_ value: String, forKey key: String) -> Bool
    func load( forKey key: String) -> String
    
    func saveCrypto(_ value: String, forKey key: String)throws -> Bool
    func loadCrypto<T: AnyObject>(forKey key: String)throws -> T
}



class KeychainManager: KeychainManagerProtocol {
    
    var bundleName: String = Bundle.main.bundleIdentifier ?? ""
    
    func load(forKey key: String) -> String {
        let query: [String: AnyObject] = [
             kSecClass as String       : kSecClassGenericPassword as NSString,
             kSecMatchLimit as String  : kSecMatchLimitOne,
             kSecReturnData as String  : kCFBooleanTrue,
             kSecAttrService as String : self.bundleName as AnyObject,
             kSecAttrAccount as String : key as AnyObject
           ]
           
            
            var result: AnyObject?
            let status: OSStatus = withUnsafeMutablePointer(to: &result){
                SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
            }
        if status != noErr {
            print("Error while loading key.")
            return ""
            
        }
        return String(data: result as! Data, encoding: String.Encoding.utf8)!
    }
    
    func save(_ value: String, forKey key: String) -> Bool {
        // create Default dictonary for key
        let query: [String: AnyObject] = [
          kSecClass as String       : (kSecClassGenericPassword as NSString),
          kSecAttrAccount as String : key as AnyObject,
          kSecAttrService as String : self.bundleName as AnyObject,
          kSecValueData as String   : value.data(using: String.Encoding.utf8, allowLossyConversion: false)! as AnyObject
        ]
        // Delete any keys if exsist.
        _  =  SecItemDelete(query as CFDictionary)
        
        // Get result and validate if we got error.
        var result: AnyObject?
        let status: OSStatus = withUnsafeMutablePointer(to: &result){
            SecItemAdd(query as CFDictionary, UnsafeMutablePointer($0))
        }
        if status == noErr{
            return true
        } else {
            return false
        }
    }
    
    func saveCrypto(_ value: String, forKey key: String) throws -> Bool {
        // Get a tag for key and create a new RSA key
        let tag = "\(bundleName).keys.password".data(using: .utf8)!
        // find created keys
        let key = try createOrLoadAsymetricKey()
        // Create a query dictonary to save key
        let addquery: [String : Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueRef as String: key!
        ]
        var result : AnyObject?
        let status = withUnsafeMutablePointer(to: &result){
            SecItemAdd(addquery as CFDictionary, UnsafeMutablePointer($0))
        }
        guard status == errSecSuccess else {
            throw result as! Error
        }
        return true
    }
    
    func loadCrypto<T: AnyObject>(forKey key: String) throws -> T {
        // Get a tag for key and create a new RSA key
        let tag = "\(bundleName).keys.password".data(using: .utf8)!
        // find created keys
        let key = try createOrLoadAsymetricKey()
        // Create a query dictonary to save key
        let loadQuery: [String : Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueRef as String: key!
        ]
        var result: AnyObject?
        let status: OSStatus = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(loadQuery as CFDictionary, UnsafeMutablePointer($0))
        }
        if status == errSecSuccess { } else {
            throw status as! Error
        }
        return result as! T
    }
    
 
}

private extension KeychainManager{
    func createOrLoadAsymetricKey() throws -> SecKey?{
        // Get a tag for key and create a new RSA key
        let tag = "\(bundleName).keys.password".data(using: .utf8)!
        
        // Create a query dictonary for find cryto RSA key
        let query: [String : Any] = [
            kSecClass as String       : kSecClassKey,
            kSecAttrService as String : self.bundleName as AnyObject,
            kSecAttrAccount as String : "keys.password"  as AnyObject
        ]
        // If we have this result delete.
        let result = SecItemDelete(query as CFDictionary)
        if result == noErr {
            print("Deleted key")
            let attributes: [String : Any] = [
                kSecAttrKeyType as String : kSecAttrKeyTypeRSA ,
                kSecAttrKeySizeInBits as String: 2048,
                kSecPrivateKeyAttrs as String:
                    [ kSecAttrIsPermanent as String: true,
                      kSecAttrApplicationTag as String : tag ]
            ]
            var error: Unmanaged<CFError>?
            guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            let publicKey = SecKeyCopyPublicKey(privateKey)
            return publicKey
            
        } else {
            return getKey()
        }
    }
    
    
    func getKey() -> SecKey?{
        // Get a tag for key and create a new RSA key
        let tag = "\(bundleName).keys.password".data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String                 : kSecClassKey,
            kSecAttrApplicationTag as String    : tag,
            kSecAttrKeyType as String           : kSecAttrKeyTypeRSA,
            kSecReturnRef as String             : true
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
        return (item as! SecKey)
    }
}
