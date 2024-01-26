# Pumped End Device - PED IVI_secure

This branch specifically designed for IVI landscape orientation includes secure storage, and is our common foundation branch, before forking for embedded platforms of which we're considering [AGL](https://www.automotivelinux.org/), [SOAFEE](https://www.soafee.io/) in addition to CarPlay and Android Automotive.  

it has the following restrictions/features

- Location services, we currently use [Geolocator](https://pub.dev/packages/geolocator), which does not support Linux. We will soon rectify this by adding [geoclue](https://pub.dev/packages/geoclue) for Linux. In the interim, if running PED on Platform.isLinux or kIsWeb, we mock your location to Sydney Australia. You can subsequently change in Settings\ Developer Options\ Device Location mocking\ Pin a Location
- Supports Secure Storage


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
    - General [Securing Local Storage Flutter](https://blog.logrocket.com/securing-local-storage-flutter/#linux-configuration) info
    - Libsecret required for flutter_secure_storage
      - Debian/Ubunut :- $ sudo apt-get install libsecret-1-dev
      - Fedora/Centos :- $ sudo dnf install libsecret-devel jsoncpp-devel

    - Note within [Flutter linux](https://docs.flutter.dev/get-started/install/linux) - "prerequisites" following are distro dependant
      - Debian/Ubuntu :- $ sudo apt-get install libglu1-mesa libgtk-3-dev liblzma-dev libstdc++-12-dev
      - Fedora/Centos :- $ sudo dnf install mesa-libGLU gtk3-devel xz-devel 
 
  - macOS
    - [macOS](https://docs.flutter.dev/get-started/install/macos)
  -  Android
     - Currently broken fix WIP, in interim switch to main for android

```
    cd <your flutter workspace>
    git clone https://github.com/bernardpumped/ped -b < agl | ivi_* >
    flutter create .
    flutter pub get
    flutter build < linux | custom-device | web | ios >
    flutter run
```
