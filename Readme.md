<p align="center" >
<img src="https://raw.githubusercontent.com/Mumble-SRL/MBurger-iOS/master/Images/logo.png" alt="MBurger Logo" title="MBurger Logo">
</p>

![Test Status](https://img.shields.io/badge/documentation-100%25-brightgreen.svg)
![License: MIT](https://img.shields.io/badge/pod-v1.0-blue.svg)
[![CocoaPods](https://img.shields.io/badge/License-Apache%202.0-yellow.svg)](LICENSE)

# MBurgerSwift

MBurgerSwift is a client libary, written in Swift, that can be used to interact with the [MBurger](https://mburger.cloud/login) API. The minimum deployment target for the library is iOS 10.0.

# Installation

# Installation with CocoaPods

CocoaPods is a dependency manager for iOS, which automates and simplifies the process of using 3rd-party libraries in your projects. You can install CocoaPods with the following command:

```ruby
$ gem install cocoapods
```

To integrate the MBurgerSwift into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
platform :ios, '10.0'

target 'TargetName' do
    pod 'MBurgerSwift', git: 'https://github.com/Mumble-SRL/MBurgerSwift-iOS'
end
```

If you use Swift rememember to add `use_frameworks!` before the pod declaration.


Then, run the following command:

```
$ pod install
```

CocoaPods is the preferred methot to install the library.

# Manual installation

To install the library manually drag and drop the folder `MBurgerSwift` to your project structure in XCode. 

Note that `MBurgerSwift` has `MBNetworking (1.0)` and `SAMKeychain (1.5)` as dependencies, so you have to install also this libraries.

# Initialization

To initialize the SDK you have to create a token through the [dashboard](https://mburger.cloud/). Click on the settings icon on the top-right and create a API Key specifiyng the permissions.

![Dashboard image](https://raw.githubusercontent.com/Mumble-SRL/MBurger-iOS/master/Images/api_token.png)

Then in your `AppDelegate` `application:didFinishLaunchingWithOptions:` initialize the `MBManager` of the SDK setting a token like this:

```swift
import MBurgerSwift

...

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MBManager.shared.apiToken = "YOUR_API_TOKEN"
    return true
}
```

You will not be able to interact with the SDK if you don't initialize it with a correct token/key.

# Usage

Use the `MBClient` class to make all the request to the api to retrieve data from MBurger. All the api calls have a plural version and its singular counterpart. For example you can retrieve the list of blocks of the project or you can retrieve a single block giving its id.

# Project

You can retrieve the informations of the project like this:

```swift
MBClient.getProject(success: { project in

}, failure: { error in

})
```

# Blocks

You can retrieve the blocks of the project with the function `getBlocks(withParameters:Success:Failure` like this:

```swift

MBClient.getBlocks(success: { (blocks, paginationInfos) in

}, failure: { (error) in

})
```

The parameter `parameters` is an optional array of objects that conforms to the `MBParameter` protocol passed to the MBurger api as parameter. The majorityof the parameters that can be passed to the apis are already defined in the SDK and can be used after the initialization:

* `MBSortParameter`
* `MBPaginationParameter`
* `MBFilterParameter`
* `MBGeofenceParameter`

If you want to pass another type of parameter you can use the `MBGeneralParameter` class that can be initialized with a key and a value that will be passed to the apis.

So if you want to include a pagination parameter you can do like this:

**Swift**:

```swift
let paginationParam = MBPaginationParameter(skip: 0, take: 10)
MBClient.getBlocks(withParameters: [paginationParam], success: { (blocks, paginationInfos) in

}, failure: { (error) in

})
```

There is another version of the `getBlocksWithParameters:Success:Failure`,  that takes two adiitional parameter `includingSections` (a boolean that indicate whether or not include, for each block, the sections), and `includeElements` (a boolean value that do the same thing but for the elements of the sections).

So you could retrieve the informations of all the blocks, all the sections of the blocks and all the elements of the sections with this call:

**Swift**:

```swift
MBClient.getBlocks(withParameters: [paginationParam], includingSections: true, includeElements: true, success: { (blocks, paginationInfos) in

}, failure: { (error) in

})
```

# Sections

You can retrieve all the sections with a block with the given id with the function `getBlocksWithParameters:Success:Failure` like this:

**Objective-C**:

```objective-c
[MBClient getSectionsWithBlockId:THE_BLOCK_ID Parameters:nil Success:^(NSArray<MBSection *> *sections, MBPaginationInfo *pagintaionInfo) {
        
} Failure:^(NSError *error) {
        
}];
```

**Swift**:

```swift
MBClient.getSectionsWithBlockId(THE_BLOCK_ID, parameters: nil, success: { (sections, paginationInfos) in

}, failure: { (error) in

})
```

Like for the blocks there's a version of this function that takes a bool `includeElements` that indicate to include or not the elements of the section se if you want to retrieve all the sections of a block and their elements you can call:

**Objective-C**:

```objective-c
[MBClient getSectionsWithBlockId:THE_BLOCK_ID IncludeElement:TRUE Parameters:nil Success:^(NSArray<MBSection *> *sections, MBPaginationInfo *pagintaionInfo) {
        
} Failure:^(NSError *error) {
        
}];
```

**Swift**:

```swift
MBClient.getSectionsWithBlockId(THE_BLOCK_ID, parameters: nil, includeElements: true, success: { (sections, paginationInfos) in

}, failure: { (error) in

})
```

# Object mapping

The `MBSection` class has a commodity function that can be used to map the elements of the section to a custom object created by you. For Exaple if you have a `News` object like this

```objective-c
#import <Foundation/Foundation.h>

@interface News : NSObject

@property NSString *title;
@property NSString *content;
@property NSURL *imageUrl;
@property NSString *link;

@end
```

And a block in MBurger that represent a newsfeed you could create and populate an array of news object like this:

```objective-c
NSInteger newsBlockId = 12;
NSDictionary *mappingDictionary = @{@"title" : @"title",
                                    @"content" : @"content",
                                    @"image.firstImage.url" : @"imageUrl",
                                    @"link" : @"link"};
NSMutableArray *newsArray = [[NSMutableArray alloc] init];
[MBClient getBlockWithBlockId:newsBlockId Parameters:nil IncludingSections:YES AndElements:YES Success:^(MBBlock *block) {
   NSMutableArray *newsArray = [[NSMutableArray alloc] init];
   for (MBSection *section in block.sections){
        News *n = [[News alloc] init];
        [section mapElementsToObject:n withMapping:mappingDictionary];
        [newsArray addObject:n];
    }
 } Failure:^(NSError *error) {
    [self showError:error];
 }];
```

As you can see in the example you can point to the property of the object using the dot notation. If it's not defined any property the SDK will use the value of the element object (calling the value function).

You can find a complete example in the Example project.

# Serialization

All the object models implement the `Codable` protocol so you can serialize and deserialize them without having to implement it. Below the list of objects that implement those protocols

* `MBProject`
* `MBBlock`
* `MBSection`
* `MBElement`
* `MBTextElement`
* `MBImagesElement`
* `MBImage`
* `MBMediaElement`
* `MBFile`
* `MBCheckboxElement`
* `MBWysiwygElement`
* `MBDateElement`
* `MBAddressElement`
* `MBDropdownElement`
* `MBPollElement`
* `MBGeneralElement`
* `MBUser`

# Equality

All the model objects implement the `isEqual:` function based on the corresponding id. So for example an MBSection will result equal to another MBSection object if they have the same `sectionId`.

# Admin

Read the full admin documentation apis [here](https://github.com/Mumble-SRL/MBurger-iOS/tree/master/MBurger/MBAdmin).

# Authentication

Read the full admin documentation apis [here](https://github.com/Mumble-SRL/MBurger-iOS/tree/master/MBurger/MBAuth).

# Push notifications

Read the full push notifications documentation apis [here](https://github.com/Mumble-SRL/MBurger-iOS/tree/master/MBurger/MBPush).

# Plugins
You can add more to MBurger with plugins, classes that conforms to the `MPPlugin` protocol that can extend the functionalities of MBurger. An example of a plugin is [MPPayments](https://github.com/Mumble-SRL/MBPayments-iOS.git) a plugin that you to charge the users with single payments or sbscription.

# Documentation

For further information, you can check out the full SDK Reference in the [docs](docs) folder.


# Contacts

You can contuct us at [info@mumbleideas.it](mailto:info@mumbleideas.it).

# License

MBurger is released under the Apache 2.0 license. See [LICENSE](LICENSE) for details.
