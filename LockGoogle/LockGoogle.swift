// LockGoogle.swift
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
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
import LockNative

public class LockGoogle: NSObject, NativeAuthHandler {

    private let authentication = Auth0.authentication()

    private var connection: String?
    private var scope: String?
    private var parameters: [String: Any]?

    var onAuth: (Auth0.Result<Auth0.Credentials>) -> () = { _ in }

    required public init(client: String) {
        super.init()
        GIDSignIn.sharedInstance().clientID = client
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    public func login(_ connection: String, scope: String, parameters: [String : Any], callback: @escaping (Auth0.Result<Auth0.Credentials>) -> ()) {
        self.connection = connection
        self.scope = scope
        self.parameters = parameters
        self.onAuth = callback
        GIDSignIn.sharedInstance().signIn()
    }

    func socialAuthentication(withToken token: String) {
        guard let connection = connection, let scope = scope, let parameters = parameters else {
            return self.onAuth(Auth0.Result.failure(error: NativeAuthenticatableError.configuration))
        }
        
        authentication.loginSocial(token: token, connection: connection, scope: scope, parameters: parameters)
            .start { result in
                switch result {
                case .success(let credentials):
                    self.onAuth(Auth0.Result.success(result: credentials))
                case .failure(_):
                    self.onAuth(Auth0.Result.failure(error: NativeAuthenticatableError.couldNotAuthenticate))
                }
        }
    }

    @discardableResult
    public func resumeAuth(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
}

extension LockGoogle: GIDSignInDelegate {

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            return self.onAuth(Auth0.Result.failure(error: NativeAuthenticatableError.nativeIssue))
        }
        self.socialAuthentication(withToken: user.authentication.accessToken)
    }
}

extension LockGoogle: GIDSignInUIDelegate {

    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(viewController, animated: true, completion: nil)
        }
    }
}
