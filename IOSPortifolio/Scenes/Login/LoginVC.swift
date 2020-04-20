//
//  LoginVC.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 17/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import UIKit

class LoginVC: ViewController {
    
    private lazy var loginModel = LoginViewModel()
    
    @IBOutlet weak var userInputText: UITextField!
    @IBOutlet weak var passwordInputText: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /**
     Login button
     */
    @IBAction func tapLoginBtn(_ sender: UIButton) {
        if userInputText.text ?? "" == "" && passwordInputText.text ?? "" == "" {
            return AlertDialogManager.ShowAlertDialog(title: "Error in login", message: "Password or user name fiels must be not empty", self)
        }
        self.loginModel.login(user: userInputText.text!, password: passwordInputText.text!)
        
        self.setNewRootControler(storyboardID: "MainTabVC", storyboardName: "Home")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
