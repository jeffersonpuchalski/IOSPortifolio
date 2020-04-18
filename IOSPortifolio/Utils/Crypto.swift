//
//  Crypto.swift
//  Valecard
//
//  Created by Jefferson Barbosa Puchalski on 11/06/19.
//  Copyright © 2019 Jefferson Puchalski. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import KeychainSwift

/// Class responsible for cryptography in AES CBC mode
public class CryptUtils {
    
        /// AES key as byte array
        var KeyByte = [UInt8]()
        /// Initializator vector (IV) as byte array
        var iv = [UInt8]()
        /// Keychain to store any password.
        var keyChain: [String:Any] = [:]
        /// Lib to hold keychain logic
        let kc = KeychainSwift()
    
        /**
         Initialize a new cryptography with AES/CBC/PCSK5Padding utilitary with provied key and iv
         - Parameters:
            - key: Key in 16bits format.
            - iv: Initializator vector in 8bits format.
         - Returns: Class object with all parameters sets.
        */
        init(key: String, iv: String) {
            if (kc.get("key")?.utf8 == nil && kc.get("iv")?.utf8 == nil){
                // This initialize main crypto
                kc.set(key, forKey: "key")
                kc.set(iv, forKey: "iv")
            }
        }

        /**
         Build a keychain dictonary for crypt usage
         - Returns: Dictonary created with stored values
         */
        func buildKeychain() -> [String: Any]{
            let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                           kSecAttrApplicationTag as String: "tag",
                                           kSecClassGenericPassword as String: "key"]
            return addquery
        }
        
        /**
         Update password key with a byte array to query
         - Parameters:
            - pwdKey: Key to be stored in byte array.
         */
        func updatePasswordToQuery(pwdKey: [UInt8]){
            keyChain.updateValue(pwdKey, forKey: "key")
        }
        
        
        /**
         Add byte array as password to query
         - Parameters:
            - pwdKey: The byte array to be added
         */
        func addPasswordToQuery(pwdKey: [UInt8]){
            keyChain.updateValue(pwdKey, forKey: "key")
        }
        
        
        /**
         Add a query to a existing key chain.
         - Parameters:
         - query: Keychain to works as query
         */
        func addQueryToKeyChain(query: [String:Any]) {
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if (status != errSecSuccess) {    // Always check the status
                if #available(iOS 11.3, *) {
                    if let err = SecCopyErrorMessageString(status, nil) {
                        print("Write failed: \(err)")
                    }
                } else {
                    // Fallback on earlier versions
                    print("Error, low version")
                }
            }
        }
        
        
        /**
          Encrypt a plain text using AES
           - Parameters:
                - plainText: Text in plain mode to be used.
            - Returns: Encrypted string represented by a byte array.
         */
        func encrypt(plainText: String) -> [UInt8]{
            var result = [UInt8]()
            let Akey = Array(kc.get("key")!.utf8)
            let Aiv = Array(kc.get("iv")!.utf8)
            
            do {
                let aes = try AES(key: Akey, blockMode: CBC(iv: Aiv), padding: .pkcs7) // aes128
                let ciphertext = try aes.encrypt(Array(plainText.utf8))
                result = ciphertext
            } catch {
                print(error)
            }
            return result
        }
        
        /**
         Get a encrypted text and extract the plaintext
         - Parameters:
            - encryptText: Byte array represation of encrypted string
         - Returns: The plain text extracted from encrypted byte array.
         
         */
        func decrypt(encryptText: [UInt8]) -> String {
            var result = String()
            let Akey = Array(kc.get("key")!.utf8)
            let Aiv = Array(kc.get("key")!.utf8)
            
            do {
                let aes = try AES(key: Akey, blockMode: CBC(iv: Aiv), padding: .pkcs7) // aes128
                let ciphertext = try aes.decrypt(encryptText)
                print(ciphertext.toHexString())
                
                if let string = String(bytes: ciphertext, encoding: String.Encoding.utf8) {
                    print(string)
                    result = string
                } else {
                    print("not a valid UTF-8 sequence")
                }
                
            } catch {
                print(error)
            }
            return result
        }
}
