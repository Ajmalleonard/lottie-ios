# Lottie for iOS

Animation is not decoration. It is communication.

This is a Swift package that renders Adobe After Effects animations natively on iOS, macOS, tvOS, and visionOS — in real time, with no external dependencies, and no compromise.

The concept was pioneered by engineers at Airbnb. This package was rebuilt from the ground up to meet the demands of modern Swift, current Apple platform standards, and developers who expect their tools to simply work.

---

## What It Does

Designers create animations in After Effects. They export them as JSON using Bodymovin. This library takes that file and renders it — natively, on device, at 60 frames per second.

No web views. No video files. No runtime bloat. Just pure Swift, talking directly to Core Animation.

---

## Requirements

| Platform | Minimum |
|----------|---------|
| iOS      | 13.0    |
| macOS    | 10.15   |
| tvOS     | 13.0    |
| visionOS | 1.0     |

Xcode 15 or later. Swift 5.9 or later.

---

## Installation

### Swift Package Manager

In Xcode, go to **File → Add Package Dependencies** and enter:

```
https://github.com/Ajmalleonard/lottie-ios
```

Set the dependency rule to **Up to Next Major Version** from `4.6.2`. Add to your target. Done.

If resolution fails, go to **File → Packages → Reset Package Caches** and try again.

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

## Getting Started

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

## Adding Animations to Your App

Place your `.json` or `.lottie` file in your Xcode project. Make sure it is added to your app target — not just the project. Reference it by filename, without the extension:

```swift
LottieView(animation: .named("confetti"))
```

That is all there is to it.

---

## Playback

### Loop Modes

```swift
// Play once and stop
LottieView(animation: .named("checkmark"))
    .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))

// Loop forever
LottieView(animation: .named("spinner"))
    .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))

// Reverse after each cycle
LottieView(animation: .named("pulse"))
    .playing(.fromProgress(0, toProgress: 1, loopMode: .autoReverse))
```

### Speed

```swift
LottieView(animation: .named("loading"))
    .playing()
    .animationSpeed(2.0)
```

### Manual Scrubbing

```swift
struct ScrubView: View {
    @State private var progress: AnimationProgressTime = 0

    var body: some View {
        VStack {
            LottieView(animation: .named("timeline"))
                .currentProgress(progress)

            Slider(value: $progress, in: 0...1)
        }
    }
}
```

### Frame Range

```swift
LottieView(animation: .named("walkthrough"))
    .playing(.fromFrame(0, toFrame: 60, loopMode: .playOnce))
```

### Completion

```swift
LottieView(animation: .named("success"))
    .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
    .animationDidFinish { completed in
        guard completed else { return }
        // proceed
    }
```

---

## Loading Animations

### From the App Bundle

```swift
let animation = LottieAnimation.named("loading")
```

### From a URL

```swift
let animation = try await LottieAnimation.loadedFrom(
    url: URL(string: "https://example.com/animation.json")!
)
```

### From Raw Data

```swift
let data = try Data(contentsOf: fileURL)
let animation = try LottieAnimation(data: data)
```

### From a .lottie File

```swift
let dotLottie = try await DotLottieFile.named("my-animation")
```

---

## Dynamic Properties

Override colors, opacity, and values at runtime — without modifying the original file.

### Color

```swift
let colorProvider = ColorValueProvider(UIColor.systemBlue.lottieColorValue)

animationView.setValueProvider(
    colorProvider,
    keypath: AnimationKeypath(keypath: "**.Fill 1.Color")
)
```

### Opacity

```swift
let opacityProvider = FloatValueProvider(0.5)

animationView.setValueProvider(
    opacityProvider,
    keypath: AnimationKeypath(keypath: "**.Opacity")
)
```

### Images

```swift
let imageProvider = BundleImageProvider(bundle: .main, searchPath: "Images")
animationView.imageProvider = imageProvider
```

---

## Rendering Engine

The default rendering engine is Core Animation. It is fast, battery-efficient, and handles the vast majority of animations without issue.

```swift
var config = LottieConfiguration.shared
config.renderingEngine = .coreAnimation  // default
LottieConfiguration.shared = config
```

If an animation uses features not supported by Core Animation, the library falls back to the main thread renderer automatically.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Package resolution fails | File → Packages → Reset Package Caches, then re-add the package |
| Animation file not found | Confirm the file is added to the app target, not just the Xcode project |
| View appears empty | Validate the JSON at lottiefiles.com |
| Colors are wrong | Use `setValueProvider` with the correct keypath |
| Animation stutters | Ensure `renderingEngine` is set to `.coreAnimation` |
| .lottie file fails to load | Verify it is a valid zipped Lottie bundle with the `.lottie` extension |

---

## License

Apache License 2.0. See [LICENSE](LICENSE) for the full terms.

---

## On Origins

The Lottie format and the idea of rendering After Effects animations natively were conceived by the engineering team at Airbnb. That work changed how the industry thinks about animation on mobile.

This package is not a fork. It is an independent implementation — rebuilt for Swift 5.9, modern Apple platforms, and the principle that a dependency should do one thing exceptionally well, carry nothing it does not need, and stay out of your way.
