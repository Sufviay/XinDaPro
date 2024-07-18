//
//  XYViewController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/1/14.
//

import UIKit
import WebKit



class XYViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {

    var webView : WKWebView?
    var webUrl = ""
    var titStr = ""
    
//    let progressView: UIProgressView = {
//        let progress = UIProgressView()
//        progress.progressTintColor = MAINCOLOR
//        progress.trackTintColor = .clear
//        return progress
//    }()

    override func setViews() {
        configWeb()
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = titStr
        self.naviBar.leftImg = LOIMG("nav_back_w")
        self.naviBar.rightBut.isHidden = true
        
//        progressView.frame = CGRect(x: 0, y: statusBarH + 44, width: S_W, height: 2)
//        progressView.isHidden = true
//        
//        UIView.animate(withDuration: 1) {
//            self.progressView.progress = 0.0
//        }

    }
    
    override func clickLeftButAction() {
        
        self.dismiss(animated: true)

    }
    
    
    func configWeb() {
        let config = WKWebViewConfiguration()
        
        let userContent = WKUserContentController()
        
//        userContent.add(self as! WKScriptMessageHandler, name: "webViewApp")
        
        config.userContentController = userContent
        
        
        webView = WKWebView.init(frame: .zero, configuration: config)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        print(webUrl)
        //监听网页加载进度
        //webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        guard let url = URL(string: webUrl) else {
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
        webView?.load(request)
        self.view.addSubview(webView!)
        //self.view.addSubview(progressView)
        
        webView?.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
        
    }
    
    
    //监控网页加载进程
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "estimatedProgress" {
//            progressView.isHidden = false
//            self.progressView.setProgress( Float((self.webView?.estimatedProgress)!), animated: true)
//            
//            if CGFloat((webView?.estimatedProgress)!) >= 1.0 {
//                self.progressView.isHidden = true
//                self.progressView.setProgress(0, animated: false)
//            }
//        }
//    }

    

    deinit {
        //webView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
