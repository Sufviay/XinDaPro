//
//  SystemMsgView.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/25.
//

import UIKit

class SystemMsgView: UIView {

    
    var isHave: Bool = false {
        didSet {
            self.pointView.isHidden = !isHave
        }
    }

    private let msgImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tongzhi")
        return img
    }()
    
    private let pointView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FF3C00")
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(msgImg)
        msgImg.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 17, height: 20))
        }
        
        msgImg.addSubview(pointView)
        pointView.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.size.equalTo(CGSize(width: 6, height: 6))
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc private func tapAction() {
        if PJCUtil.checkLoginStatus() {
            //消息列表
            let nextVC = MessageListController()
            PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
