//
//  XcodeSpec.swift
//  
//
//  Created by Akihiro Orikasa on 2022/08/13.
//

import Nimble
import Quick

@testable import StringsScan

final class XcodeSpec: QuickSpec {
    override func spec() {
        describe("SwiftUI project") {
            var scan: Scan!
            beforeEach {
                scan = .init(SwiftUIProjectPath.string)
            }
            it("swiftPaths") {
                expect { scan.swiftPaths }.to(haveCount(2))
            }
            it("storyboardPaths") {
                expect { scan.storyboardPaths }.to(beEmpty())
            }
            it("stringsPaths") {
                expect { scan.stringsPaths }.to(haveCount(2))
            }
            it("stringIds") {
                expect { scan.stringIds }.to(haveCount(3), description: scan.stringIds.map({ $0.stringId }).debugDescription)
            }
            it("containsInSwiftFile") {
                expect { scan.containsInSwiftFile(stringId: "Hello, world!") } == "ContentView.swift"
                expect { scan.containsInSwiftFile(stringId: "unused") }.to(beNil())
            }
            it("containsIn") {
                expect { scan.containsInSwiftFile(stringId: "Hello, world!") } == "ContentView.swift"
                expect { scan.containsInSwiftFile(stringId: "unused") }.to(beNil())
            }
            it("isLocalizedFromStroyboard") {
                expect { "Eph-cL-JCB.text".isLocalizedFromStroyboard } == true
                expect { "Nu5-YW-uYY.text".isLocalizedFromStroyboard } == true
                expect { "ccY-Bz-hZa.configuration.title".isLocalizedFromStroyboard } == true
                expect { "ccY-Bz-hZa.normalTitle".isLocalizedFromStroyboard } == true
                expect { "Hello, world!".isLocalizedFromStroyboard } == false
                expect { "unused".isLocalizedFromStroyboard } == false
                expect { "get-my-size.hoghoge".isLocalizedFromStroyboard } == false
            }
            it("run") {
                try scan.run(verbose: true)
                expect { scan.usedIds }.to(haveCount(1))
                expect { scan.unusedIds }.to(haveCount(2))
            }
        }
        describe("UIKit project") {
            var scan: Scan!
            beforeEach {
                scan = .init(UIKitProjectPath.string)
            }
            it("swiftPaths") {
                expect { scan.swiftPaths }.to(haveCount(3), description: scan.swiftPaths.debugDescription)
            }
            it("storyboardPaths") {
                expect { scan.storyboardPaths }.to(haveCount(2), description: scan.storyboardPaths.debugDescription)
            }
            it("xibPaths") {
                expect { scan.xibPaths }.to(haveCount(1), description: scan.storyboardPaths.debugDescription)
            }
            it("stringsPaths") {
                expect { scan.stringsPaths }.to(haveCount(8), description: scan.stringsPaths.debugDescription)
            }
            it("stringIds") {
                expect { scan.stringIds }.to(haveCount(13), description: scan.stringIds.map({ $0.stringId }).debugDescription)
            }
            it("containsInSwiftFile") {
                expect { scan.containsInSwiftFile(stringId: "Hello, world!") } == "ViewController.swift"
                expect { scan.containsInSwiftFile(stringId: "unused") }.to(beNil())
            }
            it("containsInStoryboard") {
                expect { scan.containsInStoryboard(stringId: "Nu5-YW-uYY") } == "Main.storyboard"
                expect { scan.containsInSwiftFile(stringId: "ccI-Bz-hZa") }.to(beNil())
            }
            it("containsIn") {
                expect { scan.containsIn(stringId: "Hello, world!") } == "ViewController.swift"
                expect { scan.containsIn(stringId: "unused") }.to(beNil())
                expect { scan.containsIn(stringId: "Nu5-YW-uYY") } == "Main.storyboard"
                expect { scan.containsIn(stringId: "ccI-Bz-hZa") }.to(beNil())
            }
            it("run") {
                try scan.run(verbose: true)
                expect { scan.usedIds }.to(haveCount(7))
                expect { scan.unusedIds }.to(haveCount(6))
            }
        }
    }
}
