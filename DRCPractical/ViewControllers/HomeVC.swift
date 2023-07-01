//
//  HomeVC.swift
//  DRCPractical
//
//  Created by Akash Chaudhary on 01/07/23.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    static var storyboardInstance:HomeVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: HomeVC.identifier) as! HomeVC
    }


}
