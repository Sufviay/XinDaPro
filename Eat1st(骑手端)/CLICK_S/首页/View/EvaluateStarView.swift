//
//  EvaluateStarView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/4.
//

import UIKit

class EvaluateStarView: UIView {

    private let selStar: UIImage = LOIMG("star_sel")
    private let norStar: UIImage = LOIMG("star_nor")
    
    var clickBlock: VoidBlock?
    
    
    //设置评分
    var setPointValue: Int = 0 {
        didSet {
            changeStarSelect(count: setPointValue)
        }
    }
    
    var isCanTap: Bool = false {
        didSet {
            let img1 = self.viewWithTag(0 + 100) as! UIImageView
            let img2 = self.viewWithTag(1 + 100) as! UIImageView
            let img3 = self.viewWithTag(2 + 100) as! UIImageView
            let img4 = self.viewWithTag(3 + 100) as! UIImageView
            let img5 = self.viewWithTag(4 + 100) as! UIImageView
            
            img1.isUserInteractionEnabled = isCanTap

            img2.isUserInteractionEnabled = isCanTap

            img3.isUserInteractionEnabled = isCanTap

            img4.isUserInteractionEnabled = isCanTap
            img5.isUserInteractionEnabled = isCanTap
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        let w = frame.height
        for idx in 0..<5 {
            let img = UIImageView()
            img.image = LOIMG("star_nor")
            img.frame = CGRect(x: CGFloat(idx) * w + (w / 3) * CGFloat(idx) , y: 0, width: w, height: w)
            img.tag = idx + 100
            img.isUserInteractionEnabled = true
            self.addSubview(img)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)))
            img.addGestureRecognizer(tap)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
        
    private func changeStarSelect(count: Int) {
        
        let img1 = self.viewWithTag(0 + 100) as! UIImageView
        let img2 = self.viewWithTag(1 + 100) as! UIImageView
        let img3 = self.viewWithTag(2 + 100) as! UIImageView
        let img4 = self.viewWithTag(3 + 100) as! UIImageView
        let img5 = self.viewWithTag(4 + 100) as! UIImageView
        
        if count == 0 {
            img1.image = norStar
            img2.image = norStar
            img3.image = norStar
            img4.image = norStar
            img5.image = norStar
        }
        if count == 1 {
            img1.image = selStar
            img2.image = norStar
            img3.image = norStar
            img4.image = norStar
            img5.image = norStar
            
        }
        if count == 2 {
            img1.image = selStar
            img2.image = selStar
            img3.image = norStar
            img4.image = norStar
            img5.image = norStar

        }
        if count == 3 {
            img1.image = selStar
            img2.image = selStar
            img3.image = selStar
            img4.image = norStar
            img5.image = norStar

        }
        if count == 4 {
            img1.image = selStar
            img2.image = selStar
            img3.image = selStar
            img4.image = selStar
            img5.image = norStar

        }
        
        if count == 5 {
            img1.image = selStar
            img2.image = selStar
            img3.image = selStar
            img4.image = selStar
            img5.image = selStar

        }

    }
    
    
    @objc func tapHandler(sender:UITapGestureRecognizer) {
        //获取手势的上的控件tag值
        let count = (sender.view?.tag)! - 100 + 1
        clickBlock?(count)
        changeStarSelect(count: count)
    }
    

    
}
