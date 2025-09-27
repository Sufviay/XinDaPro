//
//  SetMinOrderPriceAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/1.
//

import UIKit
import RxSwift


class SetMinOrderPriceAlert: UIView, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    
    private let bag = DisposeBag()
    
    var clickSaveBlock: VoidBlock?

    private var H: CGFloat = bottomBarH + 280
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 280), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()

    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 14
        return but
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_4, .left)
        lab.text = "Min delivery price".local
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
        lab.setCommentStyle(TXTCOLOR_1, TXT_1, .left)
        lab.text = "Price".local
        return lab
    }()

    private let slab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
        return lab
    }()
    
    private let inputBackView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKCOLOR_3
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let mlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.text = "£"
        return lab
    }()

    private lazy var pInPutTF: UITextField = {
        let tf = UITextField()
        tf.font = TIT_3
        tf.textColor = TXTCOLOR_1
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
            $0.top.equalTo(line.snp.bottom).offset(40)
        }
        
        backView.addSubview(slab)
        slab.snp.makeConstraints {
            $0.centerY.equalTo(tlab)
            $0.left.equalTo(tlab.snp.right)
        }
        
        backView.addSubview(inputBackView)
        inputBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
            $0.top.equalTo(tlab.snp.bottom).offset(5)
        }
        
        inputBackView.addSubview(mlab)
        mlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        inputBackView.addSubview(pInPutTF)
        pInPutTF.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(50)
            $0.right.equalTo(-30)
        }
        
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    func setAlertData(price: String) {
        pInPutTF.text = price
    }
    
    @objc private func clickCloseAction() {
        disAppearAction()
    }
    
    
    @objc private func clickSaveAction() {
        
        if pInPutTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please enter the price.".local, onView: PJCUtil.getWindowView())
        } else {
            setPrice_Net()
        }
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
            $0.bottom.equalToSuperview().offset(-(height + 210 - bottomBarH - 280))
        }
    }
    
    @objc func keyboardWillHiden(notification: NSNotification) {
        self.backView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
    }

    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    // 只允许输入数字和两位小数
        let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
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


    
    private func setPrice_Net() {
        HUD_MB.loading("", onView: PJCUtil.getWindowView())
        HTTPTOOl.setStoreMinOrderPrice(price: pInPutTF.text!).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
            clickSaveBlock?("")
            disAppearAction()
        }, onError: { (error) in
            HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
        }).disposed(by: bag)
    }
    
    
}
