//
//  ContentController.swift
//  YaoShiPro
//
//  Created by 肖扬 on 2022/5/13.
//  Copyright © 2022 Baidu. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

class ContentController: BaseViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate {

    private let bag = DisposeBag()
    
    var orderID: String = ""
    
    var webView : WKWebView?
    var webUrl = ""
    var titStr = ""
    
    var storeID: String = ""
    
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .black.withAlphaComponent(0.4)
        but.layer.cornerRadius = 20
        but.setImage(LOIMG("nav_back_w"), for: .normal)
        return but
    }()
    
    

    override func setViews() {
        self.naviBar.isHidden = false
        configWeb()
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil]

        
    }
    
    @objc private func clickBackAction() {
        NotificationCenter.default.post(name: NSNotification.Name("orderList"), object: nil)
        self.dismiss(animated: true)
    }

    
//    override func setNavi() {
//        self.naviBar.headerTitle = titStr
//        self.naviBar.leftImg = LOIMG("YH_back_b")
//        self.naviBar.rightBut.isHidden = true
//
//        progressView.frame = CGRect(x: 0, y: statusBarH + 44, width: S_W, height: 2)
//        progressView.isHidden = true
//
//        UIView.animate(withDuration: 1) {
//            self.progressView.progress = 0.0
//        }

//    }
    
//    override func clickLeftButAction() {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    
    func configWeb() {
        let config = WKWebViewConfiguration()
        //config.allowsInlineMediaPlayback = true
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
                
        
        let jSStr = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"

        let wkUserScript = WKUserScript(source: jSStr, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        userContent.addUserScript(wkUserScript)
        
        userContent.add(self, name: "PrizeFinish")
//        userContent.add(self, name: "initLucky")
//        userContent.add(self, name: "startCallback")
        userContent.add(self, name: "getToken")
        userContent.add(self, name: "getOrderID")
        userContent.add(self, name: "getStoreID")

        
                
        webView = WKWebView.init(frame: .zero, configuration: config)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.scrollView.bouncesZoom = false
        webView?.scrollView.bounces = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.isScrollEnabled = false
        
//        print(webUrl)
        //监听网页加载进度
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView?.customUserAgent = "IOS"
        
        
        guard let url = URL(string: wheelURL) else {
            return
        }
        
//        guard let url = URL(string: V2URL + "prize/index.html") else {
//            return
//        }

        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
        webView?.load(request)
        
        
        self.view.addSubview(webView!)
        webView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        //self.view.addSubview(progressView)
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

//    deinit {
//        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        
        if prompt == "getOrderID" {
            print("+++++++++++++++++++++++ orderID")
            completionHandler(orderID)
            
        }
        if prompt == "getToken" {
            
            print("+++++++++++++++++++++++ getToken")
            completionHandler(UserDefaults.standard.token ?? "")
        }
        
        if prompt == "getStoreID" {
            print("++++++++++++++++++++++ getStoreID")
            completionHandler(storeID)
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
    
            
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        if message.name == "PrizeFinish" {
            print("PrizeFinish")
            ///刷新订单详情
            NotificationCenter.default.post(name: NSNotification.Name("orderList"), object: nil)
            self.dismiss(animated: true)
        }

//        if message.name == "initLucky" {
//            print("initLucky")
//            self.loadWheelData_Net()
//        }
//
//        if message.name == "startCallback" {
//            print("startCallback")
//            self.getPrize_Net()
//        }

    }
    
    
    
    
    
    
    //MARK: - 初始化轮盘数据
    private func loadWheelData_Net() {
        HUD_MB.loading("", onView: self.view)
        HTTPTOOl.getPrizeList().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            let jsonArr = json["data"].arrayObject
            let jsonStr = PJCUtil.convertArrayToString(array: jsonArr!)
            print(jsonStr)
            self.webView?.evaluateJavaScript("app.initLucky(\(jsonStr))")
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //MARK: - 获取中奖奖品
    private func getPrize_Net() {
        HTTPTOOl.doPrizeDraw(orderID: orderID).subscribe(onNext: { (json) in
            self.webView?.evaluateJavaScript("app.startCallback(\(json["data"].stringValue))")
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
        
    }
    
    
    
    //出错信息
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    
    //白屏
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("aaa")
    }
    
    
    deinit {
        
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        
        let userCC = self.webView?.configuration.userContentController
        
        guard let us = userCC else {
            return
        }
        if #available(iOS 14.0, *) {
            us.removeAllScriptMessageHandlers()
        } else {
            us.removeScriptMessageHandler(forName: "PrizeFinish")
            us.removeScriptMessageHandler(forName: "getToken")
            us.removeScriptMessageHandler(forName: "getOrderID")
            us.removeScriptMessageHandler(forName: "getStoreID")
        }
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

}
