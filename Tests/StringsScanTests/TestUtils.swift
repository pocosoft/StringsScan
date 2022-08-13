//
//  TestUtils.swift
//  
//
//  Created by Akihiro Orikasa on 2022/08/13.
//

import Foundation
import Quick

extension QuickSpec {
    var bundle: Bundle {
        Bundle(for: type(of: self))
    }
}
