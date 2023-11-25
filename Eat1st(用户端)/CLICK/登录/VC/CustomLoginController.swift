//
//  CustomLoginController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/9/7.
//

import UIKit
import FirebaseAuthUI
import FirebaseEmailAuthUI



class CustomLoginController: FUIAuthPickerViewController {
    
    
    
    private let titImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("hello")
        return img
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(15), .left)
        lab.text = "Place select login method"
        return lab
    }()
    
    
    private lazy var xyView: LoginBottomView = {
        let tview = LoginBottomView()
        
        tview.clickBlock = { [unowned self] (str) in
            if str == "ys" {
                print("ys")
                
                let webVC = ServiceController()
                webVC.titStr = "Privacy Policy"
                webVC.webUrl = "http://deal.foodo2o.com/privacy_policy.html"
                self.present(webVC, animated: true, completion: nil)
            }
            
            if str == "fw" {
                print("fw")
                
                let webVC = ServiceController()
                webVC.titStr = "Terms of Service"
                webVC.webUrl = "http://deal.foodo2o.com/terms_of_service.html"
                self.present(webVC, animated: true, completion: nil)
            }
        }
        
        return tview
        
    }()

        
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: LOIMG("log_backimg"))
        
        view.addSubview(titImg)
        titImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(28)
            $0.top.equalToSuperview().offset(statusBarH + 90)
        }
        
        view.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(28)
            $0.top.equalTo(titImg.snp.bottom).offset(50)
        }
        
        view.addSubview(xyView)
        xyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 280, height: 30))
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        
        self.navigationController?.navigationBar.barTintColor = MAINCOLOR
        
    
        let backButton = UIButton()
        backButton.setImage(LOIMG("nav_back"), for: .normal)
        backButton.addTarget(self, action: #selector(cancelAuthorization), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: FONTCOLOR]
        
        //标题颜色
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]

        self.title = "Eat1st"
    }
}
