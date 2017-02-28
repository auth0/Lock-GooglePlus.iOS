# Lock-Google

[![Build Status](https://travis-ci.org/auth0/Lock-Google.iOS.svg?branch=master)](https://travis-ci.org/auth0/Lock-Google.iOS)
[![Version](https://img.shields.io/cocoapods/v/Lock-Google.svg?style=flat)](http://cocoapods.org/pods/Lock-Google)
[![License](https://img.shields.io/cocoapods/l/Lock-Google.svg?style=flat)](http://cocoapods.org/pods/Lock-Google)
[![Platform](https://img.shields.io/cocoapods/p/Lock-Google.svg?style=flat)](http://cocoapods.org/pods/Lock-Google)

[Auth0](https://auth0.com) is an authentication broker that supports social identity providers as well as enterprise identity providers such as Active Directory, LDAP, Google Apps and Salesforce.

Lock-Google helps you integrate native login with [Google Sign-In SDK for iOS](https://developers.google.com/identity/sign-in/ios/) and [Lock](https://auth0.com/lock)

## Usage

## Requirements

- iOS 9 or later
- Xcode 8
- Swift 3.0

## Install

Unfortunately as Google Sign-In SDK for iOS is a static framework as of version 4.0+.  It is no longer possible for us to bundle it into a Pod for you to integrate and is fundamentally incompatible with Carthage.

### CocoaPods

If you are using CocoaPods you can add the dependencies directly to your project.
Add the [Google Sign-In](https://developers.google.com/identity/sign-in/ios/start-integrating) and [Auth0](https://github.com/auth0/Auth0.swift) library to your project. Add the following to your `Podfile`:

```ruby
pod 'Auth0', '~> 1.2'
pod 'GoogleSignIn', '~> 4.0'
```

### Carthage

If you are using carthage you can install the Auth0 dependency.

```ruby
github "auth0/Auth0.swift" ~> 1.2
```

However you will need to follow the [manual install guide](https://developers.google.com/identity/sign-in/ios/sdk/) for Google Sign-In.

### Source Code

You will need to download and add the following files to your project:

* [GoogleNativeTransaction.swift](https://raw.githubusercontent.com/auth0/Lock-Google.iOS/new_native_demo/LockGoogle/GoogleNativeTransaction.swift)
* [LockGoogle.swift](https://raw.githubusercontent.com/auth0/Lock-Google.iOS/new_native_demo/LockGoogle/LockGoogle.swift)

## Before you start using Lock-Google

In order to use Google APIs you'll need to register your iOS application in [Google Developer Console](https://console.developers.google.com/project) and get your clientId.
We recommend following [this wizard](https://developers.google.com/mobile/add?platform=ios) instead and download the file `GoogleServices-Info.plist` that is generated at the end.

> For more information please check Google's [documentation](https://developers.google.com/identity/sign-in/ios/)

### Auth0 Connection with multiple Google clientIDs (Web & Mobile)

If you also have a Web Application, and a Google clientID & secret for it configured in Auth0, you need to whitelist the Google clientID of your mobile application in your Auth0 connection. With your Mobile clientID from Google, go to [Social Connections](https://manage.auth0.com/#/connections/social), select **Google** and add the clientID to the field named `Allowed Mobile Client IDs`

## Usage

Just create a new instance of `LockGoogle` with your Google App *CLIENT ID*, you can find this in the `GoogleServices-Info.plist` you added to the project.

```swift
let lockGoogle = LockGoogle(client: "<YOUR CLIENT ID>")
```

You can register this handler to a connection name when setting up Lock.

```swift
.handlerAuthentication(forConnectionName: "google-oauth2", handler: lockGoogle)
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

[Auth0](auth0.com)

## License

Lock-Google is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
