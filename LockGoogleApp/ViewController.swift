//
//  ViewController.swift
//  LockGoogleApp
//
//  Created by Martin Walsh on 25/01/2017.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit
import Auth0
import LockGoogle

public class PluginManager {
    static let sharedInstance = PluginManager()
    let lockGoogle = LockGoogle(client: "220613544498-ht0o1oon3259e86jtfmn3td36c497i76.apps.googleusercontent.com")

    private init() {}
}

class ViewController: UIViewController {

    let lockGoogle = PluginManager.sharedInstance.lockGoogle

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = UIButton(type: .roundedRect)
        loginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        loginButton.center = view.center;
        loginButton.setTitle("Login Google Sign-In", for: .normal)
        loginButton.addTarget(self, action: #selector(login(button:)), for: .touchUpInside)

        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func login(button: UIButton) {

        lockGoogle.login("google-oauth2", scope: "openid", parameters: [:]) { result in
            switch result {
            case .success(let credentials):
                print("Login Success, accessToken: \(credentials.accessToken)")
            case .failure(let error):
                print("Login Failed, error: \(error)")
            }
        }

    }
}

