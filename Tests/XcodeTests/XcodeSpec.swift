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
                expect { scan.storyboardPaths }.to(haveCount(2))
            }
            it("stringsPaths") {
                expect { scan.stringsPaths }.to(haveCount(6), description: scan.swiftPaths.debugDescription)
            }
        }
    }
}
