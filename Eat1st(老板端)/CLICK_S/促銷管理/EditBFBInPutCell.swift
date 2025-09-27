//
//  EditBFBInPutCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/18.
//

import UIKit

class EditBFBInPutCell: BaseTableViewCell, UITextFieldDelegate {


    var editeEndBlock: VoidStringBlock?

    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
        return lab
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let bfbIconLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .right)
        lab.text = "%"
        return lab
    }()


    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = TXT_1
        tf.textColor = TXTCOLOR_1
        tf.delegate = self
        return tf
    }()
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            //$0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(17)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(45)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(bfbIconLab)
        bfbIconLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-40)
            $0.top.bottom.equalToSuperview()
        }
        
    }
    
    
    func setCellData(titStr: String, msgStr: String, isMust: Bool = true) {
                
        sLab.isHidden = !isMust
        
        self.titlab.text = titStr
        self.inputTF.text = msgStr
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    // 只允许输入数字和两位小数
    //    let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        //只允许输入正负数且最对两位小数
        let expression = "^(-)?[0-9]*(\\.[0-9]{0,2})?$"
        
    // let expression = "^[0-9]*([0-9])?$" 只允许输入纯数字
    // let expression = "^[A-Za-z0-9]+$" //允许输入数字和字母
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress,    range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0{
             print("请输入数字")
             return false
        }
      return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.editeEndBlock?(self.inputTF.text ?? "")
    }
    
    
}
