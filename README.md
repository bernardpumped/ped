# Pumped End Device - PED UI

Pumped Fuel is an amalgamation of three pivotal projects aimed at bridging the gap between motorists and retail merchants. Our initial focus is on fuel stations, 
where we strive to provide drivers with the most affordable fuel prices, nearest locations, exceptional service, immaculate restrooms, and the finest coffee, 
among other amenities. We are swiftly expanding our services to include EV Charging, Auto Service & Stores.  

Our long-term goal is to foster a symbiotic relationship between the Automotive and Retail industries through the use of Generative AI. 
Our forthcoming In-Vehicle Infotainment (IVI) journey concierge is a testament to this vision. For instance, if you’re en route to Westfield, 
our platform will be able to assist you in finding outlets that offer shoes to complement your new dress.  

The PED project, which is the end device of the trio, is engineered to accommodate both mobile phones and IVI, promoting seamless vehicle integration. 
 
This particular branch is specifically designed for portrait orientation on Android and iPhone. It includes integrations with Firebase and various social media platforms.
To build this branch, you will need to supply your own API keys.


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
where android flavors are debugApp, releaseApp and playStoreApp 

```
    cd <your flutter workspace>
    git clone https://github.com/bernardpumped/ped -b < main | next_main >
    flutter create .
    flutter pub get
    flutter build appbundle --flavor <flavorApp>
    flutter build apk --flavor <flavorApp>
    flutter build ios
    flutter run -d [ <emulator> | <simulator> ]
```
