//
//  AlertDialogManager.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 19/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//


import UIKit

class AlertDialogManager {
    
    static func BuildAlertDialog(title: String, message: String, preferredStyle: UIAlertController.Style, handler: @escaping (UIAlertAction) -> Void) -> UIAlertController  {
        let ac = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle)
        ac.addAction(UIAlertAction.init(title: "OK", style: .default, handler: handler))
        return ac
    }
    
    /// Show an alert dialog, with a single AlertActions given by handler
    /// - Parameters:
    ///   - title: Title messafe of alert dialog.
    ///   - message: Message to be show in alert dialog
    ///   - handler: `UIAlertAction` to be added in alert dialog.
    ///   - vc: View controller reference to show dialog.
    static func ShowAlertDialog(title: String, message: String, handler: UIAlertAction,_ vc: UIViewController)  {
        let ac = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        ac.addAction(handler)
        vc.present(ac, animated: true, completion: nil)
    }
    
    
    /// Show an alert dialog, with multiple AlertActions given by handler
    /// - Parameters:
    ///   - title: Title messafe of alert dialog.
    ///   - message: Message to be show in alert dialog
    ///   - handler: `UIAlertAction` container to be added in alert dialog.
    ///   - vc: View controller reference to show dialog.
    static func ShowAlertDialog(title: String, message: String, handler: UIAlertAction...,vc: UIViewController)  {
        let ac = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for item in handler {
            ac.addAction(item)
        }
        vc.present(ac, animated: true, completion: nil)
    }
    
    /// Show an alert dialog, with multiple AlertActions given by handler
    /// - Parameters:
    ///   - title: Title messafe of alert dialog.
    ///   - message: Message to be show in alert dialog
    ///   - vc: View controller reference to show dialog.
    static func ShowAlertDialog(title: String, message: String,_ vc: UIViewController)  {
        let ac = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        // add default action
        ac.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        // show modal
        vc.present(ac, animated: true, completion: nil)
    }
    
    
    static func ShowInfoDialog(title: String, message: String, handler: UIAlertAction,_ vc: UIViewController)  {
        let ac = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(handler)
        vc.present(ac, animated: true, completion: nil)
    }
    
    static func ShowInfoDialog(title: String, message: String,_ vc: UIViewController)  {
        let ac = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        vc.present(ac, animated: true, completion: nil)
    }
    
    static func ShowError(_ error: TechnicalError, _ vc: UIViewController){
        var message: String = ""
        switch error.netError {
            
        case .invalidURL:
            FirebaseUtils.sharedRemoteInstance.SetValueByRemote(key: "error_invalid_url", typeOfValue: &message)
            
            AlertDialogManager.ShowAlertDialog(title: "Desculpe", message: message, handler: UIAlertAction.init(title: "OK", style: .default, handler: nil), vc)
            break
        case .badRequest:
            FirebaseUtils.sharedRemoteInstance.SetValueByRemote(key: "error_server_bad_request", typeOfValue: &message)
            
            AlertDialogManager.ShowAlertDialog(title: "Desculpe", message: message, handler: UIAlertAction.init(title: "OK", style: .default, handler: nil), vc)
            break
        case .badEndpoint:
            FirebaseUtils.sharedRemoteInstance.SetValueByRemote(key: "error_server_bad_endpoint", typeOfValue: &message)
            
            AlertDialogManager.ShowAlertDialog(title: "Desculpe", message: message, handler: UIAlertAction.init(title: "OK", style: .default, handler: nil), vc)
            break
        case .cannotFindHost:
            FirebaseUtils.sharedRemoteInstance.SetValueByRemote(key: "error_unavaliable_server", typeOfValue: &message)
            
            AlertDialogManager.ShowAlertDialog(title: "Desculpe", message: message, handler: UIAlertAction.init(title: "OK", style: .default, handler: nil), vc)
            break
        case .genericError:
            message = error.userMessage ?? ""
            AlertDialogManager.ShowAlertDialog(title: "Desculpe", message: message, handler: UIAlertAction.init(title: "OK", style: .default, handler: nil), vc)
            break
        case .notFound:
            FirebaseUtils.sharedRemoteInstance.SetValueByRemote(key: "error_server_not_found", typeOfValue: &message)
            
            AlertDialogManager.ShowAlertDialog(title: "Desculpe", message: message, handler: UIAlertAction.init(title: "OK", style: .default, handler: nil), vc)
            break
        case .serverError:
            FirebaseUtils.sharedRemoteInstance.SetValueByRemote(key: "", typeOfValue: &message)
            
            AlertDialogManager.ShowAlertDialog(title: "Desculpe", message: message, handler: UIAlertAction.init(title: "OK", style: .default, handler: nil), vc)
            break
        case .unauthorized:
            message = error.userMessage ?? ""
            AlertDialogManager.ShowAlertDialog(title: "Desculpe", message: message, handler: UIAlertAction.init(title: "OK", style: .default, handler: nil), vc)
            break
        case .none:
            message = error.userMessage ?? ""
                       AlertDialogManager.ShowAlertDialog(title: "Desculpe", message: message, handler: UIAlertAction.init(title: "OK", style: .default, handler: nil), vc)
        }
    }
}
