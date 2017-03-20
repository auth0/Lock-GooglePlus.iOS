// GoogleNativeTransaction.swift
//
// Copyright (c) 2017 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Auth0
import GoogleSignIn

class GoogleNativeTransaction: NSObject, NativeAuthTransaction {

    var connection: String
    var scope: String
    var parameters: [String : Any]
    var authentication: Authentication
    var scopes: [String]

    public init(connection: String, scope: String, parameters: [String: Any], authentication: Authentication, scopes: [String]) {
        self.connection = connection
        self.scope = scope
        self.parameters = parameters
        self.authentication = authentication
        self.scopes = scopes
    }

    var delayed: NativeAuthTransaction.Callback = { _ in }

    func auth(callback: @escaping NativeAuthTransaction.Callback) {
        GIDSignIn.sharedInstance().scopes = self.scopes
        GIDSignIn.sharedInstance().signIn()
        self.delayed = callback
    }

    func cancel() {
        logger("Google authentication cancelled")
        self.delayed(.failure(error: WebAuthError.userCancelled))
        self.delayed = { _ in }
    }

    func resume(_ url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
}

extension GoogleNativeTransaction: GIDSignInDelegate {

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            logger("Google authentication failed with error: \(error)")
            return self.cancel()
        }
        logger("Google authenticated user: \(user.userID) with scopes: \(user.accessibleScopes)")
        self.delayed(.success(result: NativeAuthCredentials(token: user.authentication.accessToken, extras: [:])))
        self.delayed = { _ in }
    }
}

extension GoogleNativeTransaction: GIDSignInUIDelegate {

    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        ControllerModalPresenter().present(controller: viewController)
    }
}
