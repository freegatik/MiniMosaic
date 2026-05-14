<p align="center">
  <img src="MiniMosaic/Resourses/Assets.xcassets/AppIcon.appiconset/180.png" width="200" alt="MiniMosaic">
</p>

# MiniMosaic

![Static Badge](https://img.shields.io/badge/platform-iOS-white)
![Static Badge](https://img.shields.io/badge/latest_release-v1.0.0-green)
![Static Badge](https://img.shields.io/badge/swift-v5.0-orange)

[![iOS CI](https://github.com/freegatik/MiniMosaic/actions/workflows/ios-ci.yml/badge.svg)](https://github.com/freegatik/MiniMosaic/actions/workflows/ios-ci.yml)

iOS app built with **UIKit** (Swift **5**, iOS **16.0** minimum). A **mosaic home screen** of mini-app tiles (weather, news, location, and more) backed by **`MiniAppFactory`**, **`MiniAppListViewModel`**, and **`AppEnvironment`**. Layout modes scale tile height (**full**, **half**, **compact**); **tap-to-highlight** is enabled for **half** and **full** rows and disabled in **compact** (1/8 height) so tiny tiles stay non-interactive. Networking uses **Alamofire** (SPM); local Swift packages **`NewsMiniAppPackage`** and **`LocationMiniAppPackage`** live under `MiniMosaic/`. Copy and strings: **`Localizable.xcstrings`** (en, ru). Deeper structure: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## CI

Workflow [`.github/workflows/ios-ci.yml`](.github/workflows/ios-ci.yml) on [GitHub Actions](https://github.com/freegatik/MiniMosaic/actions) (triggers on **`push`** / **`pull_request`** to **`main`** or **`master`**, plus **`workflow_dispatch`**). **`concurrency`** with **`cancel-in-progress`** cancels superseded runs for the same ref/PR.

| Job | What it runs |
|-----|----------------|
| **SwiftLint** | `swiftlint lint` with [`.swiftlint.yml`](.swiftlint.yml), **`--strict`**, GitHub Actions logging reporter (SwiftLint from Homebrew on **`macos-14`**) |
| **Build & unit tests** | `xcodebuild -resolvePackageDependencies`, then **`clean test`** on **`MiniMosaic`** with **`-destination "platform=iOS Simulator,name=iPhone 15"`**, **`-enableCodeCoverage YES`**, **`-resultBundlePath`** under `RUNNER_TEMP` / **`MiniMosaicTests.xcresult`**; caches **DerivedData** + SPM config keyed by **`Package.resolved`** |
| **CI green** | Gate job **`needs: [swiftlint, unit-tests]`**; fails the workflow if either required job is not **success** |

After a successful test run, **`xcrun xccov report`** output (first lines) is appended to the job summary. On **failure**, the **`MiniMosaic-tests-xcresult`** artifact uploads the **`.xcresult`** bundle (14-day retention) for download and local inspection in Xcode.

## Requirements

- **Xcode 15+** (scheme last opened with Xcode **15.4** toolchain)
- Simulator **iOS 16+**; CI uses **`iPhone 15`** on **`macos-14`**. Match or adjust **`DESTINATION`** in the workflow if that simulator is unavailable on the runner image.

## Configuration

- **Weather / News APIs:** set keys in [`MiniMosaic/Utils/API/APIKeys.swift`](MiniMosaic/Utils/API/APIKeys.swift) (`weatherAPIKey`, `newsAPIKey`) for live network calls.
- **SPM:** [Alamofire](https://github.com/Alamofire/Alamofire) is pinned via [`Package.resolved`](MiniMosaic.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved).

## Getting started

```bash
git clone https://github.com/freegatik/MiniMosaic.git
cd MiniMosaic
open MiniMosaic.xcodeproj
```

Use the **MiniMosaic** scheme: **⌘R** to run, **⌘U** for unit tests. For a device build, set your **Team** in Signing & Capabilities.

## Project layout

| Area | Path / notes |
|------|----------------|
| App entry | `MiniMosaic/App/` (`AppDelegate`, `SceneDelegate`) |
| DI & environment | `MiniMosaic/Core/DI/`, `MiniMosaic/Core/Services/` |
| Mosaic UI | `MiniMosaic/Views/` (`MiniAppListViewController`, components, weather/city screens) |
| Models | `MiniMosaic/Models/` |
| Services & API | `MiniMosaic/Utils/Services/`, `MiniMosaic/Utils/API/` |
| Local packages | `MiniMosaic/NewsMiniAppPackage/`, `MiniMosaic/LocationMiniAppPackage/` |
| Assets & strings | `MiniMosaic/Resourses/` (`Assets.xcassets`, `Localizable.xcstrings`) |

## Testing

- **`MiniMosaicTests`** (scheme default) — JSON decoding for **weather** / **news** payloads, **`LocationModel`**, **`MiniAppListViewModel`** / grid layout modes (`MiniMosaicTests/MiniMosaicModelTests.swift`)

Package folders also contain **`Tests`** targets for **News** and **Location** mini-apps; run them from Xcode via each package, or with **`swift test`** inside the package directory when developing those modules in isolation.

Coverage locally (pick a simulator that exists on your Mac):

```bash
xcodebuild test \
  -project MiniMosaic.xcodeproj \
  -scheme MiniMosaic \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -resultBundlePath /tmp/MiniMosaic.xcresult \
  -enableCodeCoverage YES
xcrun xccov view --report /tmp/MiniMosaic.xcresult | head -40
```

Lint: `swiftlint lint --config .swiftlint.yml --strict` (see [`.swiftlint.yml`](.swiftlint.yml)).

## License

Licensed under the [MIT License](LICENSE). See `LICENSE` for the full wording.
