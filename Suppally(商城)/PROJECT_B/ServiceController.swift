//
//  ServiceController.swift
//  PROJECT_B
//
//  Created by 肖扬 on 2023/1/9.
//

import UIKit
import WebKit

class ServiceController: UIViewController {

    
    var webView : WKWebView?
    var webUrl = ""
    var titStr = ""
    
//
//    let progressView: UIProgressView = {
//        let progress = UIProgressView()
//        progress.progressTintColor = HCOLOR("#68B346")
//        progress.trackTintColor = .clear
//        return progress
//    }()


    
    private let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.font = BFONT(16)
        lab.textColor = FONTCOLOR
        lab.textAlignment = .center
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(topBar)
        topBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(statusBarH + 44)
        }
        
        topBar.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }

        topBar.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.centerY.equalTo(titLab)
        }
        
        configWeb()

        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titLab.text = titStr
//        self.progressView.progress = 0.0
//        self.progressView.isHidden = true
        
    }
    
    
    @objc private func clickBackAction() {
        self.dismiss(animated: true)
    }
    
    
    func configWeb() {
        
    
//        let config = WKWebViewConfiguration()
//
//        let userContent = WKUserContentController()
//
//        config.userContentController = userContent
    
        
        webView = WKWebView.init(frame: .zero)
        print(webUrl)
        //监听网页加载进度
//        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        guard let url = URL(string: webUrl) else {
            return
        }
        
        //let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
        let request = URLRequest(url: url)
        webView?.load(request)
        self.view.addSubview(webView!)
        
        webView?.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }

        
//        self.view.addSubview(progressView)
//        progressView.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.top.equalTo(topBar.snp.bottom)
//            $0.height.equalTo(2)
//        }
        
        
    }

    
//
//    //监控网页加载进程
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

    
//
//    deinit {
//        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
//    }


}
