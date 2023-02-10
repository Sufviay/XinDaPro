//
//  FAQDetailController.swift
//  CLICK
//
//  Created by 肖扬 on 2022/2/21.
//

import UIKit
import RxSwift
import MessageUI

class FAQDetailController: BaseViewController, MFMailComposeViewControllerDelegate {
    
    var titleStr: String = ""

    private let bag = DisposeBag()
    
    var helpID: String = ""
    
    var orderID: String = ""
    
    ///（1邮件，2系统）
    private var type: String = "" {
        didSet {
 //           if type == "1" {
                self.bottomBut.setTitle("Email us", for: .normal)
//            }
//            if type == "2" {
//                self.bottomBut.setTitle("Complain", for: .normal)
//            }
        }
    }
    
    ///邮箱
    private var mail: String = ""
    
    
    
    private let bottomBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "", .white, BFONT(14), MAINCOLOR)
        return but
    }()
    
    private let richTextView: RichTextView = {
        let view = RichTextView()
        view.isScrollEnabled = true
        return view
    }()
    
    
    override func setViews() {
        
        view.addSubview(bottomBut)
        bottomBut.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(50)
        }
        
        view.addSubview(richTextView)
        richTextView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom)
            $0.bottom.equalTo(bottomBut.snp.top)
        }
        
        bottomBut.addTarget(self, action: #selector(clickAciton), for: .touchUpInside)
        
        loadData_Net()
    }

    override func setNavi() {
        self.naviBar.headerTitle = self.titleStr
        self.naviBar.headerBackColor = .white
        self.naviBar.leftImg = LOIMG("nav_back")
        
    }
    
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickAciton() {
//        if type == "1" {
            //发邮件
            sendEmail()
//        }
//        if type == "2" {
//
//            //新的投诉
//            let nextVC = AfterSalesController()
//            nextVC.orderID = self.orderID
//            self.navigationController?.pushViewController(nextVC, animated: true)
//
    }

    private func sendEmail() {
    
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            let emailVC = MFMailComposeViewController()
            //设置代理
            emailVC.mailComposeDelegate = self
            //设置主题
            emailVC.setSubject("#\(orderID)")
            //设置收件人
            emailVC.setToRecipients([mail])
             
            //打开界面
            self.present(emailVC, animated: true, completion: nil)
        }else{
            print("不支持")
        }
    }
    
    
    
    func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getHelpDetail(id: helpID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.type = json["data"]["plaintType"].stringValue
            self.mail = json["data"]["mail"].stringValue
            
            let richtext = json["data"]["content"].stringValue
            self.richTextView.richText = richtext
            
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //MARK: - Delegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        
        if result == .sent {
            HUD_MB.showSuccess("Success", onView: PJCUtil.getWindowView())
            controller.dismiss(animated: true, completion: nil)
        }
        if result == .failed {
            HUD_MB.showError("Failed", onView: self.view)
        }
        if result == .saved {
            HUD_MB.showSuccess("Saved", onView:  PJCUtil.getWindowView())
            controller.dismiss(animated: true, completion: nil)
        }
        if result == .cancelled {
            controller.dismiss(animated: true, completion: nil)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
