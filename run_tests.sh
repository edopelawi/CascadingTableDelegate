pod install --project-directory=Example
xcodebuild \
  -workspace Example/CascadingTableDelegate.xcworkspace \
  -scheme CascadingTableDelegate-Example \
  -destination 'platform=iOS Simulator,name=iPhone 5s' \
  clean test | xcpretty
