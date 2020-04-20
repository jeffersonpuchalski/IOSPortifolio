//
//  StringExtension.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 17/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import Foundation

extension String {
    /// Remove all characters with match regex, and return a new string
    /// - Parameters:
    ///   - pattern: Regex pattern for evaluate.
    ///   - replaceWith: String to be replaced.
    /// - Returns: The new string with result.
    func removingRegexMatches(pattern: String, replaceWith: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return ""
        }
    }
    
    /**
     Filter all characters and extract the numbers.
     - Returns: String with just numbers.
     */
    func extractNumbers() -> String {
        return self.removingRegexMatches(pattern: "[\\D]*")
    }
    
    ///  Check if password comply security police.
    
    /// - The policy contains the follow patterns:
    /// - Sequential numbers -> Ex: "0123456789012345789876543210"
    /// - 5 same digits numbers -> Ex: "0123456789012345789876543210"
    ///
    /// - Returns: If string doesnt comply return false, otherwise true.
    func isValidPassword() -> Bool {
        let pattern = "0123456789012345789876543210"
        let pattern2 = "00000111112222233333444445555566666777778888899999"
        return !pattern.contains(self) && !pattern2.contains(self)
    }
    
    /**
     Check if a number is a valid cellphone.
     
     This validation follow the Brazilian number's validations.
     */
    func isValidCellPhoneNumber() -> Bool {
        let phoneRegEx = "^(\\d{2})([6-9])(\\d{4})(\\d{4})"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    /**
     Check if a number is a valid phone.
     
     This validation follow the Brazilian number's validations.
     */
    func isValidPhoneNumber() -> Bool {
        let phoneRegEx = "^(\\d{2})([0-5])(\\d{3})(\\d{4})"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    /**
     Check if a string is a valid email.
     - Returns: True if email is valid, otherwise false.
     */
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    
    func isValidName() -> Bool {
        let nameRegex = "^(?![ ])(?!.*[ ]{2})((?:e|da|do|das|dos|de|d'|D'|la|las|el|los)\\s*?|(?:[A-Z][^\\s]*\\s*?)(?!.*[ ]$))+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: self)
    }
    
    func removeAllMaskCharacters() -> String {
        return self.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\"", with: "")
    }
    
}

