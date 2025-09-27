//
//  ComplaintsRefundAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/8/28.
//

import UIKit

class ComplaintsRefundAlert: UIView, UIGestureRecognizerDelegate, UITextFieldDelegate {

    private var H: CGFloat = bottomBarH + 470
    
    
    var clickConfirmBlock: VoidBlock?
    
    
    private var allAmonut: String = "" {
        didSet {
            allMoneyLab.text = "£\(allAmonut)"
        }
    }
    
    private var partAmount: String = "" {
        didSet {
            partMoneyLab.text = "£\(partAmount)"
        }
    }
    
    
    ///1余额 2卡 3现金
    private var refundFlow: String = "" {
        didSet {
            updateStyle()
        }
    }
    
    
    ///2全部退款，3申请的菜品退款，4自定义金额
    private var refundMode: String = "" {
        didSet {
            updateStyle()
        }
    }
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 470), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Refund"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 15
        return but
    }()

    
    private let titLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(17), .left)
        lab.text = "Refund way"
        return lab
    }()
    
    private let sLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(14), .left)
        lab.text = "*"
        return lab
    }()
    
    
    private let titLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(17), .left)
        lab.text = "Refund amount"
        return lab
    }()
    
    private let sLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(14), .left)
        lab.text = "*"
        return lab
    }()
    
    private let cardBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.tag = 1
        return but
    }()
    
    private let sImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    private let tLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Card"
        return lab
    }()
    
    
    private let walletBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.tag = 2
        return but
    }()
    
    private let sImg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    private let tLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Wallet"
        return lab
    }()



    
    private let cashBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.tag = 3
        return but
    }()

    private let sImg3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    private let tLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Cash"
        return lab
    }()


    private let allBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.tag = 4
        return but
    }()
    
    private let partBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.tag = 5
        return but
    }()

    
    private let otherBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.tag = 6
        return but
    }()
    
    
    private let sImg4: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    private let sImg5: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()

    private let sImg6: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    
    private let tLab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "All"
        return lab
    }()

    
    private let tLab5: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Part"
        return lab
    }()

    
    private let tLab6: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .left)
        lab.text = "Other"
        return lab
    }()


    private let allMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .left)
        lab.text = "£51.99"
        return lab
    }()
    
    
    private let partMoneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .left)
        lab.text = "£50.99"
        return lab
    }()

    
    private let inputBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 7
        view.isHidden = true
        return view
    }()
    
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.textColor = TXTCOLOR_1
        tf.font = SFONT(13)
        tf.placeholder = "input refund amount"
        tf.delegate = self
        return tf
    }()
    
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(H)
            $0.height.equalTo(H)
        }
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titlab.snp.bottom).offset(7)
        }
        
        backView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        backView.addSubview(titLab1)
        titLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(line.snp.bottom).offset(30)
        }
        
        backView.addSubview(sLab1)
        sLab1.snp.makeConstraints {
            $0.centerY.equalTo(titLab1)
            $0.left.equalTo(titLab1.snp.right).offset(1)
        }
        
        backView.addSubview(titLab2)
        titLab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(line.snp.bottom).offset(115)
        }
        
        backView.addSubview(sLab2)
        sLab2.snp.makeConstraints {
            $0.centerY.equalTo(titLab2)
            $0.left.equalTo(titLab2.snp.right).offset(1)
        }
        
        backView.addSubview(cardBut)
        cardBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(45)
            $0.width.equalTo(S_W / 3)
            $0.top.equalTo(titLab1.snp.bottom).offset(5)
        }
        
        backView.addSubview(walletBut)
        walletBut.snp.makeConstraints {
            $0.left.equalTo(cardBut.snp.right).offset(0)
            $0.height.width.centerY.equalTo(cardBut)
        }
        
        backView.addSubview(cashBut)
        cashBut.snp.makeConstraints {
            $0.left.equalTo(walletBut.snp.right).offset(0)
            $0.height.width.centerY.equalTo(cardBut)
        }
        
        cardBut.addSubview(sImg1)
        sImg1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
        
        
        cardBut.addSubview(tLab1)
        tLab1.snp.makeConstraints {
            $0.left.equalTo(sImg1.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        
        
        walletBut.addSubview(sImg2)
        sImg2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
        
        
        walletBut.addSubview(tLab2)
        tLab2.snp.makeConstraints {
            $0.left.equalTo(sImg2.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }

        
        cashBut.addSubview(sImg3)
        sImg3.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
        
        
        cashBut.addSubview(tLab3)
        tLab3.snp.makeConstraints {
            $0.left.equalTo(sImg3.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        
        backView.addSubview(allBut)
        allBut.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(titLab2.snp.bottom).offset(10)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(partBut)
        partBut.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(allBut.snp.bottom).offset(0)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(otherBut)
        otherBut.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(partBut.snp.bottom).offset(0)
            $0.height.equalTo(40)
        }

        
        allBut.addSubview(sImg4)
        sImg4.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
        }

        
        partBut.addSubview(sImg5)
        sImg5.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
        }

        otherBut.addSubview(sImg6)
        sImg6.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
        }
        
        
        allBut.addSubview(tLab4)
        tLab4.snp.makeConstraints {
            $0.left.equalTo(sImg4.snp.right).offset(15)
            $0.centerY.equalToSuperview()
        }
        
        
        partBut.addSubview(tLab5)
        tLab5.snp.makeConstraints {
            $0.left.equalTo(sImg5.snp.right).offset(15)
            $0.centerY.equalToSuperview()
        }

        
        otherBut.addSubview(tLab6)
        tLab6.snp.makeConstraints {
            $0.left.equalTo(sImg6.snp.right).offset(15)
            $0.centerY.equalToSuperview()
        }
        
        allBut.addSubview(allMoneyLab)
        allMoneyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(130)
            $0.centerY.equalToSuperview()
        }

        partBut.addSubview(partMoneyLab)
        partMoneyLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(130)
            $0.centerY.equalToSuperview()
        }

        
        backView.addSubview(inputBackView)
        inputBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.top.equalTo(otherBut.snp.bottom).offset(5)
        }
        
        
        inputBackView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        
        


        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        cardBut.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
        walletBut.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
        cashBut.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
        allBut.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
        partBut.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
        otherBut.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickButtonAction(sender: UIButton) {
        let tag = sender.tag
        ///1余额 2卡 3现金
        if tag == 1 {
            //卡支付
            if refundFlow != "2" {
                refundFlow = "2"
            } else {
                refundFlow = ""
            }
        }
        if tag == 2 {
            //钱包
            if refundFlow != "1" {
                refundFlow = "1"
            } else {
                refundFlow = ""
            }
            
        }
        if tag == 3 {
            //现金
            if refundFlow != "3" {
                refundFlow = "3"
            } else {
                refundFlow = ""
            }
        }
        
        
        ///2全部退款，3申请的菜品退款，4自定义金额
        
        if tag == 4 {
            //全部
            if refundMode != "2" {
                refundMode = "2"
            } else {
                refundMode = ""
            }
        }
        
        if tag == 5 {
            //部分
            if refundMode != "3" {
                refundMode = "3"
            } else {
                refundMode = ""
            }
        }
        
        if tag == 6 {
            //自定义
            if refundMode != "4" {
                refundMode = "4"
            } else {
                refundMode = ""
            }
        }

    
        
        
        
    }
    
    
    
    private func updateStyle() {
        
        if refundFlow == "" {
            
            sImg1.image = LOIMG("busy_unsel_b")
            sImg2.image = LOIMG("busy_unsel_b")
            sImg3.image = LOIMG("busy_unsel_b")
        }
        
        if refundFlow == "1" {
            ///余额
            sImg1.image = LOIMG("busy_unsel_b")
            sImg2.image = LOIMG("busy_sel_b")
            sImg3.image = LOIMG("busy_unsel_b")
        }
        
        if refundFlow == "2" {
            ///卡
            sImg1.image = LOIMG("busy_sel_b")
            sImg2.image = LOIMG("busy_unsel_b")
            sImg3.image = LOIMG("busy_unsel_b")
        }
        
        if refundFlow == "3" {
            ///现金
            sImg1.image = LOIMG("busy_unsel_b")
            sImg2.image = LOIMG("busy_unsel_b")
            sImg3.image = LOIMG("busy_sel_b")
        }
        
        
        
        
        if refundMode == "" {
            
            sImg4.image = LOIMG("busy_unsel_b")
            sImg5.image = LOIMG("busy_unsel_b")
            sImg6.image = LOIMG("busy_unsel_b")
            
            inputTF.text = ""
            inputBackView.isHidden = true
        }
       
        if refundMode == "2" {
            ///全部
            sImg4.image = LOIMG("busy_sel_b")
            sImg5.image = LOIMG("busy_unsel_b")
            sImg6.image = LOIMG("busy_unsel_b")
            

            inputBackView.isHidden = true
        }
        
        if refundMode == "3" {
            ///部分
            sImg4.image = LOIMG("busy_unsel_b")
            sImg5.image = LOIMG("busy_sel_b")
            sImg6.image = LOIMG("busy_unsel_b")
            
            inputBackView.isHidden = true
        }
        
        
        if refundMode == "4" {
            ///部分
            sImg4.image = LOIMG("busy_unsel_b")
            sImg5.image = LOIMG("busy_unsel_b")
            sImg6.image = LOIMG("busy_sel_b")
            
            inputBackView.isHidden = false
        }
        
        
        
    }
    
    
    
    
    @objc func clickCloseAction() {
        self.disAppearAction()
     }
    
    
    @objc func clickConfirmAction() {
    
        if refundFlow == "" {
            return
        }
        if refundMode == "" {
            return
        }
        if refundMode == "4" && inputTF.text ?? "" == "" {
            return
        }
        
        
        var amount = ""
        
        if refundMode == "2" {
            amount = allAmonut
        }
        if refundMode == "3" {
            amount = partAmount
        }
        if refundMode == "4" {
            amount = inputTF.text ?? ""
        }
        
        let info = ["mode": refundMode, "flow": refundFlow, "amount": amount]
        
        clickConfirmBlock?(info)
        
        disAppearAction()
        
    }

    
    func setRefundData(mode: String, flow: String, allMoney: String, partMoney: String) {
        refundFlow = flow
        refundMode = mode
        allAmonut = allMoney
        partAmount = partMoney
    }
    
    
    
    @objc private func tapAction() {
        disAppearAction()
    }

    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(0)
                $0.height.equalTo(self.H)
            }
            ///要加这个layout
            self.layoutIfNeeded()
        }
    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
                      
        UIApplication.shared.keyWindow?.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(self.H)
                $0.height.equalTo(self.H)
            }
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        //var expression = ""
    // 只允许输入数字和两位小数
        let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        
        //"^(-)?[0-9]*(\\.[0-9]{0,4})?$"
        //只允许输入正负数且最对两位小数
        
//        if titStr == "Staff No.(full)" || titStr == "staff No.(part)" {
//            expression = "^[0-9]*([0-9])?$"
//        } else {
//            expression = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
//        }
        
        
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
    

}
