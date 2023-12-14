# Flutter Pumped End Device - PED UI

PED is a developer demo that showcases the features and facilities of fuel stations, along with real-time fuel prices throughout Australia. We plan to include station promotions and offers soon, and have incorporated EV Charging stations within our platform, but they are yet to be displayed. We’ve received requests to expand overseas and are seeking the right opportunity for this expansion. Our ultimate goal is to integrate PED as an In-Vehicle Infotainment (IVI) app to facilitate seamless vehicle adoption. 
 
 
This branch, specifically designed for portrait orientation on Android and iPhone, includes integrations with Firebase and various social media platforms. To build this branch, you will need to supply your own API keys.


- Tested on

  - Windows 10 (x86_64)
  - MacOS 13-14 (x86_64 arm64)

- Tested Against
  - android
  - ios

### Installation

 - [windows](https://docs.flutter.dev/get-started/install/windows)
 - [macOS](https://docs.flutter.dev/get-started/install/macos) 
 - linux not supported on this branch


If new to flutter see [full PED documentation](https://github.com/bernardpumped/ped/blob/main/documentation/FULL-README.md) else do following  
where android flavors are debugApp, releaseApp and playStoreApp and iOS arriving shortly 

```
    cd <your flutter workspace>
    git clone https://github.com/bernardpumped/ped -b [ main | next_main]
    flutter create .
    flutter pub get
    flutter build appbundle --flavor <flavorApp>
    flutter build apk --flavor <flavorApp>
    flutter run appbundle --flavor  <flavorApp>
```
