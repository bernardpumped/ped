# Simulator setup
xcrun simctl create iPhone13 com.apple.CoreSimulator.SimDeviceType.iPhone-13
xcrun simctl boot iPhone13
open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app
xcrun simctl privacy iPhone13 grant location com.example.pumped_end_device
# Launch integration test
flutter driver --target test_driver/main.dart
# Simulator teardown
xcrun simctl delete iPhone13