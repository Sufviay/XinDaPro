//
//  LocationAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2024/7/4.
//

import UIKit

class LocationAlert: UIView {
    
    var clickShouDongBlock: VoidBlock?
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.setCommentStyle(.black, BFONT(16), .center)
        lab.text = "Location service is not enabled"
        return lab
    }()
    
    
    private let messageLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "We need a location to better serve you, so we offer two solutions:\n\n1.Go to [Settings]>>[Privacy]>>[Location Services]>> Turn on the switch and allow Eat1st to use location services.\n\n2.No need to turn on location services, manually enter and select a location information."
        return lab
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    

    
    private let goSetBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Go Setting", .black, BFONT(16), .clear)
        return but
    }()
    
    
    private let manualBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Manual selection", .black, BFONT(16), .clear)
        return but
    }()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置背景透明 不影响子视图
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        setViews()
    }
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setViews() {
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(300)
            $0.centerY.equalToSuperview()
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(messageLab)
        messageLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(titLab.snp.bottom).offset(15)
        }
        
        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(1)
            $0.bottom.equalToSuperview().offset(-10)
        }

        
        backView.addSubview(goSetBut)
        goSetBut.snp.makeConstraints {
            $0.bottom.left.equalToSuperview()
            $0.top.equalTo(line1.snp.bottom)
            $0.right.equalTo(line2.snp.left)
        }
        
        backView.addSubview(manualBut)
        manualBut.snp.makeConstraints {
            $0.bottom.right.equalToSuperview()
            $0.top.equalTo(line1.snp.bottom)
            $0.left.equalTo(line2.snp.right)
        }
        
        goSetBut.addTarget(self, action: #selector(clickSetAction), for: .touchUpInside)
        manualBut.addTarget(self, action: #selector(clickManualAction), for: .touchUpInside)

    }
    
    
    @objc private func clickSetAction() {
        
        
        let settingUrl = URL(string: UIApplication.openSettingsURLString)
        if let url = settingUrl, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        disAppearAction()
    }
    
    
    @objc private func clickManualAction() {
        clickShouDongBlock?("")
        disAppearAction()
    }
    
    
    private func addWindow() {
                
        if self.superview == nil {
            PJCUtil.getWindowView().addSubview(self)
        }
        
        
    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        self.removeFromSuperview()
    }

}
