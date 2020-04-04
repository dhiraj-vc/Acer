# Aser
```
/**
*
*@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
*@author     : Shiv Charan Panjeta < shiv@toxsl.com >
*
* All Rights Reserved.
* Proprietary and confidential :  All information contained herein is, and remains
* the property of ToXSL Technologies Pvt. Ltd. and its partners.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/
```

## Installation
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Pods into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!
# Pods for ASER

target '<Your Target Name>' do
# Pods for ASER
pod 'Alamofire'
pod 'IQKeyboardManagerSwift'
pod 'SDWebImage'
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'NVActivityIndicatorView'
pod 'CropViewController', '~> 2.3'
pod 'TwitterKit'
pod 'AFNetworking'

end
```

Then, run the following command:

```bash
$ pod install
```
