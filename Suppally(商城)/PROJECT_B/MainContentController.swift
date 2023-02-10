//
//  MainContentController.swift
//  PROJECT_B
//
//  Created by 肖扬 on 2023/1/5.
//

import UIKit
import WebKit
import RxSwift


class MainContentController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, WKScriptMessageHandler {
    
    
    var webView : WKWebView?
    
    
    private let reloadBut: UIButton = {
        let but = UIButton()
        but.setTitle("An error occurred. Please try again.", for: .normal)
        but.titleLabel?.font = SFONT(13)
        but.setTitleColor(FONTCOLOR, for: .normal)
        but.layer.cornerRadius = 5
        but.layer.borderWidth = 1
        but.layer.borderColor = HCOLOR("#68B346").cgColor
        but.isHidden = true
        return but
    }()
    
    private let statusBar: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        img.image = LOIMG("header")
        //img.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5)
        return img
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addNotificationCenter()
        
        
        view.addSubview(statusBar)
        statusBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(statusBarH)
        }
        
        statusBar.layer.contentsRect = CGRectMake(0, (1 - (statusBarH / 75)), 1, statusBarH / 75)
               
        
        configWeb()
        
        view.addSubview(reloadBut)
        reloadBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 250, height: 40))
            $0.center.equalToSuperview()
        }
        
        reloadBut.addTarget(self, action: #selector(clickreloadAction), for: .touchUpInside)
        
    }
    

    func configWeb() {
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.setValue(true, forKey: "_allowUniversalAccessFromFileURLs")
        config.mediaTypesRequiringUserActionForPlayback = .all


        let pre = WKPreferences()
        pre.javaScriptCanOpenWindowsAutomatically = true
        pre.javaScriptEnabled = true

        config.preferences = pre
        
        let userContent = WKUserContentController()
        config.userContentController = userContent
                
        
        let jSStr = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width', 'initial-scale=1.0', 'maximum-scale=1.0', 'minimum-scale=1.0', 'user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"

        let wkUserScript = WKUserScript(source: jSStr, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        userContent.addUserScript(wkUserScript)
        
        userContent.add(self, name: "needLogin")
//        userContent.add(self, name: "appBack")
//        userContent.add(self, name: "getToken")
//        userContent.add(self, name: "getOrderID")
//        userContent.add(self, name: "getStoreID")


 
        webView = WKWebView.init(frame: .zero, configuration: config)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.scrollView.bounces = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.isScrollEnabled = false
        webView?.scrollView.delegate = self
        

        //监听网页加载进度
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        webView?.customUserAgent =  "ios_native"
        
        
        guard let url = URL(string: BASEURL) else {
            return
        }
        


        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        webView?.load(request)
        
        
        view.addSubview(webView!)
        webView?.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            //$0.top.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH)
        }
                

        
    }
    
    
    @objc private func clickreloadAction() {
        self.reloadBut.isHidden = true
        
        guard let url = URL(string: BASEURL) else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        webView?.load(request)
    }
    
    
    
    //监控网页加载进程
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {

            HUD_MB.loading("", onView: view)
            if CGFloat((webView?.estimatedProgress)!) >= 1.0 {
                HUD_MB.dissmiss(onView: self.view)
            }
        }
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController.init(title: "提示", message: message, preferredStyle: .alert);
        alertController.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: { (action) in
            print("点击了。。。。");
            completionHandler();
        }))
        self.present(alertController, animated: true) {
            print("gone。。。。");
        }
    }
    
    
    
    //与JS交互不需要返回
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        if message.name == "needLogin" {
            print("+++++++++++++++登录")
            let loginVC = LogInController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
        }
    }
    
    //与JS交互需要返回值的
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        
        
        
    }
    
    
    
    
    //出错信息
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error1")
        print(error.localizedDescription)
        self.reloadBut.isHidden = false
        
    }
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("error2")
        print(error.localizedDescription)
        self.reloadBut.isHidden = false
    }
    
    
    //白屏
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("aaa")
    }
    
    

    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
    }


    //禁止缩放
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    
    
    
    //通知
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(notiCenterAction_login(info:)), name: NSNotification.Name(rawValue: "login"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiCenterAction_back), name: NSNotification.Name(rawValue: "back"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    
//    @objc private func applicationWillResignActive() {
//        print("aaaa")
//    }
//
    
    @objc private func notiCenterAction_login(info: Notification) {
        
        print("login")
        
        let jsonStr = info.object as! String
        
        self.webView?.evaluateJavaScript("appLogin(\(jsonStr))", completionHandler: { jsmessage, err in
            print("成功回调\(String(describing: jsmessage)),\(String(describing: err))")
        })

    }
    
    

    @objc private func notiCenterAction_back() {
        
        print("back")
        self.webView?.evaluateJavaScript("appBack()", completionHandler: { jsmessage, err in
            print("成功回调\(String(describing: jsmessage)),\(String(describing: err))")
        })
        
    }

    
    
    deinit {
        
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "login"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "back"), object: nil)


        
        let userCC = self.webView?.configuration.userContentController

        guard let us = userCC else {
            return
        }
        if #available(iOS 14.0, *) {
            us.removeAllScriptMessageHandlers()
        } else {
            us.removeScriptMessageHandler(forName: "needLogin")
        }
    }
    

}
