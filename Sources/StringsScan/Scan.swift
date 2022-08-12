//
//  StringExtension.swift
//  
//
//  Created by Akihiro Orikasa on 2022/08/06.
//

import Foundation
import StencilSwiftKit
import PythonKit

private let glob = Python.import("glob")
private let re = Python.import("re")

final class Scan {
    
    private let absoluteSearchPath: String
    
    init(_ path: String?) {
        absoluteSearchPath = path ?? FileManager.default.currentDirectoryPath
    }

    static func main(_ path: String?, verbose: Bool) throws {
        let l = Self(path)
        try l.main(verbose: verbose)
    }

    lazy var swiftFiles: Set<String> = {
        globs(ext: "swift").filter { $0.lastPathComponent != "Strings.swift" }
    }()
    
    lazy var storyboardFiles: Set<String> = {
        globs(ext: "storyboard")
    }()
    
    lazy var localizableFiles: Set<String> = {
        globs(ext: "strings")
    }()
    
    lazy var jaLocalizableLines: Set<String> = {
        var lines: [String] = []
        localizableFiles.forEach {
            guard $0.contains("ja.lproj"),
                  let content = try? String(contentsOfFile: $0, encoding: .utf8) else {
                return
            }
            let line = content.components(separatedBy: "\n").filter { $0.starts(with: "\"") }
            lines += line
        }
        return Set(lines)
    }()
    
    lazy var stringIds: Set<SourceLocation> = {
        var ids: [SourceLocation] = []
        localizableFiles.forEach { path in
            guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
                return
            }
            if path.lastPathComponent == "Localizable.strings" {
                content.components(separatedBy: "\n").enumerated()
                    .filter { $1.starts(with: "\"") }
                    .forEach { line, elem in
                        var id = elem.components(separatedBy: " = ").first!
                        id.removeFirst()
                        id.removeLast()
                        ids.append(SourceLocation(filepath: path, stringId: id, line: Int64(line + 1)))
                    }
            } else {    // Storyboard's strings file
                content.components(separatedBy: "\n").enumerated()
                    .filter { $1.starts(with: "\"") }
                    .forEach { line, elem in
                        var id = elem.components(separatedBy: " = ").first!
                        id.removeFirst()
                        id.removeLast()
                        id = id.components(separatedBy: ".").first! // split for `.text` or `.title`
                        ids.append(SourceLocation(filepath: path, stringId: id, line: Int64(line + 1)))
                    }
            }
        }
        return Set(ids)
    }()
        
    func main(verbose: Bool) throws {
        if verbose {
            print(swiftFiles)
            print(storyboardFiles)
            print(localizableFiles)
            print(stringIds)
            print(jaLocalizableLines)
        }

        // Whether the ID is used in the project.
        var usedIds = [String]()
        var unusedIds = [String]()
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

    func findLocalized(_ filepath: String) throws -> [String] {
        let str = try String(contentsOfFile: filepath, encoding: .utf8)
        return re.findall("\".+\"\\.localized", str).map { "\($0)" }
    }
    
    func globs(ext: String) -> Set<String> {
        var arr: [String] = glob.glob("\(absoluteSearchPath)/*.\(ext)").map { "\($0)" }
        arr += glob.glob("\(absoluteSearchPath)/**/*.\(ext)").map { "\($0)" }
        arr += glob.glob("\(absoluteSearchPath)/**/**/*.\(ext)").map { "\($0)" }
        arr += glob.glob("\(absoluteSearchPath)/**/**/**/*.\(ext)").map { "\($0)" }
        arr += glob.glob("\(absoluteSearchPath)/**/**/**/**/*.\(ext)").map { "\($0)" }
        arr += glob.glob("\(absoluteSearchPath)/**/**/**/**/**/*.\(ext)").map { "\($0)" }
        return Set(arr)
    }
    
    func containsInSwiftFile(stringId: String) -> String? {
        let swiftId = swiftIdentifier(stringId)
        for s in swiftFiles {
            guard let str = try? String(contentsOfFile: s, encoding: .utf8) else {
                continue
            }
            if str.contains(stringId) || str.contains(swiftId) {
                return s.lastPathComponent
            }
        }
        return nil
    }
    
    func containsInStoryboard(stringId: String) -> String? {
        for s in storyboardFiles {
            guard let str = try? String(contentsOfFile: s, encoding: .utf8) else {
                continue
            }
            if str.contains(stringId) {
                return s.lastPathComponent
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
    
    func lineByStringId(_ stringId: String) -> String? {
        jaLocalizableLines.first(where: { $0.contains(stringId) })
    }
}
