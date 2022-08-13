//
//  ScanSpec.swift
//  
//
//  Created by Akihiro Orikasa on 2022/08/13.
//

import Nimble
import Quick

@testable import StringsScan
import Foundation

final class ScanSpec: QuickSpec {
    override func spec() {
        var scan: Scan!
        describe("path is nil") {
            beforeEach {
                scan = .init(nil)
            }
            it("swiftPaths") {
                print(scan.swiftPaths)
                print(self.bundle.bundleURL)
            }
            it("storyboardPaths") {
                
            }
            it("stringsPaths") {
                
            }
        }
        describe("absolute path") {
            beforeEach {
                scan = .init(nil)
            }
            it("swiftPaths") {
                print(scan.swiftPaths)
            }
            it("storyboardPaths") {
                
            }
            it("stringsPaths") {
                
            }
        }
        describe("relative path") {
            beforeEach {
                scan = .init(nil)
            }
            it("swiftPaths") {
                print(scan.swiftPaths)
            }
            it("storyboardPaths") {
                
            }
            it("stringsPaths") {
                
            }
        }
    }
}
