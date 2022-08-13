//
//  SourceLocation.swift
//  
//
//  Created by Akihiro Orikasa on 2022/08/13.
//

import Foundation
import PathKit

struct SourceLocation: Hashable {
    let filepath: Path
    let stringId: String
    let line: Int64
    let column: Int64 = 1
}
