//
//  PListManager.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 19/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import Foundation

enum PListManagerError : Error {
    case FilePathNotExist
    case DictionaryNotBind
}

class PListManager: NSObject {

    func loadPlistToDictonary(for pListName: String) throws -> [String: Any] {
        guard let path = Bundle.main.path(forResource: pListName, ofType: "plist") else {
            throw PListManagerError.FilePathNotExist
        }
        guard let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            throw PListManagerError.DictionaryNotBind
        }
        return dict
    }
    
    func saveDictToPlist(dictonary: Dictionary<String, Any>, pListName: String) throws{
        guard let path = Bundle.main.path(forResource: pListName, ofType: "plist") else {
            throw PListManagerError.FilePathNotExist
        }
        let nsDict = NSDictionary(dictionary: dictonary)
        nsDict.write(toFile: path, atomically: true)
    }
}
