//
//  HeadBaseViewController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/29.
//

import UIKit

class HeadBaseViewController: UIViewController {
    
    
    
    private let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_head")
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("baseBack")
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let leftBut: UIButton = {
        let but = UIButton()
        return but
    }()
    
    
    let biaoTiLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(20), .center)
        lab.numberOfLines = 0
        return lab
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        view.backgroundColor = BACKCOLOR
        
        view.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        view.addSubview(leftBut)
        leftBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 15)
            $0.size.equalTo(CGSize(width: 50, height: 40))
        }
    
        
        view.addSubview(biaoTiLab)
        biaoTiLab.snp.makeConstraints {
            $0.centerY.equalTo(leftBut)
            $0.left.equalToSuperview().offset(70)
            $0.right.equalToSuperview().offset(-70)
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
//    
//    open func clickLeftButAction() {}
//    
//    open func clickRightButAction() {}


}
