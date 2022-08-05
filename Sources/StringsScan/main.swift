import Foundation
import ArgumentParser
import StencilSwiftKit
import PythonKit

let glob = Python.import("glob")
let re = Python.import("re")

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


class Scan {
    
    static func main(_ path: String?) throws {
        let l = Scan(path)
        try l.main()
    }
    
    let absoluteSearchPath: String
    
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
    
    lazy var stringIds: Set<String> = {
        var ids: [String] = []
        localizableFiles.forEach {
            guard let content = try? String(contentsOfFile: $0, encoding: .utf8) else {
                return
            }
            if $0.lastPathComponent == "Localizable.strings" {
                content.split(separator: "\n").filter { $0.starts(with: "\"") }
                    .forEach {
                        var id = $0.components(separatedBy: " = ").first!
                        id.removeFirst()
                        id.removeLast()
                        ids.append(id)
                    }
            } else {    // Storyboard's strings file
                content.split(separator: "\n").filter { $0.starts(with: "\"") }
                    .forEach {
                        var id = $0.components(separatedBy: " = ").first!
                        id.removeFirst()
                        id.removeLast()
                        ids.append(id.components(separatedBy: ".").first!)  // split for `.text` or `.title`
                    }
            }
        }
        return Set(ids)
    }()
    
    init(_ path: String?) {
        if let path = path {
            absoluteSearchPath = FileManager.default.currentDirectoryPath.appendingPathComponent(path)
        } else {
            absoluteSearchPath = FileManager.default.currentDirectoryPath
        }
    }
    
    func main() throws {
//        print(swiftFiles)
//        print(storyboardFiles)
//        print(localizableFiles)
//        print(stringIds)
//        print(jaLocalizableLines)

        // Whether the ID is used in the project.
        var usedIds = [String]()
        var unusedIds = [String]()
        stringIds.forEach {
            if let result = containsIn(stringId: $0) {
                print("✅ \"\($0)\" is used in \(result)")
                usedIds.append($0)
            } else {
                print("⚠️ Warning \"\($0)\" is unused")
                unusedIds.append($0)
            }
        }
        
        print("❤️  Used strings is \(usedIds.count)")
        print("💙  Unused strings is \(unusedIds.count)")
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

struct StringsScan: ParsableCommand {

    @Option(name: .shortAndLong, help: "Path of the directory to scan.")
    var path: String?
    
    @Argument()
    var phrase: String

    mutating func run() throws {
        print("Run \(phrase)")
        do {
            try Scan.main(path)
        } catch let e {
            fatalError(e.localizedDescription)
        }
        print("End \(phrase)")
    }
}

StringsScan.main()
