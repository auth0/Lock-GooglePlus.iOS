// LockGoogle.swift
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

public struct LockGoogle: AuthProvider {

    private(set) var authentication: Authentication
    private(set) var scopes: [String] = ["profile"]

    public init(client: String, authentication: Authentication = Auth0.authentication()) {
        GIDSignIn.sharedInstance().clientID = client
        self.authentication = authentication
    }

    public func login(withConnection connection: String, scope: String, parameters: [String : Any]) -> NativeAuthTransaction {
        let transaction = GoogleNativeTransaction(connection: connection, scope: scope, parameters: parameters, authentication: self.authentication, scopes: self.scopes)
        GIDSignIn.sharedInstance().uiDelegate = transaction
        GIDSignIn.sharedInstance().delegate = transaction
        return transaction
    }

    public mutating func scopes(_ scopes: [String]) -> LockGoogle {
        self.scopes = scopes
        return self
    }

    public func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
}
