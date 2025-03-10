//
//  CustomRefresh.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/2/14.
//

import UIKit
import MJRefresh

class CustomRefreshHeader: MJRefreshGifHeader {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.lastUpdatedTimeLabel?.isHidden = true
        self.stateLabel?.isHidden = true
        self.gifView?.contentMode = .scaleAspectFit
        self.gifView?.image = PJCUtil.getGifImg(name: "29")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


class CustomRefreshFooter: MJRefreshBackNormalFooter {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.stateLabel?.isHidden = true
        self.arrowView?.image = nil
        self.loadingView?.color = MAINCOLOR
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
