//
//  CountSelectView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/4.
//

import UIKit

class CountSelectView: UIView, CAAnimationDelegate {
    
    var countBlock: VoidBlock?
    
    ///是否可以为0
    var canBeZero: Bool = true
    
    //最大的数字
    var maxCount: Int = 0
    
    var count: Int = 0 {
        didSet {
            self.countLab.text = String(count)
            if count == 0 {
                self.jianBut.isHidden = true
                self.countLab.isHidden = true
            } else {
                self.jianBut.isHidden = false
                self.countLab.isHidden = false
            }
        }
    }

    
    var canClick: Bool = true {
        didSet {
            self.jiaBut.isEnabled = canClick
            self.jianBut.isEnabled = canClick
        }
    }
    
    private let jiaBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_+"), for: .normal)
        return but
    }()
    
    
    private let jianBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_-"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .center)
        lab.isHidden = true
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(30)
        }
        
        self.addSubview(jiaBut)
        jiaBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.equalTo(countLab.snp.right)
            $0.centerY.equalTo(countLab)
        }
        
        self.addSubview(jianBut)
        jianBut.snp.makeConstraints {
            $0.size.equalTo(jiaBut)
            $0.right.equalTo(countLab.snp.left)
            $0.centerY.equalTo(jiaBut)
        }
        
        jiaBut.addTarget(self, action: #selector(clickJiaAction), for: .touchUpInside)
        jianBut.addTarget(self, action: #selector(clickJianAction), for: .touchUpInside)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickJiaAction() {
        
        if PJCUtil.checkLoginStatus() {
            let rec = self.convert(jiaBut.frame, to: PJCUtil.getWindowView())
        
            if maxCount == 0 {
                self.count += 1
                self.countBlock?(count)
                addAnimation(rect: rec)
            } else {
                if self.count < maxCount {
                    self.count += 1
                    self.countBlock?(count)
                    addAnimation(rect: rec)
                }
            }

        }
    
    }
    
    @objc private func clickJianAction() {
        if PJCUtil.checkLoginStatus() {
            if canBeZero {
                self.count -= 1
                self.countBlock?(count)
            } else {
                if self.count != 1 {
                    self.count -= 1
                    self.countBlock?(count)
                }
            }
        }
    }
    
    
    lazy var viewArray: [UIView] = {
        let viewArray: [UIView] = []
        return viewArray
    }()
    

    
    func addAnimation(rect: CGRect) {
        
        autoreleasepool{
            let squr = UIView()
            squr.backgroundColor = UIColor.red
            squr.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            squr.layer.cornerRadius = 25/2
            squr.layer.masksToBounds = true
            PJCUtil.getWindowView().addSubview(squr)
            //self.view.insertSubview(squr, aboveSubview: self.tableview)
            self.viewArray.append(squr)
            
        }
        let lastSquar = self.viewArray.last
        let path =  CGMutablePath()
        let beginPoint = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 2)
        
        path.move(to: beginPoint)
                
        path.addQuadCurve(to:CGPoint(x: 70, y: S_H - bottomBarH - 60),  control: CGPoint(x: 150, y: rect.origin.y))
        
        //获取贝塞尔曲线的路径
        let animationPath = CAKeyframeAnimation.init(keyPath: "position")
        animationPath.path = path
        animationPath.rotationMode = CAAnimationRotationMode.rotateAuto
        
        //缩小图片到0
        let scale:CABasicAnimation = CABasicAnimation()
        scale.keyPath = "transform.scale"
        scale.toValue = 0.3
        
        //组合动画
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [animationPath,scale];
        animationGroup.duration = 0.2;
        animationGroup.fillMode = CAMediaTimingFillMode.forwards;
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        lastSquar!.layer.add(animationGroup, forKey:
            nil)
    }

    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let redview = self.viewArray.first
        redview?.isHidden = true
        self.viewArray.remove(at: 0)
        
    }

    
    
}





///请求成功后 在加数量
class CountSelect_NoC_View: UIView, CAAnimationDelegate {
    
    var countBlock: VoidBlock?
    
    
    var count: Int = 0 {
        didSet {
            self.countLab.text = String(count)
            if count == 0 {
                self.jianBut.isHidden = true
                self.countLab.isHidden = true
            } else {
                self.jianBut.isHidden = false
                self.countLab.isHidden = false
            }
        }
    }

    

    
    private let jiaBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_+"), for: .normal)
        return but
    }()
    
    
    private let jianBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("menu_-"), for: .normal)
        but.isHidden = true
        return but
    }()
    
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .center)
        lab.isHidden = true
        return lab
    }()
    
    var canClick: Bool = true {
        didSet {
            self.jiaBut.isEnabled = canClick
            self.jianBut.isEnabled = canClick
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(30)
        }
        
        self.addSubview(jiaBut)
        jiaBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.left.equalTo(countLab.snp.right)
            $0.centerY.equalTo(countLab)
        }
        
        self.addSubview(jianBut)
        jianBut.snp.makeConstraints {
            $0.size.equalTo(jiaBut)
            $0.right.equalTo(countLab.snp.left)
            $0.centerY.equalTo(jiaBut)
        }
        
        jiaBut.addTarget(self, action: #selector(clickJiaAction), for: .touchUpInside)
        jianBut.addTarget(self, action: #selector(clickJianAction), for: .touchUpInside)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickJiaAction() {
        
        if PJCUtil.checkLoginStatus() {
            let dic: [String: Any] = ["type": "+", "num": count + 1]
            self.countBlock?(dic)
            
            let rec = self.convert(jiaBut.frame, to: PJCUtil.getWindowView())
            addAnimation(rect: rec)
            
        }
    
    }
    
    @objc private func clickJianAction() {
        if PJCUtil.checkLoginStatus() {
            let dic: [String: Any] = ["type": "-", "num": count - 1]
            self.countBlock?(dic)
        }
    }
    
    lazy var viewArray: [UIView] = {
        let viewArray: [UIView] = []
        return viewArray
    }()
    
    
    func addAnimation(rect: CGRect) {
        
        autoreleasepool{
            let squr = UIView()
            squr.backgroundColor = UIColor.red
            squr.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            squr.layer.cornerRadius = 25/2
            squr.layer.masksToBounds = true
            PJCUtil.getWindowView().addSubview(squr)
            //self.view.insertSubview(squr, aboveSubview: self.tableview)
            self.viewArray.append(squr)
            
        }
        let lastSquar = self.viewArray.last
        let path =  CGMutablePath()
        let beginPoint = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 2)
        
        path.move(to: beginPoint)
                
        path.addQuadCurve(to:CGPoint(x: 70, y: S_H - bottomBarH - 60),  control: CGPoint(x: 150, y: rect.origin.y))
        
        //获取贝塞尔曲线的路径
        let animationPath = CAKeyframeAnimation.init(keyPath: "position")
        animationPath.path = path
        animationPath.rotationMode = CAAnimationRotationMode.rotateAuto
        
        //缩小图片到0
        let scale:CABasicAnimation = CABasicAnimation()
        scale.keyPath = "transform.scale"
        scale.toValue = 0.3
        
        //组合动画
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [animationPath,scale];
        animationGroup.duration = 0.2;
        animationGroup.fillMode = CAMediaTimingFillMode.forwards;
        animationGroup.isRemovedOnCompletion = false
        animationGroup.delegate = self
        lastSquar!.layer.add(animationGroup, forKey:
            nil)
    }

    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let redview = self.viewArray.first
        redview?.isHidden = true
        self.viewArray.remove(at: 0)
        
    }

    
    
    
}

