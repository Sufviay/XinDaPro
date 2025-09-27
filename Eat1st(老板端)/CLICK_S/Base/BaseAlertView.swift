//
//  BaseAlertView.swift
//  JinJia
//
//  Created by 岁变 on 7/7/20.
//  Copyright © 2020 岁变. All rights reserved.
//

import UIKit


class BaseAlertView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = S_BS
        //设置背景透明 不影响子视图
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.isUserInteractionEnabled = true
        
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func setViews() {}
    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        self.removeFromSuperview()
    }
}
