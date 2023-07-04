//
//  HeadBaseViewController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/29.
//

import UIKit

class HeadBaseViewController: UIViewController {
    
    var dataModel = DayDataModel()
    
    var resultModel = FeeTypeResultModel()
    
    let headImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_head")
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
    
    
    let nextBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Next", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 25
        return but
    }()

    let lastBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Last", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 25
        return but
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        view.backgroundColor = .white
        
    
        view.addSubview(headImg)
        headImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(statusBarH + SET_H(100, 375))
        }
        
        
        view.addSubview(leftBut)
        leftBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 2)
            $0.size.equalTo(CGSize(width: 50, height: 40))
        }
    
        
        view.addSubview(biaoTiLab)
        biaoTiLab.snp.makeConstraints {
            $0.centerY.equalTo(leftBut)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(nextBut)
//        nextBut.snp.makeConstraints {
//            $0.right.equalToSuperview().offset(-20)
//            $0.width.equalTo((S_W - 55) / 2)
//            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
//            $0.height.equalTo(50)
//        }

        view.addSubview(lastBut)
        lastBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo((S_W - 55) / 2)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
            $0.height.equalTo(50)
        }
        
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        headImg.addGestureRecognizer(longTap)

        leftBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        lastBut.addTarget(self, action: #selector(clickLeftButAction), for: .touchUpInside)
        nextBut.addTarget(self, action: #selector(clickNextButAction), for: .touchUpInside)
        setViews()
    }
    
    
    
    @objc private func longPressAction() {
        let d_ID = MYVendorToll.getIDFV() ?? ""
        let token = UserDefaults.standard.token ?? ""
        PJCUtil.wishSeed(str: d_ID + "\n" + token)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
    
    @objc private func clickLeftButAction() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func clickNextButAction() {
        nextAction()
    }

    
    open func nextAction() {}

}
