//
//  StringExtensions.swift
//  StringExtensions
//
//  Created by JanFranco on 5.01.2021.
//

import Foundation

extension String {
    // Translate
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    // "hello, world"[2..3]
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
    
    // what's inside?
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    var containsOnlyLetters: Bool {
        let notLetters = NSCharacterSet.letters.inverted
        return rangeOfCharacter(from: notLetters, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    var isAlphanumeric: Bool {
        let notAlphanumeric = NSCharacterSet.decimalDigits.union(NSCharacterSet.letters).inverted
        return rangeOfCharacter(from: notAlphanumeric, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    // is valid e-mail?
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    // Convert
    func toInt() -> Int {
        Int(self)!
    }
    
    func toIntOrNull() -> Int? {
        Int(self)
    }
}

/*
 let age = 25
 age.store(key: "age")
 print(Int(key: "age")) // Optional(25)
 print(Float(key: "age")) // Optional(25.0)
 print(String(key: "age")) // Optional("25")
 print(String(key: "age1")) // nil
 */
extension Int {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.integer(forKey: key))
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension Bool {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.bool(forKey: key))
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension Float {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.float(forKey: key))
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension Double {
    init?(key: String) {
        guard UserDefaults.standard.value(forKey: key) != nil else { return nil }
        self.init(UserDefaults.standard.double(forKey: key))
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension Data {
    init?(key: String) {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        self.init(data)
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension String {
    init?(key: String) {
        guard let str = UserDefaults.standard.string(forKey: key) else { return nil }
        self.init(str)
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension Array where Element == Any {
    init?(key: String) {
        guard let array = UserDefaults.standard.array(forKey: key) else { return nil }
        self.init()
        self.append(contentsOf: array)
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension Dictionary where Key == String, Value == Any {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
    
    init?(key: String) {
        guard let dict = UserDefaults.standard.dictionary(forKey: key) else { return nil }
        self.init()
        self.merge(dict: dict)
    }
    
    func store(key: String) {
        UserDefaults.standard.set(self, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

// JSON Parse
extension Data {
    init?(json: Any) {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) else { return nil }
        self.init(data)
    }
    
    func jsonToDictionary() -> [String: Any]? {
        (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) as? [String: Any]
    }
    
    func jsonToArray() -> [Any]? {
        (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) as? [Any]
    }
}

extension String {
    init?(json: Any) {
        guard let data = Data(json: json) else { return nil }
        self.init(decoding: data, as: UTF8.self)
    }
    
    func jsonToDictionary() -> [String: Any]? {
        self.data(using: .utf8)?.jsonToDictionary()
    }
    
    func jsonToArray() -> [Any]? {
        self.data(using: .utf8)?.jsonToArray()
    }
}
