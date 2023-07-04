//
//  ScanViewController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/7.
//

import UIKit

class ScanViewController: LBXScanViewController {

    var scanFinshBlock: VoidBlock?
    
    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash: Bool = false
        
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
        
        btnFlash.addTarget(self, action: #selector(openOrCloseFlash), for: .touchUpInside)
        
    }
    
    @objc private func backAciton() {
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
