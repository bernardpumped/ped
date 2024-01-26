# Pumped End Device - PED UI next_main

This particular branch is "ahead" of main and is used predominantly for testing before main merging  

It is specifically designed for portrait orientation on Android and iPhone, and includes integrations with Firebase and various social media platforms.
To build this branch, you will need to supply your own API keys.

It was never meant to run on linux however [meta-flutter](https://github.com/meta-flutter/meta-flutter), [Workspace-automation](https://github.com/meta-flutter/workspace-automation) made changes internally and now it does therefore time permitting I'll make those changes here.


- Tested on
  - Windows 10 (x86_64)
  - MacOS 13-14 (x86_64 arm64)
  - Fedora 38 [Workspace-automation](https://github.com/meta-flutter/workspace-automation) - wip
- Tested Against
  - android
  - ios
  - [Workspace-automation](https://github.com/meta-flutter/workspace-automation) desktop-auto - wip

### Installation

- [windows](https://docs.flutter.dev/get-started/install/windows)
- [macOS](https://docs.flutter.dev/get-started/install/macos)
- linux see [Workspace-automation](https://github.com/meta-flutter/workspace-automation) - wip

If new to flutter see [full PED documentation](https://github.com/bernardpumped/ped/blob/main/documentation/FULL-README.md) else do following
where flavors are debugApp, releaseApp and playStoreApp

```
    cd <your flutter workspace>
    git clone https://github.com/bernardpumped/ped -b < main | next_main >
    flutter create .
    flutter pub get

    flutter build appbundle --flavor <flavorApp>
    flutter build apk --flavor <flavorApp>

ios flavors not yet implmented
    flutter build ios
    flutter build ipa
    flutter run -d [ <emulator> | <simulator> ]

All platforms
    flutter run -d <device> --<release>
```
