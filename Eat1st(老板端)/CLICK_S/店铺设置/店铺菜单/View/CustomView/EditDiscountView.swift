//
//  EditDiscountView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/9/8.
//

import UIKit
import RxSwift


class EditDiscountView: UIView, UIGestureRecognizerDelegate, UITextFieldDelegate {

    private let bag = DisposeBag()

    private var dishID: String = ""
    
    private var H: CGFloat = bottomBarH + 320
    
    ///是否有优惠 1无优惠 2有优惠
    private var discountType: String = "1" {
        didSet {
            if discountType == "1" {
                //无优惠
                self.yesImg.image = LOIMG("busy_unsel_b")
                self.noImg.image = LOIMG("busy_sel_b")
                self.tfBackView.isHidden = true
            }
            
            if discountType == "2" {
                //有优惠
                self.yesImg.image = LOIMG("busy_sel_b")
                self.noImg.image = LOIMG("busy_unsel_b")
                self.tfBackView.isHidden = false
            }
            
        }
    }
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 320), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()


    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()

    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()

    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Edit discount"
        return lab
    }()

    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()

    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(16), .left)
        lab.text = "Discount"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(16), .left)
        lab.text = "*"
        return lab
    }()

    
    private let yesBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let noBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let yesImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_sel_b")
        return img
    }()
    
    private let noImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("busy_unsel_b")
        return img
    }()
    
    private let yeslab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Enable"
        return lab
    }()
    
    
    private let nolab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Disable"
        return lab
    }()

    
    private let tfBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 7
        return view
    }()
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Fill in the discount price"
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.delegate = self
        return tf
    }()
    


    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addNotification()
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
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 40)
            $0.height.equalTo(50)
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
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(35)
        }
        
        backView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab)
            $0.left.equalTo(tlab.snp.right).offset(3)
        }
        
        backView.addSubview(yesBut)
        yesBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(S_W / 2)
            $0.height.equalTo(40)
            $0.top.equalTo(tlab.snp.bottom).offset(6)
        }
        
        yesBut.addSubview(yesImg)
        yesImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        yesBut.addSubview(yeslab)
        yeslab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(yesImg.snp.right).offset(10)
        }
        
        backView.addSubview(noBut)
        noBut.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.equalTo(S_W / 2)
            $0.height.equalTo(40)
            $0.top.equalTo(tlab.snp.bottom).offset(6)
        }
        
        noBut.addSubview(noImg)
        noImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 10))
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
        }
        
        noBut.addSubview(nolab)
        nolab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(noImg.snp.right).offset(10)
        }
        
        backView.addSubview(tfBackView)
        tfBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.top.equalTo(yesBut.snp.bottom).offset(6)
        }
        
        tfBackView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }

        
        self.closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
        yesBut.addTarget(self, action: #selector(clickYesAction), for: .touchUpInside)
        noBut.addTarget(self, action: #selector(clickNoAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickYesAction() {
        if discountType != "2" {
            self.discountType = "2"
        }
    }
    
    @objc private func clickNoAction() {
        if discountType != "1" {
            self.discountType = "1"
        }
    }

    
    
    @objc private func clickCloseAction() {
        self.disAppearAction()

     }
    
    @objc private func clickSaveAction() {
        if discountType == "2" {
            if inputTF.text ?? "" == "" {
                HUD_MB.showWarnig("Place fill in the price!", onView: PJCUtil.getWindowView())
                return
            }
        }
        setDiscount_Net()
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
    
    
    func setAlertData(discountType: String, discountPrice: String, dishID: String) {
        self.dishID = dishID
        self.discountType = discountType
        self.inputTF.text = discountPrice
    }
    

     
     
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if (touch.view?.isDescendant(of: self.backView))! {
             return false
         }
         return true
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

    
    
    //添加监听
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHiden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    @objc func keyboardWillShow(notification: NSNotification) {
        //获取键盘高度
        let userInfo: Dictionary = notification.userInfo!
        let value = userInfo["UIKeyboardFrameEndUserInfoKey"]
        let keyboardRec = (value as AnyObject).cgRectValue
        let height = keyboardRec?.size.height ?? 0
        
        self.backView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-(height - 130 - bottomBarH + 30))
        }
    }
    
    @objc func keyboardWillHiden(notification: NSNotification) {
        self.backView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
    }
    
    
    private func setDiscount_Net() {
        HUD_MB.loading("", onView: backView)
        
        let price = discountType == "2" ? inputTF.text ?? "" : ""
        HTTPTOOl.setDishesDiscount(dishId: dishID, discountType: discountType, discountPrice: price).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.backView)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dishList"), object: nil)
            self.disAppearAction()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
        }).disposed(by: self.bag)
    }


    
}
