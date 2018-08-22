# ClickableImage

[![Version](https://img.shields.io/cocoapods/v/ClickableImage.svg?style=flat)](https://cocoapods.org/pods/ClickableImage)
[![License](https://img.shields.io/cocoapods/l/ClickableImage.svg?style=flat)](https://cocoapods.org/pods/ClickableImage)
[![Platform](https://img.shields.io/cocoapods/p/ClickableImage.svg?style=flat)](https://cocoapods.org/pods/ClickableImage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.0+

## Installation

ClickableImage is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ClickableImage'
```

## Usage

ClickableImage expands UIImageView by adding 3 methods and 1 computed property.

**Methods**:

- `enableClickableExpand()` - This method enables the image to become clickable to expand
- `disableClickableExpand()` - This method disables the image to become clickable to expand
- `toggleClickableExpand()` - This method toggles the state of whether the image is able to be clicked to expand

**Properties**:

- `isClickableExpandEnabled` - This property returns a `Bool` that represents if the image is able to be clicked to be expanded or not

## Author

rrainn, Inc., support@rrainn.com

## License

ClickableImage is available under the MIT license. See the LICENSE file for more info.
