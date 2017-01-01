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
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AccessToken.refreshCurrentToken { (accessToken, error) in
            if AccessToken.current != nil {
                self.loginFacebook()
            }
            else
            {
                let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
                loginButton.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height * 0.95)
                loginButton.delegate = self
                self.view.addSubview(loginButton)
            }
        }
    }
    
    func loginFacebook() {
        guard let accessToken = AccessToken.current?.authenticationToken,
              let userId = AccessToken.current?.userId else {
                return
        }
        let MainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! MyTabBarController
        
        SingleTone.shareInstance.userId = userId
        SingleTone.shareInstance.accessToken = accessToken
        
        self.navigationController!.pushViewController(MainTabBarController, animated: true)
        
    }
}

extension LoginViewController : LoginButtonDelegate{
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult){
        switch result {
        case .success(_ , _ ,let accesToken):
            print(accesToken)
            print("Token = \(AccessToken.current?.authenticationToken)")
            print("User ID = \(AccessToken.current?.userId)")
            testLabel.text = "success"
        case .cancelled:
            print("cancelled")
            testLabel.text = "cancel"
            break
        case .failed(_):
            print(" error :(")
            testLabel.text = "failed"
            break
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton){
        print("user logged out")
    }
}
