//
//  OrderSelectTagCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/7.
//

import UIKit

class OrderSelectTagCell: BaseTableViewCell {
    
    var clickTypeBlock: VoidBlock?

    private var selectType: String = "1"
    
    
    
    private let de_sel_but: UIButton = {
        let but = UIButton()
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: (S_W - 20) / 2, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        but.setCommentStyle(.zero, "Delivery", FONTCOLOR, BFONT(17), .white)
        return but
    }()
    
    
    private let lineOne: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        return view
    }()

    
    
    private let de_unsel_but: UIButton = {
        let but = UIButton()
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: (S_W - 20) / 2, height: 38), byRoundingCorners: [.topLeft], radii: 10)
        but.setCommentStyle(.zero, "Delivery", HCOLOR("#333333"), BFONT(14), HCOLOR("#FEF6DF"))
        return but
    }()
    
    
    private let co_sel_but: UIButton = {
        let but = UIButton()
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: (S_W - 20) / 2, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        but.setCommentStyle(.zero, "Collection", FONTCOLOR, BFONT(17), .white)
        return but
    }()
    
    

    private let lineTwo: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        return view
    }()

    
    
    private let co_unsel_but: UIButton = {
        let but = UIButton()
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: (S_W - 20) / 2, height: 38), byRoundingCorners: [.topRight], radii: 10)
        but.setCommentStyle(.zero, "Collection", HCOLOR("#333333"), BFONT(14), HCOLOR("#FEF6DF"))
        return but
    }()

    
    

    
    override func setViews() {
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        
        contentView.addSubview(de_sel_but)
        de_sel_but.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo((S_W - 20) / 2)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
        
        de_sel_but.addSubview(lineOne)
        lineOne.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 3))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        contentView.addSubview(co_unsel_but)
        co_unsel_but.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo((S_W - 20) / 2)
            $0.height.equalTo(38)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(de_unsel_but)
        de_unsel_but.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo((S_W - 20) / 2)
            $0.height.equalTo(38)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(co_sel_but)
        co_sel_but.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo((S_W - 20) / 2)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }

        
        
        co_sel_but.addSubview(lineTwo)
        lineTwo.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 3))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
        

 
        de_unsel_but.addTarget(self, action: #selector(clickButOneAction), for: .touchUpInside)
        co_unsel_but.addTarget(self, action: #selector(clickButTwoAction), for: .touchUpInside)
        
    }
    
    @objc private func clickButOneAction() {
        if selectType != "1" {
            self.clickTypeBlock?("1")
        }
    }
    
    @objc private func clickButTwoAction() {
        if selectType != "2" {
            self.clickTypeBlock?("2")
        }
    }
    
    
    func setCellData(type: String, isCanEdite: Bool) {
        
        
        self.selectType = type
        
        if selectType == "1" {
            
            
            self.de_sel_but.isHidden = false
            self.de_unsel_but.isHidden = true
            self.co_sel_but.isHidden = true
            self.co_unsel_but.isHidden = false
            

        }
        if selectType == "2" {
            
            self.de_sel_but.isHidden = true
            self.de_unsel_but.isHidden = false
            self.co_sel_but.isHidden = false
            self.co_unsel_but.isHidden = true

        }
        
        self.de_unsel_but.isEnabled = isCanEdite
        self.co_unsel_but.isEnabled = isCanEdite
    
    }
    
    

}







class OrderTagDeliveryCell: BaseTableViewCell {
    
    
    private let de_sel_but: UIButton = {
        let but = UIButton()
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: (S_W - 20) / 2, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        but.setCommentStyle(.zero, "Delivery", FONTCOLOR, BFONT(17), .white)
        return but
    }()
    
    
    private let lineOne: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        return view
    }()
    
    
    private let co_unsel_but: UIButton = {
        let but = UIButton()
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: (S_W - 20) / 2, height: 38), byRoundingCorners: [.topRight], radii: 10)
        but.setCommentStyle(.zero, "No Collection", HCOLOR("#333333"), BFONT(14), HCOLOR("#FEF6DF"))
        return but
    }()




    
    override func setViews() {
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(de_sel_but)
        de_sel_but.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo((S_W - 20) / 2)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
        
        de_sel_but.addSubview(lineOne)
        lineOne.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 3))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
        
        contentView.addSubview(co_unsel_but)
        co_unsel_but.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo((S_W - 20) / 2)
            $0.height.equalTo(38)
            $0.bottom.equalToSuperview()
        }
        
    }
}


class OrderTagCollectionCell: BaseTableViewCell {
    
    
    
    private let co_sel_but: UIButton = {
        let but = UIButton()
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: (S_W - 20) / 2, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        but.setCommentStyle(.zero, "Collection", FONTCOLOR, BFONT(17), .white)
        return but
    }()
    

    private let lineTwo: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        return view
    }()
    
    private let de_unsel_but: UIButton = {
        let but = UIButton()
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: (S_W - 20) / 2, height: 38), byRoundingCorners: [.topLeft], radii: 10)
        but.setCommentStyle(.zero, "No Delivery", HCOLOR("#333333"), BFONT(14), HCOLOR("#FEF6DF"))
        return but
    }()

    

    
    override func setViews() {
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(de_unsel_but)
        de_unsel_but.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo((S_W - 20) / 2)
            $0.height.equalTo(38)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(co_sel_but)
        co_sel_but.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo((S_W - 20) / 2)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }

        
        
        co_sel_but.addSubview(lineTwo)
        lineTwo.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 3))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
}



class OrderTagDineInCell: BaseTableViewCell {
    
    
    
    private let deBut: UIButton = {
        let but = UIButton()
        but.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 50), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        but.setCommentStyle(.zero, "Dine In", FONTCOLOR, BFONT(17), .white)
        return but
    }()
    

    private let lineTwo: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 1
        return view
    }()
        

    
    override func setViews() {
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(deBut)
        deBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
    
        
        deBut.addSubview(lineTwo)
        lineTwo.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 3))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
}




