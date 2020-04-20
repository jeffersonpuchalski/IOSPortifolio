//
//  ViewController.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 17/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var imageArray : [UIImage] = [#imageLiteral(resourceName: "ic_OctoIrom"), #imageLiteral(resourceName: "ic_OctoCat")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /**
     Set new root controler by given StoryBoard ID and Storyboard name.
     - Parameters:
        - storyboardID: Storyboard ID from ViewController.
        - storyboardName: Storyboard name to look in Main bundle.
     */
    func setNewRootControler(storyboardID: String, storyboardName: String){
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardID)
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
    
    
    /**
     Choose a random image from image array. If we dont fine image
     otherwise we are returning default octo irom.
     - Parameter imageArr: Income array to be parsed and used.
     - Returns: Random image select from imageArr array.
     */
    func ChooseRandomImage(for imageArr: [UIImage]) -> UIImage {
        // Do not remove ic_OctoIrom or app will crash
        return imageArr.randomElement() ?? UIImage.init(named: "ic_OctoIron")!
        
    }
    
    /**
     Send whatsApp text using http request api.
     
     This method can only work with whatsapp installed, otherwise will throw an error.
     - Parameters:
        - text: Text to include on message.
        - number: Cellphone number to send to message.
     - Attention: **Cellphone** must have DDI and DDD (+55 for DDI and region DDD )
     */
    func whatsappShareText(text: String, number: String, vc: UIViewController )
    {
        // Sanitize number to avoid human mask
        let unmaskNunber = number.removeAllMaskCharacters()
        // Allow escape some characters.
        var characterSet = CharacterSet.urlQueryAllowed
         characterSet.insert(charactersIn: "?&")
        // Escape characters and set to whatsapp
        let unscapedString = "whatsapp://send?phone=\(unmaskNunber)&text=\(text)"
        let escapedString = unscapedString.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
        
        // Mount url and try open
        let url = URL(string: escapedString)

        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        } else {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id310633997"),
                UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    /**
     Share link using  whatsApp http api.
    - Parameters:
       - link: Text to include on share.
    */
    func whatsappShareLink(link: String)
    {
        let escapedString = link.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url = URL(string: "whatsapp://send?text=\(escapedString!)")

        if UIApplication.shared.canOpenURL(url! as URL)
        {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
}

