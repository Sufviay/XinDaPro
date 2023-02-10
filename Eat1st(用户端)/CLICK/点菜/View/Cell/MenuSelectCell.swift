//
//  MenuSelectCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/6.
//

import UIKit

class MenuSelectCell: BaseTableViewCell {

    var clickBlock: VoidStringBlock?
    // 1 配送  2 自取
    private var type: String = ""
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F1F1F1")
        view.layer.cornerRadius = 15
        return view
    }()
    

    private let de_But: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delivery", FONTCOLOR, BFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 15
        return but
    }()
    
    private let co_But: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Collection", HCOLOR("#999999"), BFONT(14), .clear)
        but.layer.cornerRadius = 15
        return but
    }()
    
    
    private let closedLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), BFONT(14), .center)
        lab.text = "Closed"
        lab.backgroundColor = HCOLOR("#F1F1F1")
        lab.clipsToBounds = true
        lab.layer.cornerRadius = 15
        lab.isHidden = true
        return lab
    }()
    
//    private let deline: UIView = {
//        let view = UIView()
//        view.backgroundColor = MAINCOLOR
//        return view
//    }()
//
//    private let coline: UIView = {
//        let view = UIView()
//        view.backgroundColor = MAINCOLOR
//        return view
//    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(12), .right)
        lab.text = "Delivers in 20-35 mins"
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    

    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
//        contentView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.right.bottom.equalToSuperview()
//            $0.height.equalTo(0.5)
//        }
        
        

        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.width.equalTo(190)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(30)
        }
        

        backView.addSubview(de_But)
        de_But.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(190 / 2)
        }
        
        backView.addSubview(co_But)
        co_But.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(190 / 2)
            
        }
        
        contentView.addSubview(closedLab)
        closedLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 95, height: 30))
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        
        self.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(de_But)
            $0.right.equalToSuperview().offset(-15)
            $0.left.equalToSuperview().offset(15 + 190)
        }
        
        de_But.addTarget(self, action: #selector(clickDeAction), for: .touchUpInside)
        co_But.addTarget(self, action: #selector(clickCoAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickDeAction() {
        print("aaaa")
        if self.type != "1" {
            clickBlock?("1")
        }
    }
    
    @objc private func clickCoAction() {
        print("bbbb")
        if type != "2" {
            clickBlock?("2")
        }
    }
    
    
    func setData(model: StoreInfoModel, selectWay: String)  {
        
        //1 配送  2 自取
        self.type = selectWay
        
        //可配送 可自取
        if model.deStatus == "1" && model.coStatus == "1" {
            
            backView.isHidden = false
            closedLab.isHidden = true
            
            de_But.setTitle("Delivery", for: .normal)
            co_But.setTitle("Collection", for: .normal)
            de_But.isEnabled = true
            co_But.isEnabled = true
            
            co_But.titleLabel?.font = BFONT(14)
            de_But.titleLabel?.font = BFONT(14)
            
            if type == "1" {
                self.de_But.setTitleColor(FONTCOLOR, for: .normal)
                self.de_But.backgroundColor = MAINCOLOR
                self.co_But.setTitleColor(HCOLOR("999999"), for: .normal)
                self.co_But.backgroundColor = .clear
                self.timeLab.text = "Delivers in \(model.deMin)-\(model.deMax) mins"
            }
            if type == "2" {
                self.de_But.setTitleColor(HCOLOR("999999"), for: .normal)
                self.de_But.backgroundColor = .clear
                self.co_But.setTitleColor(FONTCOLOR, for: .normal)
                self.co_But.backgroundColor = MAINCOLOR
                self.timeLab.text = "Collect in \(model.coMin)-\(model.coMax) mins"
            }
            
            
        }
        //可配送 不可自取
        if model.deStatus == "1" && model.coStatus == "2" {
            
            backView.isHidden = false
            closedLab.isHidden = true
            
            de_But.setTitle("Delivery", for: .normal)
            co_But.setTitle("No collection", for: .normal)
            de_But.setTitleColor(FONTCOLOR, for: .normal)
            co_But.setTitleColor(HCOLOR("#999999"), for: .normal)
            de_But.backgroundColor = MAINCOLOR
            co_But.backgroundColor = .clear
            de_But.isEnabled = false
            co_But.isEnabled = false
            
            co_But.titleLabel?.font = BFONT(12)
            de_But.titleLabel?.font = BFONT(14)


            self.timeLab.text = "Delivers in \(model.deMin)-\(model.deMax) mins"

        }
        //不可配送 可自取
        if model.deStatus == "2" && model.coStatus == "1" {
            backView.isHidden = false
            closedLab.isHidden = true

            de_But.setTitle("No delivery", for: .normal)
            co_But.setTitle("Collection", for: .normal)
            de_But.setTitleColor(HCOLOR("#999999"), for: .normal)
            co_But.setTitleColor(FONTCOLOR, for: .normal)
            de_But.backgroundColor = .clear
            co_But.backgroundColor = MAINCOLOR
            de_But.isEnabled = false
            co_But.isEnabled = false
            
            co_But.titleLabel?.font = BFONT(14)
            de_But.titleLabel?.font = BFONT(12)


            self.timeLab.text = "Collect in \(model.coMin)-\(model.coMax) mins"

        }
        //不可配送 不可自取
        if model.deStatus == "2" && model.coStatus == "2" {
            backView.isHidden = true
            closedLab.isHidden = false

            
            de_But.setTitle("Closed", for: .normal)
            co_But.setTitle("Closed", for: .normal)
            de_But.setTitleColor(FONTCOLOR, for: .normal)
            co_But.setTitleColor(FONTCOLOR, for: .normal)
            de_But.backgroundColor = .clear
            co_But.backgroundColor = .clear
            de_But.isEnabled = false
            co_But.isEnabled = false
            co_But.isHidden = true
            
            co_But.titleLabel?.font = BFONT(14)
            de_But.titleLabel?.font = BFONT(14)


            self.timeLab.text = ""
        }
                
    }
    

    
}
