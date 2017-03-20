// ViewController.swift
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

import UIKit
import Auth0
import LockGoogle

class ViewController: UIViewController {

    var lockGoogle = LockGoogle(client: "220613544498-ht0o1oon3259e86jtfmn3td36c497i76.apps.googleusercontent.com")

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = UIButton(type: .roundedRect)
        loginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        loginButton.center = view.center
        loginButton.setTitle("Login Google Sign-In", for: .normal)
        loginButton.addTarget(self, action: #selector(login(button:)), for: .touchUpInside)

        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func login(button: UIButton) {
        lockGoogle
            .scopes(["profile", "email"])
            .login(withConnection: "google-oauth2", scope: "openid", parameters: [:])
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Login Success, accessToken: \(credentials.accessToken)")
                case .failure(let error):
                    print("Login Failed, error: \(error)")
                }
        }
        
    }
}
