# Flutter Pumped End Device - PED

"PED is a developer demo, showcasing the display of fuel station contacts along with near real-time fuel prices across Australia. We envision a seamless integration of 'ped' within Flutter-based embedded vehicle systems. This particular branch, configured for web and desktop-linux in landscape mode, is optimally designed for In-Vehicle Infotainment (IVI) systems."

For full documentation see main branch

- Tested on Linux

  - Ubuntu 20 (x86_64 arm64)
  - Ubuntu 22 (x86_64)
  - Fedora 38 (x86_64)

- Tested Against
  - https://github.com/meta-flutter/workspace-automation
  - https://www.automotivelinux.org/ - pending

### Installation

https://docs.flutter.dev/get-started/install/linux

```
    cd <your flutter workspace>
    git clone https://github.com/bernardpumped/ped -b [ agl | ivi_* ]
    flutter create .
    flutter pub get
    flutter run
```
