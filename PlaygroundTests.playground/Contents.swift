import UIKit

enum PListManagerError : Error {
    case FilePathNotExist
    case DictionaryNotBind
}

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

do{
    let dict = try loadPlistToDictonary(for: "Urls")
} catch PListManagerError.FilePathNotExist{
    print(PListManagerError.FilePathNotExist)
}

do {
    try saveDictToPlist(dictonary: ["A": Int(98)], pListName: "Test")
} catch PListManagerError.FilePathNotExist{
    print("File does not exist or inacessible")
}


