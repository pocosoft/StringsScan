# StringsScan
![workflow](https://github.com/pocosoft/StringsScan/actions/workflows/swift.yml/badge.svg)
[![codecov](https://codecov.io/gh/pocosoft/StringsScan/branch/main/graph/badge.svg?token=tNUwaugU4z)](https://codecov.io/gh/pocosoft/StringsScan)

Scans all Xcode strings files for unused localized strings.

## Getting started

```
git clone <this repository>
cd StringsScan
swift run StringsScan strings-scan -p <project directory-path>
```

### Sample results

![スクリーンショット 2022-08-15 9 38 47](https://user-images.githubusercontent.com/12389710/184561077-79aa6ff1-6b79-4105-adef-ff891e8fea57.png)

## Xcode

When StringsScan is integrated into an Xcode project, warnings and errors will appear in the Issue Navigator.

To do this select the project in the file navigator, then select the primary app target, and go to Build Phases. Click the + and select "New Run Script Phase". Insert the following as the script:

```
cd ${BUILD_DIR%Build/*}SourcePackages/checkouts/StringsScan
/usr/bin/xcrun --sdk macosx swift run -c release StringsScan strings-scan -p "${SRCROOT}/<project directory-path>"
```

![スクリーンショット 2022-08-15 9 36 42](https://user-images.githubusercontent.com/12389710/184560987-7ef443e5-836f-4840-8332-e06b2705b060.png)

![スクリーンショット 2022-08-15 9 37 30](https://user-images.githubusercontent.com/12389710/184561015-b2615f3c-7ca9-429b-a13c-b5cb8b3f1aac.png)
