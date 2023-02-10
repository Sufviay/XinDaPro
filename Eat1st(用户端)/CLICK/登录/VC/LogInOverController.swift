//
//  LogInOverController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/10.
//

import UIKit

class LogInOverController: BaseViewController {
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(33), .center)
        lab.text = "Eat1st"
        return lab
    }()


    override func setViews() {
        view.backgroundColor = MAINCOLOR
        
        self.naviBar.isHidden = true
        
       
        view.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if !UserDefaults.standard.isLogin {
//            FirebaseLoginManager.shared.doLogin {
//                //登录成功之后
//                NotificationCenter.default.post(name: NSNotification.Name("loginSuccess"), object: nil)
//            }
//        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
