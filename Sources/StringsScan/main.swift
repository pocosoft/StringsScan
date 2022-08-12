import Foundation
import ArgumentParser

struct StringsScan: ParsableCommand {

    @Option(name: .shortAndLong, help: "Path of the directory to scan.")
    var path: String?
    
    @Flag(help: "show detail logs")
    var verbose: Bool = false

    @Argument()
    var phrase: String

    mutating func run() throws {
        print("Run \(phrase)")
        do {
            try Scan.main(path, verbose: verbose)
        } catch let e {
            fatalError(e.localizedDescription)
        }
        print("End \(phrase)")
    }
}

StringsScan.main()
