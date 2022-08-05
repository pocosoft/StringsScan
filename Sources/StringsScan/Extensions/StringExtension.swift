//
//  StringExtension.swift
//  
//
//  Created by Akihiro Orikasa on 2022/08/06.
//

import Foundation

extension String {
    private var ns: NSString {
        return (self as NSString)
    }
    func substring(from index: Int) -> String {
        return ns.substring(from: index)
    }
    func substring(to index: Int) -> String {
        return ns.substring(to: index)
    }
    func substring(with range: NSRange) -> String {
        return ns.substring(with: range)
    }
    var lastPathComponent: String {
        return ns.lastPathComponent
    }
    var pathExtension: String {
        return ns.pathExtension
    }
    var deletingLastPathComponent: String {
        return ns.deletingLastPathComponent
    }
    var deletingPathExtension: String {
        return ns.deletingPathExtension
    }
    var pathComponents: [String] {
        return ns.pathComponents
    }
    func appendingPathComponent(_ str: String) -> String {
        return ns.appendingPathComponent(str)
    }
    func appendingPathExtension(_ str: String) -> String? {
        return ns.appendingPathExtension(str)
    }
    var isDirectory: Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: self, isDirectory: &isDir)
        return isDir.boolValue
    }
}
