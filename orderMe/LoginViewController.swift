//
//  LoginViewController.swift
//  orderMe
//
//  Created by Boris Gurtovyy on 12/30/16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        AccessToken.refreshCurrentToken { (accessToken, error) in
            if AccessToken.current != nil {
                self.loginFacebook()
            }
            else
            {
                let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
                loginButton.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height * 0.9)
                loginButton.delegate = self
                self.view.addSubview(loginButton)
            }
        }
    }
    
    func loginFacebook(later: Bool = false) {
        if !later {
        guard let accessToken = AccessToken.current?.authenticationToken,
              let userId = AccessToken.current?.userId else {
                return
        }
        SingleTone.shareInstance.userId = userId
        SingleTone.shareInstance.accessToken = accessToken
        }
        else {
            SingleTone.shareInstance.logInLater = true
        }
        let MainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! MyTabBarController
        MainTabBarController.selectedIndex = 1
        self.navigationController!.pushViewController(MainTabBarController, animated: true)
        
    }
    
    @IBAction func logInLaterButton(_ sender: AnyObject) {
        loginFacebook(later: true)
    }
    
}

extension LoginViewController : LoginButtonDelegate{
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult){
        switch result {
        case .success(_ , _ , _):
            self.loginFacebook()
        case .cancelled:
            print("cancelled")
            break
        case .failed(_):
            print(" error ")
            break
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton){
        print("user logged out")
    }
}
