//
//  AppStoryboard.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 19/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//


import UIKit

/// Storyboard enum with name from storyboard file.
enum AppStoryboard : String {

    case Splash = "Splash"
    case Home = "Home"
    case Login = "Login"
    case Profile = "Profile"
    
    var instance : UIStoryboard {
      return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
           
           let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
           guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
               
               fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
           }
           
           return scene
       }
       
       func initialViewController() -> UIViewController? {
           return instance.instantiateInitialViewController()
       }
}

extension UIViewController{
   class var storyboardID : String {
       return "\(self)"
   }
   
   static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
       return appStoryboard.viewController(viewControllerClass: self)
   }
    
}
