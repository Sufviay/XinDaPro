//
//  DishDetailCountCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/16.
//

import UIKit

class DishDetailCountCell: BaseTableViewCell, UITextFieldDelegate {

    
    var countBlock: VoidIntBlock?
    
    var priceBlock: VoidStringBlock?

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
    
    private lazy var selectView: CountSelectView = {
        let view = CountSelectView()
        view.canBeZero = false
        view.countBlock = { [unowned self] (count) in
            countBlock?(count as! Int)
        }
        return view
    }()

    
    
    
    override func setViews() {
        
        contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(moneyInput)
        moneyInput.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 60, height: 30))
            $0.left.equalTo(moneyLab.snp.right).offset(3)
        }
        
        
        moneyInput.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(moneyLab)
        }

        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        priceBlock?(textField.text ?? "")
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
    

    
    
    func setCellData(money: String, buyNum: Int) {
        moneyInput.text = money
        selectView.count = buyNum
    }

}
