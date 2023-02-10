//
//  SystemMoreView.swift
//  CLICK
//
//  Created by 肖扬 on 2022/12/10.
//

import UIKit

class SystemMoreView: UIView {

    var clickBlock: VoidBlock?
    
    var isHave: Bool = false {
        didSet {
            self.pointView.isHidden = !isHave
        }
    }

    private let moreImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("nav_cbl")
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
        
        self.addSubview(moreImg)
        moreImg.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 15))
        }
        
        self.addSubview(pointView)
        pointView.snp.makeConstraints {
            $0.left.equalTo(moreImg.snp.right).offset(-2)
            $0.top.equalTo(moreImg.snp.top).offset(-4)
            $0.size.equalTo(CGSize(width: 6, height: 6))
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc private func tapAction() {
        
        clickBlock?("")
        
//        if PJCUtil.checkLoginStatus() {
//            //消息列表
//            let nextVC = MessageListController()
//            PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
//        }
    }

}
