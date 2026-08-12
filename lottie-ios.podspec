Pod::Spec.new do |s|
  s.name             = 'lottie-ios'
  s.version          = '4.6.2'
  s.summary          = 'A lightweight Swift library to render After Effects animations natively on Apple platforms.'

  s.description      = <<-DESC
Lottie is a Swift library for iOS, macOS, tvOS, and visionOS that renders
Adobe After Effects animations exported as JSON with Bodymovin, natively on device.

This package is an independent reconstruction supporting Swift 5.9+, modern SwiftUI APIs,
and current Apple platform requirements — with zero external dependencies.
  DESC

  s.homepage         = 'https://github.com/Ajmalleonard/lottie-ios'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'Ajmal Leonard' => '' }
  s.source           = { :git => 'https://github.com/Ajmalleonard/lottie-ios.git', :tag => s.version.to_s }

  s.swift_version           = '5.9'
  s.ios.deployment_target   = '13.0'
  s.osx.deployment_target   = '10.15'
  s.tvos.deployment_target  = '13.0'
  s.visionos.deployment_target = '1.0'

  s.source_files = 'Sources/**/*.swift'
  s.resource_bundles = { 'Lottie' => ['Sources/PrivacyInfo.xcprivacy'] }

  s.exclude_files = [
    'Sources/Private/EmbeddedLibraries/README.md',
    'Sources/Private/EmbeddedLibraries/ZipFoundation/README.md',
    'Sources/Private/EmbeddedLibraries/EpoxyCore/README.md',
    'Sources/Private/EmbeddedLibraries/LRUCache/README.md'
  ]
end
