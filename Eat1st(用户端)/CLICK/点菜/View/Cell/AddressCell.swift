//
//  AddressCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/27.
//

import UIKit

class AddressCell: BaseTableViewCell {
    
    var clickEditeBlock: VoidBlock?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let t_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Mr. Zhang,134****8138 MK45"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let c_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = ""
        return lab
    }()
    
    let editeBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        //but.setImage(LOIMG("edite"), for: .normal)
        return but
    }()
    
    let editeImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("edite")
        return img
    }()
    
    let editeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(13), .center)
        lab.text = "Edit"
        return lab
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(editeBut)
        editeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-2)
        }
        
        editeBut.addSubview(editeImg)
        editeImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.centerY.equalToSuperview().offset(-10)
        }
        
        editeBut.addSubview(editeLab)
        editeLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(editeImg.snp.bottom).offset(3)
        }
        
        backView.addSubview(t_lab)
        t_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-50)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(c_lab)
        c_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-60)
            $0.top.equalTo(t_lab.snp.bottom).offset(10)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        editeBut.addTarget(self, action: #selector(clickEditeAciton), for: .touchUpInside)
        
    }
    
    @objc private func clickEditeAciton() {
        clickEditeBlock?("")
    }
    
    
    func setCellData(model: AddressModel) {
        self.t_lab.text = "\(model.receiver), \(model.phone), \(model.postcode)"
        self.c_lab.text = "\(model.address)\n\(model.detail)"
        if model.overRange {
            t_lab.textColor = HCOLOR("#BBBBBB")
            c_lab.textColor = HCOLOR("#BBBBBB")
            
        } else {
            t_lab.textColor = FONTCOLOR
            c_lab.textColor = HCOLOR("666666")
        }
    }

}


class DefaultAddressCell: BaseTableViewCell {
    
    var clickEditeBlock: VoidBlock?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let t_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Mr. Zhang,134****8138 MK45"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let c_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(13), .left)
        lab.numberOfLines = 0
        lab.text = ""
        return lab
    }()
    
    let editeBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        //but.setImage(LOIMG("edite"), for: .normal)
        return but
    }()
    
    let editeImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("edite")
        return img
    }()
    
    let editeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(13), .center)
        lab.text = "Edit"
        return lab
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let defaultLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#FA7268"), SFONT(10), .center)
        lab.text = "Default"
        lab.layer.cornerRadius = 3
        lab.layer.borderColor = HCOLOR("#FA7268").cgColor
        lab.layer.borderWidth = 1
        return lab
    }()
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(editeBut)
        editeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-2)
        }
        
        editeBut.addSubview(editeImg)
        editeImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 20))
            $0.centerY.equalToSuperview().offset(-10)
        }
        
        editeBut.addSubview(editeLab)
        editeLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(editeImg.snp.bottom).offset(3)
        }
        
        backView.addSubview(t_lab)
        t_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(75)
            $0.right.equalToSuperview().offset(-50)
            $0.top.equalToSuperview().offset(15)
        }
        
        backView.addSubview(defaultLab)
        defaultLab.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 42, height: 15))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(t_lab)
        }
        
        backView.addSubview(c_lab)
        c_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-60)
            $0.top.equalTo(t_lab.snp.bottom).offset(10)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        editeBut.addTarget(self, action: #selector(clickEditeAciton), for: .touchUpInside)
        
    }
    
    @objc private func clickEditeAciton() {
        clickEditeBlock?("")
    }
    
    
    func setCellData(model: AddressModel) {
        self.t_lab.text = "\(model.receiver), \(model.phone), \(model.postcode)"
        self.c_lab.text = "\(model.address)\n\(model.detail)"
        if model.overRange {
            t_lab.textColor = HCOLOR("#BBBBBB")
            c_lab.textColor = HCOLOR("#BBBBBB")
            
        } else {
            t_lab.textColor = FONTCOLOR
            c_lab.textColor = HCOLOR("666666")
        }
    }

}



//
//class AddressLabelCell: BaseTableViewCell {
//    
//    let titlab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(MAINCOLOR, SFONT(17), .left)
//        lab.text = "Your last searched address"
//        return lab
//    }()
//    
//    
//    
//    override func setViews() {
//        
//        contentView.backgroundColor = .white
//        
//        contentView.addSubview(titlab)
//        titlab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.centerY.equalToSuperview()
//        }
//        
//    }
//    
//    
//}
