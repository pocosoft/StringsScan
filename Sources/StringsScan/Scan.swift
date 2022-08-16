//
//  StringExtension.swift
//  
//
//  Created by Akihiro Orikasa on 2022/08/06.
//

import Foundation
import StencilSwiftKit
import PathKit
import PythonKit

private let glob = Python.import("glob")
private let re = Python.import("re")

final class Scan {
    
    private let absoluteSearchPath: String
    
    init(_ path: String?) {
        absoluteSearchPath = path ?? FileManager.default.currentDirectoryPath
    }

    static func run(_ path: String?, verbose: Bool) throws {
        let l = Self(path)
        try l.run(verbose: verbose)
    }

    lazy var swiftPaths: Set<Path> = {
        globs(ext: "swift").filter { $0.lastComponent != "Strings.swift" }
    }()
    
    lazy var storyboardPaths: Set<Path> = {
        globs(ext: "storyboard")
    }()
    
    lazy var stringsPaths: Set<Path> = {
        globs(ext: "strings")
    }()
    
    lazy var stringIds: Set<SourceLocation> = {
        var ids: [SourceLocation] = []
        stringsPaths.forEach { path in
            guard let content = try? path.read(.utf8) else {
                return
            }
            content.components(separatedBy: "\n").enumerated()
                .filter { $1.starts(with: "\"") }
                .forEach { line, elem in
                    var id = elem.components(separatedBy: " = ").first!
                    id.removeFirst()
                    id.removeLast()
                    if id.isLocalizedFromStroyboard {
                        id = id.components(separatedBy: ".").first! // split for `.text` or `.title`
                    }
                    ids.append(SourceLocation(filepath: path, stringId: id, line: Int64(line + 1)))
                }
        }
        return Set(ids)
    }()
    
    private(set) var usedIds = [String]()
    private(set) var unusedIds = [String]()
    
    func run(verbose: Bool) throws {
        if verbose {
            print(swiftPaths)
            print(storyboardPaths)
            print(stringsPaths)
            print(stringIds)
        }

        // Whether the ID is used in the project.
        usedIds.removeAll()
        unusedIds.removeAll()

        stringIds.forEach {
            if let result = containsIn(stringId: $0.stringId) {
                if verbose {
                    print("✅ \"\($0.stringId)\" is used in \(result)")
                }
                usedIds.append($0.stringId)
            } else {
                print("\($0.filepath):\($0.line):\($0.column): warning: \"\($0.stringId)\" is unused")
                unusedIds.append($0.stringId)
            }
        }

        if verbose {
            print("❤️  Used strings is \(usedIds.count)")
            print("💙  Unused strings is \(unusedIds.count)")
        }
    }
    
    func globs(ext: String) -> Set<Path> {
        var arr: [Path] = glob.glob("\(absoluteSearchPath)/*.\(ext)").map { Path("\($0)") }
        arr += glob.glob("\(absoluteSearchPath)/**/*.\(ext)").map { Path("\($0)") }
        arr += glob.glob("\(absoluteSearchPath)/**/**/*.\(ext)").map { Path("\($0)") }
        arr += glob.glob("\(absoluteSearchPath)/**/**/**/*.\(ext)").map { Path("\($0)") }
        arr += glob.glob("\(absoluteSearchPath)/**/**/**/**/*.\(ext)").map { Path("\($0)") }
        arr += glob.glob("\(absoluteSearchPath)/**/**/**/**/**/*.\(ext)").map { Path("\($0)") }
        return Set(arr)
    }
    
    func containsInSwiftFile(stringId: String) -> String? {
        let swiftId = swiftIdentifier(stringId)
        for path in swiftPaths {
            guard let str = try? path.read(.utf8) else {
                continue
            }
            if str.contains(stringId) || str.contains(swiftId) {
                return path.lastComponent
            }
        }
        return nil
    }
    
    func containsInStoryboard(stringId: String) -> String? {
        for path in storyboardPaths {
            guard let str = try? path.read(.utf8) else {
                continue
            }
            if str.contains(stringId) {
                return path.lastComponent
            }
        }
        return nil
    }
    
    func containsIn(stringId: String) -> String? {
        if let path = containsInSwiftFile(stringId: stringId) {
            return path
        }
        return containsInStoryboard(stringId: stringId)
    }
    
    func swiftIdentifier(_ stringId: String) -> String {
        typealias Filter = StencilSwiftKit.Filters.Strings
        let pretty = try! Filter.swiftIdentifier(stringId, arguments: [SwiftIdentifierModes.pretty])
        return try! Filter.lowerFirstWord(pretty) as! String
    }
}

extension String {
    var isLocalizedFromStroyboard: Bool {
        let pattern = "^\\w{3}+\\-\\w{2}\\-\\w{3}\\."
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        return regex.firstMatch(in: self,
                                options: NSRegularExpression.MatchingOptions.reportProgress,
                                range: NSRange(location: 0, length: count)) != nil
    }
}
