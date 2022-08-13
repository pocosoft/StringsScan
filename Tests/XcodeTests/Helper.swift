import Foundation
import SystemPackage

var ProjectRootPath: FilePath {
    FilePath(#filePath).appending("../../..").lexicallyNormalized()
}

var UIKitProjectPath: FilePath {
    ProjectRootPath.appending("Tests/XcodeTests/UIKitProject/UIKitProject")
}

var SwiftUIProjectPath: FilePath {
    ProjectRootPath.appending("Tests/XcodeTests/SwiftUIProject/SwiftUIProject")
}

