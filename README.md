# Lock-GooglePlus

[![Build Status](https://travis-ci.org/auth0/Lock-GooglePlus.iOS.svg?branch=master)](https://travis-ci.org/auth0/Lock-GooglePlus.iOS)
[![Version](https://img.shields.io/cocoapods/v/Lock-GooglePlus.svg?style=flat)](http://cocoapods.org/pods/Lock-GooglePlus)
[![License](https://img.shields.io/cocoapods/l/Lock-GooglePlus.svg?style=flat)](http://cocoapods.org/pods/Lock-GooglePlus)
[![Platform](https://img.shields.io/cocoapods/p/Lock-GooglePlus.svg?style=flat)](http://cocoapods.org/pods/Lock-GooglePlus)

##IMPORTANT: Due to Apple [rejecting applications](https://code.google.com/p/google-plus-platform/issues/detail?id=900) using Google+ SDK because of using Safari to authenticate we recommend to avoid using this library until Google fixes its SDK.

[Auth0](https://auth0.com) is an authentication broker that supports social identity providers as well as enterprise identity providers such as Active Directory, LDAP, Google Apps and Salesforce.

Lock-GooglePlus helps you integrate native Login with [Google+ iOS SDK](https://developers.google.com/+/mobile/ios/) and [Lock](https://auth0.com/lock)

## Requierements

iOS 7+

## Install

The Lock-GooglePlus is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "Lock-GooglePlus", "~> 1.0"
```


Then in your project's `Info.plist` file register a custom URL Type using your app's bundle identifier. For more information please check [Google+ Getting Started Guide](https://developers.google.com/+/mobile/ios/getting-started).

## Usage

Just create a new instance of `A0GooglePlusAuthenticator`

```objc
A0GooglePlusAuthenticator *googlePlus = [A0GooglePlusAuthenticator newAuthenticatorWithClientId:@"G+_CLIENT_ID"];
```

```swift
let googlePlus = A0GooglePlusAuthenticator.newAuthenticatorWithClientId("G+_CLIENT_ID")
```

> The G+ client id can be obtained from Google's API Dashboard, for more info please check this [guide](https://developers.google.com/+/mobile/ios/getting-started)

and register it with your instance of `A0Lock`

```objc
A0Lock *lock = //Get your A0Lock instance
[lock registerAuthenticators:@[googlePlus]];
```

```swift
let lock:A0Lock = //Get your A0Lock instance
lock.registerAuthenticators([googlePlus])
```

> A good place to create and register `A0GooglePlusAuthenticator` is the `AppDelegate.m` or `AppDelegate.swift` files.


##API

###A0GooglePlusAuthenticator

####A0GooglePlusAuthenticator#newAuthenticatorWithClientId
```objc
+ (A0GooglePlusAuthenticator *)newAuthenticatorWithClientId:(NSString *)clientId;
```
Create a new 'A0GooglePlusAuthenticator' using a G+ client identifier
```objc
A0GooglePlusAuthenticator *googlePlus = [A0GooglePlusAuthenticator newAuthenticatorWithClientId:@"G+_CLIENT_ID"];
```
```swift
let googlePlus = A0GooglePlusAuthenticator.newAuthenticatorWithClientId("G+_CLIENT_ID")
```

####A0GooglePlusAuthenticator#newAuthenticatorWithClientId:andScopes:
```objc
+ (A0GooglePlusAuthenticator *)newAuthenticatorWithClientId:(NSString *)clientId andScopes:(NSArray *)scopes;
```
Create a new 'A0GooglePlusAuthenticator' with a G+ client identifier and a list of scopes for G+ authentication
```objc
A0GooglePlusAuthenticator *googlePlus = [A0GooglePlusAuthenticator newAuthenticatorWithClientId:@"G+_CLIENT_ID" andScopes:@[@"profile"]];
```
```swift
let googlePlus = A0GooglePlusAuthenticator.newAuthenticatorWithClientId("G+_CLIENT_ID", andScopes:["profile"])
```

## Issue Reporting

If you have found a bug or if you have a feature request, please report them at this repository issues section. Please do not report security vulnerabilities on the public GitHub issue tracker. The [Responsible Disclosure Program](https://auth0.com/whitehat) details the procedure for disclosing security issues.

## What is Auth0?

Auth0 helps you to:

* Add authentication with [multiple authentication sources](https://docs.auth0.com/identityproviders), either social like **Google, Facebook, Microsoft Account, LinkedIn, GitHub, Twitter, Box, Salesforce, amont others**, or enterprise identity systems like **Windows Azure AD, Google Apps, Active Directory, ADFS or any SAML Identity Provider**.
* Add authentication through more traditional **[username/password databases](https://docs.auth0.com/mysql-connection-tutorial)**.
* Add support for **[linking different user accounts](https://docs.auth0.com/link-accounts)** with the same user.
* Support for generating signed [Json Web Tokens](https://docs.auth0.com/jwt) to call your APIs and **flow the user identity** securely.
* Analytics of how, when and where users are logging in.
* Pull data from other sources and add it to the user profile, through [JavaScript rules](https://docs.auth0.com/rules).

## Create a free account in Auth0

1. Go to [Auth0](https://auth0.com) and click Sign Up.
2. Use Google, GitHub or Microsoft Account to login.

## Author

Auth0

## License

Lock-GooglePlus is available under the MIT license. See the [LICENSE file](LICENSE) for more info.
