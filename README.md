# Lottie for iOS

A lightweight, modern Swift package for rendering **Adobe After Effects** animations natively on iOS, macOS, tvOS, and visionOS — with zero external dependencies.

> Inspired by the original Lottie concept pioneered by the Airbnb engineering team. This package has been independently reconstructed and maintained to support the latest Swift standards, modern SwiftUI APIs, and current Apple platform requirements.

---

## Features

- 🎬 Render After Effects animations exported as `.json` or `.lottie`
- ⚡️ Zero external dependencies — pure Swift, no bloat
- 🍎 SwiftUI-native `LottieView` with full modifier support
- 🎛️ Full playback control — play, pause, loop, scrub, speed
- 🎨 Dynamic color, value, and image providers at runtime
- 📦 Supports `.lottie` (zipped) and raw JSON animation files
- 🧵 Swift 5.9+, Xcode 15+, `swift-tools-version:5.9`

---

## Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS      | 13.0+          |
| macOS    | 10.15+         |
| tvOS     | 13.0+          |
| visionOS | 1.0+           |

- **Xcode**: 15.0+
- **Swift**: 5.9+

---

## Installation

### Swift Package Manager (Recommended)

In Xcode:
1. Go to **File → Add Package Dependencies…**
2. Enter the URL:
   ```
   https://github.com/Ajmalleonard/lottie-ios
   ```
3. Set the dependency rule to **Up to Next Major Version** from `4.6.2`
4. Click **Add Package**
5. Select the **Lottie** library and click **Add to Target**

> **Note**: If you see a resolution error, go to **File → Packages → Reset Package Caches**, then retry.

### Package.swift

```swift
dependencies: [
    .package(
        url: "https://github.com/Ajmalleonard/lottie-ios",
        from: "4.6.2"
    )
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "Lottie", package: "lottie-ios")
        ]
    )
]
```

---

## Quick Start

### SwiftUI

```swift
import Lottie
import SwiftUI

struct ContentView: View {
    var body: some View {
        LottieView(animation: .named("loading"))
            .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))
            .frame(width: 200, height: 200)
    }
}
```

### UIKit

```swift
import Lottie
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let animationView = LottieAnimationView(name: "loading")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        view.addSubview(animationView)
    }
}
```

---

## Adding Animation Files

Place your `.json` or `.lottie` files in your app's Xcode project target:

1. Drag the animation file into your Xcode project navigator
2. Make sure **"Add to target"** is checked for your app target
3. Reference by filename (without extension):

```swift
// .json file named "confetti.json"
LottieView(animation: .named("confetti"))

// .lottie file named "splash.lottie"
LottieView(animation: .named("splash"))
```

---

## Playback Control

### Loop Modes

```swift
LottieView(animation: .named("spinner"))
    .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))

// Available loop modes:
// .playOnce        — plays once and stops
// .loop            — loops forever
// .autoReverse     — plays forward then backward
// .repeat(3)       — repeats N times
// .repeatBackwards(3)
```

### Playback Speed

```swift
LottieView(animation: .named("loading"))
    .playing()
    .animationSpeed(1.5) // 1.5x speed
```

### Scrubbing (manual progress)

```swift
struct ScrubView: View {
    @State private var progress: AnimationProgressTime = 0

    var body: some View {
        VStack {
            LottieView(animation: .named("progress"))
                .currentProgress(progress)

            Slider(value: $progress, in: 0...1)
        }
    }
}
```

### Play a Specific Frame Range

```swift
LottieView(animation: .named("timeline"))
    .playing(.fromFrame(0, toFrame: 60, loopMode: .playOnce))
```

### Completion Callback

```swift
LottieView(animation: .named("checkmark"))
    .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
    .animationDidFinish { completed in
        if completed {
            print("Animation finished!")
        }
    }
```

---

## Loading Animations

### From Bundle

```swift
let animation = LottieAnimation.named("loading")
```

### From URL (Async)

```swift
Task {
    let animation = try await LottieAnimation.loadedFrom(
        url: URL(string: "https://example.com/animation.json")!
    )
}
```

### From Data

```swift
let data = try Data(contentsOf: fileURL)
let animation = try LottieAnimation(data: data)
```

### From a .lottie file (zipped)

```swift
Task {
    let dotLottie = try await DotLottieFile.named("my-animation")
}
```

---

## Dynamic Value Providers

Override colors, opacity, and other properties at runtime without modifying the original animation:

### Recolor a Layer

```swift
let colorProvider = ColorValueProvider(UIColor.systemBlue.lottieColorValue)

animationView.setValueProvider(
    colorProvider,
    keypath: AnimationKeypath(keypath: "**.Fill 1.Color")
)
```

### Change Opacity

```swift
let opacityProvider = FloatValueProvider(0.5) // 50% opacity

animationView.setValueProvider(
    opacityProvider,
    keypath: AnimationKeypath(keypath: "**.Opacity")
)
```

### Dynamic Image Provider

```swift
let imageProvider = BundleImageProvider(bundle: .main, searchPath: "Images")
animationView.imageProvider = imageProvider
```

---

## Animation Cache

Animations are cached automatically in memory. You can configure the cache:

```swift
// Set a custom cache size (number of animations)
LottieAnimationCache.shared.clearCache()

// Disable caching for a specific load
let animation = LottieAnimation.named("loading", animationCache: nil)
```

---

## Rendering Engine

By default, Lottie uses the **Core Animation** rendering engine for best performance. You can configure it:

```swift
var config = LottieConfiguration.shared
config.renderingEngine = .coreAnimation  // default, best performance
// config.renderingEngine = .mainThread  // fallback for complex unsupported animations
LottieConfiguration.shared = config
```

---

## SwiftUI Advanced Usage

### Binding to Playback State

```swift
struct AnimatedButton: View {
    @State private var isPlaying = false

    var body: some View {
        LottieView(animation: .named("toggle"))
            .playing(isPlaying ? .fromProgress(0, toProgress: 1, loopMode: .playOnce) : .pause)
            .onTapGesture {
                isPlaying.toggle()
            }
    }
}
```

### Conditional Animation

```swift
LottieView(animation: .named("success"))
    .playing(showSuccess ? .fromProgress(0, toProgress: 1, loopMode: .playOnce) : .pause)
    .opacity(showSuccess ? 1 : 0)
    .animation(.easeInOut, value: showSuccess)
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Package resolution fails in Xcode | File → Packages → Reset Package Caches, then re-add |
| Animation not found | Ensure the file is added to your app target, not just the project |
| Black/empty view | Check the animation file is valid JSON; try opening in [LottieFiles](https://lottiefiles.com) |
| Wrong colors | Use `setValueProvider(_:keypath:)` to override dynamic colors |
| Animation stutters | Switch to `.coreAnimation` rendering engine in `LottieConfiguration` |
| `.lottie` file not loading | Ensure the file extension is `.lottie` and it's a valid zipped Lottie bundle |

---

## License

Apache License 2.0 — see [LICENSE](LICENSE) for details.

---

## Acknowledgement

The Lottie animation format and the original iOS rendering concept were created by the **Airbnb engineering team**. This package is an independent reconstruction built to support modern Swift 5.9+, current Apple platform APIs, zero external dependencies, and a minimal SPM footprint — while preserving full compatibility with the Lottie JSON animation format.
