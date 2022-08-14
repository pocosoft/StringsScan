//
//  SourceLocation.swift
//  
//
//  Created by Akihiro Orikasa on 2022/08/13.
//

import Foundation
import PathKit

struct SourceLocation {
    let filepath: Path
    let stringId: String
    let line: Int64
    let column: Int64 = 1
}

extension SourceLocation: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.stringId == rhs.stringId
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(stringId)
    }
}
