//
//  LoginVC.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 17/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import UIKit

class LoginVC: ViewController {
    
    @StorageCodable(key: "userInfo", defaultValue: UserResponse())
    var userInfo: UserResponse
    
    private lazy var loginModel = LoginViewModel()
    private var userDefaults: [String : String] {
        return self.loginModel.loadUser()
    }
    
    @IBOutlet weak var userInputText: UITextField!
    @IBOutlet weak var passwordInputText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if userDefaults["user"] != "" && userDefaults["password"] != ""{
            self.userInputText.text = userDefaults["user"]
            self.passwordInputText.text = userDefaults["password"]
        }
    }
    
    /**
     Login button
     */
    @IBAction func tapLoginBtn(_ sender: UIButton) {
        if userInputText.text ?? "" == "" && passwordInputText.text ?? "" == "" {
            return AlertDialogManager.ShowAlertDialog(title: "Error in login", message: "Password or user name fiels must be not empty", self)
        }
        let username = userInputText.text ?? ""
        let password = passwordInputText.text ?? ""
     
          self.loginModel.login(user: username, password: password){ result in
              DispatchQueue.main.async {
                  switch result {
                  case .success(let result):
                      self.userInfo = result ?? UserResponse()
                      self.setNewRootControler(storyboardID: "MainTabVC", storyboardName: "Home")
                  case .failure(let error):
                      AlertDialogManager.ShowAlertDialog(title: "Error in get user info", message: error.userMessage ?? "", self)
                      
                  }
              }
          }

    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
