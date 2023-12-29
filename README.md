# Pumped End Device - PED IVI

Pumped Fuel is an amalgamation of three pivotal projects aimed at bridging the gap between motorists and retail merchants. Our initial focus is on fuel stations,
where we strive to provide drivers with the most affordable fuel prices, nearest locations, exceptional service, immaculate restrooms, and the finest coffee,
among other amenities. We are swiftly expanding our services to include EV Charging, Auto Service & Stores.

Our long-term goal is to foster a symbiotic relationship between the Automotive and Retail industries through the use of Generative AI.
Our forthcoming In-Vehicle Infotainment (IVI) journey concierge is a testament to this vision. For instance, if you’re en route to Westfield,
our platform will be able to assist you in finding outlets that offer shoes to complement your new dress.

The PED project, which is the end device of the trio, is engineered to accommodate both mobile phones and IVI, promoting seamless vehicle integration.

This branch is temporary only and specifically designed for IVI landscape orientation and has the following restrictions/features

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
  - If you're new to flutter see [full PED documentation](https://github.com/bernardpumped/ped/blob/main/documentation/FULL-README.md) else do following

```
    cd <your flutter workspace>
    git clone https://github.com/bernardpumped/ped -b < agl | ivi_* >
    flutter create .
    flutter pub get
    flutter build < linux | web | ios >
    flutter run
```
