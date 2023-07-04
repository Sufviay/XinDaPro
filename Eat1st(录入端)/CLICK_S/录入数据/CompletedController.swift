//
//  CompletedController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/23.
//

import UIKit

class CompletedController: HeadBaseViewController {


    
    private lazy var headView: CompleteHeaderView = {
        let view = CompleteHeaderView()
        view.dataModel = dataModel
        return view
    }()

    
    private let exitBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Exit", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 25
        return but
    }()
    
    private let comImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("complete")
        return img
    }()
    
    private let comLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(17), .center)
        lab.text = "Have Completed"
        return lab
    }()
    


    
    override func setViews() {
        setUpUI()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    private func setUpUI() {
        
        leftBut.isHidden = true
        lastBut.isHidden = true
        nextBut.isHidden = true
        
        view.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(55)
            $0.top.equalTo(headImg.snp.bottom).offset(-30)
        }
        
        view.addSubview(exitBut)
        exitBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 60)
            $0.height.equalTo(50)
        }
        
        
        view.addSubview(comImg)
        comImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headView.snp.bottom).offset(R_H(105))
            $0.size.equalTo(CGSize(width: 155, height: 150))
        }
        
        view.addSubview(comLab)
        comLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(comImg.snp.bottom).offset(10)
        }
        
        self.exitBut.addTarget(self, action: #selector(clickExitAction), for: .touchUpInside)
        
        
        
    }
    
    
    @objc private func clickExitAction() {
        FeeTypeResultModel.sharedInstance.cleanPlatData()
        self.navigationController?.setViewControllers([LogInController()], animated: true)
    }
    
    
    deinit {
        print("\(self.classForCoder) 销毁")
    }


}
