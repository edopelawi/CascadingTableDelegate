pod install --project-directory=Example
xcodebuild \
  -workspace Example/CascadingTableDelegate.xcworkspace \
  -scheme CascadingTableDelegate-Example \
  -destination 'platform=iOS Simulator,name=iPhone 8' \
  clean test | xcpretty
