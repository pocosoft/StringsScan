import Foundation
import ArgumentParser

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
