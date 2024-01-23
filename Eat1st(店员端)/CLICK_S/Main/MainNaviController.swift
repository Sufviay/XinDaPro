//
//  MainNaviController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

import UIKit
import AuthenticationServices

class MainNaviController: UINavigationController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.isLogin {
            setViewControllers([DeskListController()], animated: false)
        } else {
            setViewControllers([LogInController()], animated: false)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

}
