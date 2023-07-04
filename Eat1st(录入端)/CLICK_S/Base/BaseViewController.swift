//
//  BaseViewController.swift
//  JinJia
//
//  Created by 岁变 on 7/7/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit


class CustomButton: UIButton {
    
    var butImgStr: String = "" {
        didSet {
            self.midImg.image = LOIMG(butImgStr)
        }
    }
    
    private let midImg: UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = false
        return img
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        self.addSubview(midImg)
        midImg.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class CustomNaviBar: UIView {

    private let backImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        return img
    }()
    
    let leftBut: UIButton = {
        let but = UIButton()
        return but
    }()
    
    let rightBut: UIButton = {
        let but = UIButton()
        return but
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.textColor = FONTCOLOR
        lab.font = BFONT(17)
        lab.textAlignment = .center
        lab.text = ""
        return lab
    }()
    
    
    var headerBackColor = UIColor.white {
        didSet {
            self.backgroundColor = headerBackColor
        }
    }
    
    var headerTitleColor = FONTCOLOR {
        didSet {
            self.titLab.textColor = headerTitleColor
        }
    }
    
    var headerTitle = "标题" {
        didSet {
            self.titLab.text = headerTitle
        }
    }
    
    var leftImg: UIImage? {
        didSet {
            self.leftBut.setImage(leftImg, for: .normal)
        }
    }
    
    var rightImg: UIImage? {
        didSet {
            self.rightBut.setImage(rightImg, for: .normal)
        }
    }
    
    
    var leftClickBlock: VoidBlock?
    var rightClickBlock: VoidBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = headerBackColor
        self.leftBut.setImage(leftImg, for: .normal)
        
        self.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-13)
        }
        
        self.addSubview(leftBut)
        leftBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(titLab)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.addSubview(rightBut)
        rightBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.centerY.equalTo(leftBut)
            $0.right.equalToSuperview().offset(-10)
        }
        
        leftBut.addTarget(self, action: #selector(clickLeftAction), for: .touchUpInside)
        rightBut.addTarget(self, action: #selector(clickRightAction), for: .touchUpInside)
    }
    
    @objc private func clickLeftAction() {
        leftClickBlock!("")
    }
    
    @objc private func clickRightAction() {
        rightClickBlock!("")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class BaseViewController: UIViewController {

    lazy var naviBar: CustomNaviBar = {
        let bar = CustomNaviBar()
        bar.leftClickBlock = { [unowned self] (_) in
            self.clickLeftButAction()
        }
        
        bar.rightClickBlock = { [unowned self] (_) in
            self.clickRightButAction()
        }
        
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        view.backgroundColor = BACKCOLOR
        view.addSubview(naviBar)
        naviBar.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(statusBarH + 44)
        }
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        setNavi()
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewDisappear()
        
    }
    
    open func setViews() {}
    
    open func setData() {}
    
    open func setNavi() {}
    
    open func viewDisappear() {}
    
    open func clickLeftButAction() {}
    
    open func clickRightButAction() {}
    
    
//    deinit {
//        print("销毁页面")
//    }

}
