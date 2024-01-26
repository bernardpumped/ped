# Pumped End Device - PED UI main

Pumped Fuel is an amalgamation of three pivotal projects aimed at bridging the gap between motorists and retail merchants. Our initial focus is on fuel stations,
where we strive to provide drivers with the most affordable fuel prices, nearest locations, exceptional service, immaculate restrooms, and the finest coffee,
among other amenities. We're next extending for EV Charging, Auto Service & Spare parts.

Our goal is to foster a symbiotic relationship between the Automotive and Retail industries through the use of Generative AI.
Our forthcoming 4th project In-Vehicle Infotainment (IVI) journey concierge is a testament to this [vision](https://ped-recordings.s3.ap-southeast-2.amazonaws.com/AIRetailConciergeVideo-02.mp4)

PED this project, is the end device of the consortium, and engineered to accommodate both mobile phones and a differing array of In-vehicle Infotainment (IVI) systems, promoting seamless vehicle integration.  

This "main" branch is specifically designed for portrait orientation on Android and iPhone. It includes integrations with Firebase and various social media platforms that you need to supply your own API keys to build.  
Incidentally [meta-flutter](https://github.com/meta-flutter/meta-flutter) made changes to permit Linux and showed at CES 2024, time permiting I'll make those changes here.

Important  
each branch has differences that over time will diverge significantly therefore review the specific branch README you're interested in, as following is main specific. Also if you're new to flutter you may wish to review [full PED documentation](https://github.com/bernardpumped/ped/blob/main/documentation/FULL-README.md)  

Lastly although our aspirations is to cover the world we'll do so one country at a time starting with Oz therefore if you reside outside of Australia once app is built when launching you'll see message "No Nearby Station" at which time follow this clip to [mock your location](https://ped-recordings.s3.ap-southeast-2.amazonaws.com/iphone15-Sim-NoNearbyStations.mp4)  


- Tested on
  - Windows 10 (x86_64)
  - MacOS 13-14 (x86_64 arm64)
  - Fedora 38 [Workspace-automation](https://github.com/meta-flutter/workspace-automation) - wip
    
- Tested Against
  - android
  - iOS
  - [Workspace-automation](https://github.com/meta-flutter/workspace-automation) desktop-auto - wip

### Installation

 - [windows](https://docs.flutter.dev/get-started/install/windows)
 - [macOS](https://docs.flutter.dev/get-started/install/macos) 
 - linux see [Workspace-automation](https://github.com/meta-flutter/workspace-automation) - wip


```
    cd <your flutter workspace>
    git clone https://github.com/bernardpumped/ped -b < main | next_main >
    flutter create .
    flutter pub get

build
android flavors debugApp, releaseApp and playStoreApp 
    flutter build appbundle --flavor <flavorApp>
    flutter build apk --flavor <flavorApp>

iOS flavors not yet implemented
    flutter build ios
    flutter build ipa
    flutter run -d [ <emulator> | <simulator> ]

Linux to be confirmed

Run all platforms
    flutter run -d <device> --<release> 
```
