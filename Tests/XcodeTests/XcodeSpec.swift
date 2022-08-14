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
            it("stringsPaths") {
                expect { scan.stringsPaths }.to(haveCount(6), description: scan.stringsPaths.debugDescription)
            }
            it("stringIds") {
                expect { scan.stringIds }.to(haveCount(9), description: scan.stringIds.map({ $0.stringId }).debugDescription)
            }
            it("containsInSwiftFile") {
                expect { scan.containsInSwiftFile(stringId: "Hello, world!") } == "ViewController.swift"
                expect { scan.containsInSwiftFile(stringId: "unused") }.to(beNil())
            }
        }
    }
}
