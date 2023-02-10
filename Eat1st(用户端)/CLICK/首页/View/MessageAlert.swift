//
//  MessageAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2022/9/19.
//

import UIKit
import WebKit
import RxSwift

class MessageAlert: BaseAlertView {

    
    private let bag = DisposeBag()
    
    var messageModel = MessageModel() {
        didSet {
            
            if messageModel.content != "" {
                let htmlStr = Tools.getHtmlStrWith(webStr: messageModel.content)
                webView.loadHTMLString(htmlStr, baseURL: nil)
            }
        }
    }

    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("msg_back")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("msg_close"), for: .normal)
        return but
    }()
    
    private let goBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("msg_backBut"), for: .normal)
        return but
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(20), .center)
        lab.text = "GO"
        return lab
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .center)
        lab.text = "System information"
        return lab
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#999999")
        return view
    }()
    
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#999999")
        return view
    }()

        
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        config.userContentController = userContent
        let view = WKWebView.init(frame: .zero, configuration: config)
        view.isOpaque = false
        view.backgroundColor = .clear
        view.scrollView.bounces = false
        view.scrollView.isScrollEnabled = true
        view.scrollView.backgroundColor = .clear
        view.scrollView.showsVerticalScrollIndicator = false
        view.scrollView.showsHorizontalScrollIndicator = false
        return view
    }()
    
    
    override func setViews() {
        
        self.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(285), height: SET_H(390, 285)))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        self.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backImg.snp.bottom).offset(10)
        }
        
        backImg.addSubview(goBut)
        goBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(265), height: SET_H(55, 265)))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        goBut.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-4)
        }
        
        backImg.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(R_H(130))
        }
        
        backImg.addSubview(line1)
        line1.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalTo(titlab.snp.left).offset(-14)
            $0.centerY.equalTo(titlab)
        }
        
        backImg.addSubview(line2)
        line2.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.right.equalToSuperview().offset(-15)
            $0.left.equalTo(titlab.snp.right).offset(14)
            $0.centerY.equalTo(titlab)
        }

        backImg.addSubview(webView)
        webView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(titlab.snp.bottom).offset(15)
            $0.bottom.equalTo(goBut.snp.top).offset(-10)
        }
        
        
        
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        goBut.addTarget(self, action: #selector(clickGoAciton), for: .touchUpInside)
    }
    
    
    @objc private func clickCloseAction()  {
        self.disAppearAction()
    }
    
    @objc private func clickGoAciton() {
        //查看消息 设置为已读
        
        HUD_MB.loading("", onView: PJCUtil.getWindowView())
        HTTPTOOl.doReadMessage(id: messageModel.id).subscribe(onNext: { (_) in
            HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
            self.disAppearAction()
            let detailVC = MessageDetailController()
            detailVC.dataModel = self.messageModel
            PJCUtil.currentVC()?.navigationController?.pushViewController(detailVC, animated: true)
            
        }, onError: { error in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
        }).disposed(by: self.bag)
        
        
    }

}
