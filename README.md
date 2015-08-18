# Lock-Google

[![Build Status](https://travis-ci.org/auth0/Lock-Google.iOS.svg?branch=master)](https://travis-ci.org/auth0/Lock-Google.iOS)
[![Version](https://img.shields.io/cocoapods/v/Lock-Google.svg?style=flat)](http://cocoapods.org/pods/Lock-Google)
[![License](https://img.shields.io/cocoapods/l/Lock-Google.svg?style=flat)](http://cocoapods.org/pods/Lock-Google)
[![Platform](https://img.shields.io/cocoapods/p/Lock-Google.svg?style=flat)](http://cocoapods.org/pods/Lock-Google)

[Auth0](https://auth0.com) is an authentication broker that supports social identity providers as well as enterprise identity providers such as Active Directory, LDAP, Google Apps and Salesforce.

Lock-Google helps you integrate native login with [Google iOS SDK](https://developers.google.com/identity/sign-in/ios/) and [Lock](https://auth0.com/lock)

## Requierements

iOS 7+

## Install

The Lock-Google is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "Lock-Google", "~> 2.0"
```

## Before you start using Lock-Google

In order to use Google APIs you'll need to register your iOS application in [Google Developer Console](https://console.developers.google.com/project) and get your clientId.
We recommend follwing [this wizard](https://developers.google.com/mobile/add?platform=ios) instead and download the file `GoogleServices-Info.plist` that is generated at the end.

Add that file to your application's target and the last step is to register two custom URL for your application.

The first URL should have a scheme equal to your application Bundle Identifier, the other one should be your Google clientId reversed, so if your clientID is `com.googleusercontent.apps.CLIENTID` the scheme will be `CLIENTID.apps.googleusercontent.com`
> This last value can be found in `GoogleServices-Info.plist` under the key `REVERSED_CLIENT_ID`

> For more information please check Google's [documentation](https://developers.google.com/identity/sign-in/ios/)

## Usage

Just create a new instance of `A0GoogleAuthenticator`

```objc
A0GoogleAuthenticator *google = [A0GoogleAuthenticator newAuthenticator];
```

```swift
let google = A0GoogleAuthenticator.newAuthenticator()
```

and register it with your instance of `A0Lock`

```objc
A0Lock *lock = //Get your A0Lock instance
[lock registerAuthenticators:@[google]];
```

```swift
let lock:A0Lock = //Get your A0Lock instance
lock.registerAuthenticators([google])
```

> A good place to create and register `A0GoogleAuthenticator` is the `AppDelegate`.

###Specify scopes

```objc
A0GoogleAuthenticator *google = [A0GoogleAuthenticator newAuthenticatorWithScopes:@[@"scope1", @"scope2"]];
```

```swift
let google = A0GoogleAuthenticator.newAuthenticatorWithScopes(["scope1", "scope2"])
```

###Custom Google connection

```objc
A0GoogleAuthenticator *google = [A0GoogleAuthenticator newAuthenticatorWithConnectionName:@"my-google-connection"];
```

```swift
let google = A0GoogleAuthenticator.newAuthenticatorForConnectionName("my-google-connection")
```

> Please check CocoaDocs for more information about LockGoogle API.

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

Lock-Google is available under the MIT license. See the [LICENSE file](LICENSE) for more info.
