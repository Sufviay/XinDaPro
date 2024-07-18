//
//  ScanViewController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/7.
//

import UIKit

class ScanViewController: LBXScanViewController {

    var scanFinshBlock: VoidBlock?
    
    var clickWaiMaiBlock: VoidBlock?
    
//    var isClickStore: Bool = false {
//        didSet {
//            coBut.isHidden = !isClickStore
//            deBut.isHidden = !isClickStore
//        }
//        
//    }
    
    /**
     @brief  闪关灯开启状态
     */
    private var isOpenedFlash: Bool = false
        
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back_w"), for: .normal)
        return but
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        return view
    }()
    
    
    ///相册
    private var btnPhoto: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("CodeScan.bundle/scan_album"), for: .normal)
        return but
    }()

    

    ///闪光灯
    private var btnFlash: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("CodeScan.bundle/scan_deng_nor"), for: .normal)
        return but
    }()

    
    //外卖按钮
    private let deBut: UIButton = {
        let but = UIButton()
        but.clipsToBounds = true
        but.backgroundColor = .white
        but.layer.cornerRadius = 10
        but.isHidden = true
        return but
    }()
    
    private let deImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_wm")
        return img
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .center)
        lab.text = "Delivery"
        return lab
    }()
    
    
    //自取按钮
    private let coBut: UIButton = {
        let but = UIButton()
        but.clipsToBounds = true
        but.backgroundColor = .white
        but.layer.cornerRadius = 10
        but.isHidden = true
        return but
    }()
    
    
    private let coImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_zq")
        return img
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .center)
        lab.text = "Collection"
        return lab
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)

        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH)
            $0.size.equalTo(CGSize(width: 50, height: 44))
        }

        backBut.addTarget(self, action: #selector(backAciton), for: .touchUpInside)
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        bottomView.addSubview(btnPhoto)
        btnPhoto.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 65, height: 87))
            $0.right.equalTo(bottomView.snp.centerX).offset(-40)
            $0.centerY.equalToSuperview()
        }
        
        btnPhoto.addTarget(self, action: #selector(openPhotoAlbum), for: .touchUpInside)

        
        bottomView.addSubview(btnFlash)
        btnFlash.snp.makeConstraints {
            $0.size.equalTo(btnPhoto)
            $0.left.equalTo(bottomView.snp.centerX).offset(40)
            $0.centerY.equalToSuperview()
        }
        
        view.addSubview(deBut)
        deBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 100))
            $0.bottom.equalTo(bottomView.snp.top).offset(-15)
            $0.right.equalTo(view.snp.centerX).offset(-20)
        }
        
        view.addSubview(coBut)
        coBut.snp.makeConstraints {
            $0.size.centerY.equalTo(deBut)
            $0.left.equalTo(view.snp.centerX).offset(20)
        }
        
        deBut.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        deBut.addSubview(deImg)
        deImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 31, height: 36))
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(deLab.snp.top).offset(-12)
        }
        
        
        coBut.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        coBut.addSubview(coImg)
        coImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 26))
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(deLab.snp.top).offset(-14)
        }

                
        btnFlash.addTarget(self, action: #selector(openOrCloseFlash), for: .touchUpInside)
        deBut.addTarget(self, action: #selector(clickDeAction), for: .touchUpInside)
        coBut.addTarget(self, action: #selector(clickDeAction), for: .touchUpInside)
    }
    
    @objc private func backAciton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func clickDeAction() {
        clickWaiMaiBlock?("")
        self.dismiss(animated: true, completion: nil)
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash() {
        scanObj?.changeTorch()

        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/scan_deng_sel"), for:UIControl.State.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/scan_deng_nor"), for:UIControl.State.normal)

        }
    }

    
    
    
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {

        for result: LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print(str)
            }
        }

        let result: LBXScanResult = arrayResult[0]
        self.scanFinshBlock?(result.strScanned ?? "")
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
