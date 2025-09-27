//
//  CropImageController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/7/5.
//

import UIKit

class CropImageController: BaseViewController {
    
    
    var cropDoneBlock: VoidImgBlock?
    
    var cropImg: UIImage!
    {
        didSet {
            self.tkImageView.toCropImage = cropImg
        }
    }
    
    var cropRatio: CGFloat = 0
    {
        didSet {
            self.tkImageView.cropAspectRatio = cropRatio
        }
    }
    
    private lazy var tkImageView: TKImageView = {
        let view = TKImageView()
        view.showMidLines = false
        view.needScaleCrop = false
        view.showCrossLines = false
        view.cornerBorderInImage = false
        view.cropAreaCornerWidth = 44
        view.cropAreaCornerHeight = 44
        view.minSpace = 30
        view.cropAreaCornerLineColor = .white
        view.cropAreaBorderLineColor = .white
        view.cropAreaCornerLineWidth = 4
        view.cropAreaBorderLineWidth = 2
        view.initialScaleFactor = 0.8
        return view
        
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel".local, .white, TIT_2, .clear)
        return but
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm".local, .white, TIT_2, .clear)
        return but
    }()

    
    
    override func setViews() {
        self.naviBar.isHidden = true
        
        view.backgroundColor = .black
                
        view.addSubview(tkImageView)
        tkImageView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 20)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 50)
        }
        
        view.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.size.equalTo(CGSize(width: 80, height: 40))
        }
        
        view.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.size.centerY.equalTo(cancelBut)
            $0.right.equalToSuperview().offset(-20)
        }
        
        cancelBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func confirmAction() {
        
        self.cropDoneBlock?(self.tkImageView.currentCroppedImage())
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    deinit {
        print("aaaaaaaaaaaaaaaaaaaaaaaa")
    }

}
