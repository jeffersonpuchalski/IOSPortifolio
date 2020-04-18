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
}

