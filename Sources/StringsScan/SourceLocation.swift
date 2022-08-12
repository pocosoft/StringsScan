//
//  SourceLocation.swift
//  
//
//  Created by Akihiro Orikasa on 2022/08/13.
//

import Foundation

struct SourceLocation: Hashable {
    let filepath: String
    let stringId: String
    let line: Int64
    let column: Int64 = 1
}
