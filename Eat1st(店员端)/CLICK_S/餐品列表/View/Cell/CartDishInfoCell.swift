//
//  CartDishInfoCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/19.
//

import UIKit

class CartDishInfoCell: BaseTableViewCell, UITextFieldDelegate {

    
    var clickDeleteBlock: VoidBlock?
    
    var editPriceBlock: VoidStringBlock?
    
    private let deleteBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Delete", HCOLOR("#000000"), BFONT(9), HCOLOR("#FEC501"))
        but.layer.cornerRadius = 5
        return but
    }()
    
    
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#DF1936"), BFONT(12), .right)
        lab.text = "£"
        return lab
    }()
    
    
    private lazy var moneyInput: UITextField = {
        let tf = UITextField()
        tf.font = BFONT(15)
        tf.textColor = HCOLOR("DF1936")
        tf.textAlignment = .center
        tf.delegate = self
        return tf
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()
    
    
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), SFONT(10), .right)
        lab.text = "x1"
        return lab
    }()
    

    private let dishIDLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(8), .center)
        lab.backgroundColor = HCOLOR("#EE7763")
        lab.clipsToBounds = true
        lab.text = "AW2354"
        lab.layer.cornerRadius = 3
        return lab
    }()
    
    
    private let giveOneImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("giveone")
        return img
    }()
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(11), .left)
        lab.numberOfLines = 0
        lab.text = "Spring Rolls - Chicken Spring Rolls"
        return lab
    }()
    
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(11), .left)
        lab.numberOfLines = 0
        lab.text = "雞肉春卷"
        return lab
    }()
    
    
    
    
    override func setViews() {
        
        contentView.addSubview(deleteBut)
        deleteBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 20))
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(35)
        }
        
        contentView.addSubview(moneyInput)
        moneyInput.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-90)
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(50)
        }
        
        moneyInput.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalTo(moneyInput)
            $0.right.equalTo(moneyInput.snp.left).offset(-3)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.right.equalTo(moneyLab)
            $0.top.equalTo(moneyInput.snp.bottom).offset(5)
        }
        
        contentView.addSubview(dishIDLab)
        dishIDLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(13)
            $0.size.equalTo(CGSize(width: 50, height: 15))
        }
        
        contentView.addSubview(giveOneImg)
        giveOneImg.snp.makeConstraints {
            $0.left.equalTo(dishIDLab.snp.right).offset(5)
            $0.centerY.equalTo(dishIDLab)
            $0.size.equalTo(CGSize(width: 87, height: 15))
        }

        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-150)
            $0.top.equalToSuperview().offset(30)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.right.equalTo(nameLab1)
            $0.top.equalTo(nameLab1.snp.bottom).offset(0)
        }
        
        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
    }
    
    
    @objc private func clickDeleteAction() {
        clickDeleteBlock?("")
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editPriceBlock?(textField.text ?? "")
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
    // 只允许输入数字和两位小数
        let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        
    // let expression = "^[0-9]*([0-9])?$" 只允许输入纯数字
    // let expression = "^[A-Za-z0-9]+$" //允许输入数字和字母
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress,    range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0 {
             print("请输入数字")
             return false
        }
        
        
      return true
        
    }
    

    
    
    func setCellData(model: CartDishModel) {
        dishIDLab.text = model.dishesCode
        nameLab1.text = model.nameEn
        nameLab2.text = model.nameHk
        
        moneyInput.text = D_2_STR(model.price)
        countLab.text = "x\(model.buyNum)"
        
        giveOneImg.isHidden = !model.isGiveOne
    }
    

}
