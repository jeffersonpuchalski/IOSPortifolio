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
     Choose a random image from image array. If we dont fine image
     otherwise we are returning default octo irom.
     - Parameter imageArr: Income array to be parsed and used.
     - Returns: Random image select from imageArr array.
     */
    func ChooseRandomImage(for imageArr: [UIImage]) -> UIImage {
        // Do not remove ic_OctoIrom or app will crash
        return imageArr.randomElement() ?? UIImage.init(named: "ic_OctoIron")!
        
    }
    
}

