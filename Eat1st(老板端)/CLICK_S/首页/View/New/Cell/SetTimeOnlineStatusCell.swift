//
//  SetTimeOnlineStatusCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/8.
//

import UIKit

class SetTimeOnlineStatusCell: BaseTableViewCell {
    
    
    var clickDSWBlock: VoidBlock?
    
    var clickCSWBlock: VoidBlock?

    
    private var dataModel = StoreOpeningModel()
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("sy_status")
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(18), .left)
        lab.text = "Online Status"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(13), .left)
        lab.text = "You're currently"
        return lab
    }()

    
    private let statusImg: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 50, height: 20))
        img.clipsToBounds = true
        img.layer.cornerRadius = 3
        return img
    }()
    
    
    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .center)
        lab.text = "Open"
        return lab
    }()
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FFFFFF").withAlphaComponent(0.2)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let deSliderBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("slider_off"), for: .normal)
        return but
    }()
    
    private let coSliderBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("slider_off"), for: .normal)
        return but
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(13), .left)
        lab.text = "Delivery"
        return lab
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(13), .left)
        lab.text = "Collection"
        return lab
    }()

    
    


    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(0)
            $0.top.equalToSuperview().offset(20)
        }
        
        backImg.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        backImg.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-26)
        }
        
        
        backImg.addSubview(statusImg)
        statusImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 20))
            $0.left.equalTo(tlab2.snp.right).offset(10)
            $0.centerY.equalTo(tlab2)
            
        }
        
        statusImg.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        backImg.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 125, height: 70))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        backView.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.top.equalToSuperview().offset(42)
        }
        
        backView.addSubview(deSliderBut)
        deSliderBut.snp.makeConstraints {
            $0.centerY.equalTo(deLab)
            $0.size.equalTo(CGSize(width: 40, height: 20))
            $0.left.equalToSuperview().offset(13)
        }
        
        backView.addSubview(coSliderBut)
        coSliderBut.snp.makeConstraints {
            $0.centerY.equalTo(coLab)
            $0.size.equalTo(CGSize(width: 40, height: 20))
            $0.left.equalToSuperview().offset(13)
        }
        
        deSliderBut.addTarget(self, action: #selector(clickDeSwAction), for: .touchUpInside)
        coSliderBut.addTarget(self, action: #selector(clickCoSwAction), for: .touchUpInside)

        
    }
    
    
    @objc func clickDeSwAction() {
        
        if self.dataModel.z_de_status {
            clickDSWBlock?("2")
        } else {
            clickDSWBlock?("1")
        }
    
    }
    
    @objc func clickCoSwAction() {
        
        if self.dataModel.z_co_status {
            clickCSWBlock?("2")
        } else {
            clickCSWBlock?("1")
        }
    }
    
    func setCellData(model: StoreOpeningModel, onLineStatus: Bool) {
        self.dataModel = model

        if onLineStatus {
            self.statusLab.text = "Open"
        } else {
            self.statusLab.text = "Close"
        }
        
        if model.z_co_status {
            self.coSliderBut.setImage(LOIMG("slider_on"), for: .normal)
        } else {
            self.coSliderBut.setImage(LOIMG("slider_off"), for: .normal)
        }
        
        if model.z_de_status {
            self.deSliderBut.setImage(LOIMG("slider_on"), for: .normal)
        } else {
            self.deSliderBut.setImage(LOIMG("slider_off"), for: .normal)
        }
    }

}
