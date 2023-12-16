# Flutter Pumped End Device - PED IVI

PED is a developer demo that showcases the features and facilities of fuel stations, along with real-time fuel prices throughout Australia. 
We plan to include station promotions and offers soon, and have incorporated EV Charging stations within our platform, but they are yet to be displayed.
We’ve received requests to expand overseas and are seeking the right opportunity for this expansion.
Our ultimate goal is to integrate PED as an In-Vehicle Infotainment (IVI) app to facilitate seamless vehicle adoption.

This branch, specifically designed for IVI landscape orientation, does not include Backend-as-a-Service (BaaS) or Social Media Platforms, as these integrations will be dependent on the vehicle manufacturer.


- Tested on

  - Ubuntu 20 (x86_64 arm64)
  - Ubuntu 22 (x86_64)
  - Fedora 38 (x86_64)
  - Windows 10 (x86_64)
  - MacOS 13-14 (x86_64 arm64)

- Tested Against

  - web
  - android
  - ios
  - linux-desktop
  - custom-devices - wip
  - Apple CarPlay - wip
  - [Android Autmotive](https://source.android.com/docs/automotive/start/what_automotive) - pending
  - [Automotive Grade Linux](https://www.automotivelinux.org) - pending

- Tested with

  - https://github.com/meta-flutter/workspace-automation - wip

### Installation

[linux](https://docs.flutter.dev/get-started/install/linux)

If new to flutter see [full PED documentation](https://github.com/bernardpumped/ped/blob/main/documentation/FULL-README.md) else do following  

```
    cd <your flutter workspace>
    git clone https://github.com/bernardpumped/ped -b [ agl | ivi_* ]
    flutter create .
    flutter pub get
    flutter run
```
