# Pumped End Device - PED IVI_localstore

This branch is designed for IVI landscape orientation and has the following restrictions/features  
It is for IVI testing only of new feature and data storage is non-secure  


- Location services, we currently use [Geolocator](https://pub.dev/packages/geolocator), which does not support Linux. We will soon rectify this by adding [geoclue](https://pub.dev/packages/geoclue) for Linux. In the interim, if running PED on Platform.isLinux or kIsWeb, we mock your location to Sydney Australia. You can subsequently change in Settings\ Developer Options\ Device Location mocking\ Pin a Location
- Does not Support Secure Storage


### Tested on

  - Ubuntu 20 (x86_64 arm64)
  - Ubuntu 22 (x86_64)
  - Fedora 38 (x86_64)
  - Windows 10 (x86_64)
  - MacOS 13-14 (x86_64 arm64)

### Tested Against

  - web - chrome all platforms
  - ios - device & simulator macOS
  - linux-desktop
  - custom-device
  - [Meta Flutter Workspace Automation](https://github.com/meta-flutter/workspace-automation)
  - Apple CarPlay - wip
  - [Android Autmotive](https://source.android.com/docs/automotive/start/what_automotive) - pending
  - [Automotive Grade Linux](https://www.automotivelinux.org) - pending
  

### Installation
  - Linux 
    - [Flutter linux](https://docs.flutter.dev/get-started/install/linux)
  - macOS
    - [macOS](https://docs.flutter.dev/get-started/install/macos)
  -  Android
     - Currently broken fix imminent, in interim switch to main for android
 
```
    cd <your flutter workspace>
    git clone https://github.com/bernardpumped/ped -b < agl | ivi_* >
    flutter create .
    flutter pub get
    flutter build < linux | custom-device | web | ios >
    flutter run
```
