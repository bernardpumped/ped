# Pumped End Device - PED IVI

Pumped Fuel is an amalgamation of three pivotal projects aimed at bridging the gap between motorists and retail merchants. Our initial focus is on fuel stations,
where we strive to provide drivers with the most affordable fuel prices, nearest locations, exceptional service, immaculate restrooms, and the finest coffee,
among other amenities. We are swiftly expanding our services to include EV Charging, Auto Service & Stores.

Our long-term goal is to foster a symbiotic relationship between the Automotive and Retail industries through the use of Generative AI.
Our forthcoming In-Vehicle Infotainment (IVI) journey concierge is a testament to this vision. For instance, if you’re en route to Westfield,
our platform will be able to assist you in finding outlets that offer shoes to complement your new dress.

The PED project, which is the end device of the trio, is engineered to accommodate both mobile phones and IVI, promoting seamless vehicle integration.

This particular branch is specifically designed for IVI landscape orientation

- It Does not include Backend-as-a-Service (BaaS) or Social Media Platforms, as these integrations will be dependent on the vehicle manufacturer.
- Won't build android in current state switch to main for android

- Tested on

  - Ubuntu 20 (x86_64 arm64)
  - Ubuntu 22 (x86_64)
  - Fedora 38 (x86_64)
  - Windows 10 (x86_64)
  - MacOS 13-14 (x86_64 arm64)

- Tested Against

  - web
  - ios simulator iPad Pro
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
    flutter build [ linux | web ]
    flutter run
```
