//
//  DistanceEditeView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/11.
//

import UIKit
import RxSwift



class DistanceEditeView: UIView, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //var curFeeList: [DeliveryFeeModel] = []
    
    private let bag = DisposeBag()

    private var H: CGFloat = bottomBarH + 330
    
    var isEdite: Bool = false
    
    private var feeID: String = ""
    
    var feeType: String = "" {
        didSet {
            if feeType == "1" {
                self.mlab.text = "MILES"
                self.tlab1.text = "Distribution distance".local
                self.tlab2.isHidden = false
            }
            if feeType == "2" {
                self.mlab.text = ""
                self.tlab1.text = "Delivery area Postcode".local
                self.tlab2.isHidden = true
            }
        }
    }
    
    var clickSaveBlock: VoidBlock?



    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 330), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_3, HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, TIT_3, .left)
        lab.text = "Distribution distance"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), TXT_2, .left)
        lab.text = "Less than or equal to".local
        return lab
    }()
    
    private let tlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, TIT_3, .left)
        lab.text = "Delivery charge".local
        return lab
    }()
    
    private let xlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(17), .left)
        lab.text = "*"
        return lab
    }()
    
    private let xlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(17), .left)
        lab.text = "*"
        return lab
    }()

    private let tView1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 7
        return view
    }()
    
    
    private let tView2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let mlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), TIT_3, .right)
        lab.text = "MILES"
        return lab
    }()
    
    private let plab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), TIT_3, .right)
        lab.text = "POUND"
        return lab
    }()


    private lazy var mInPutTF: UITextField = {
        let tf = UITextField()
        tf.font = TIT_3
        tf.textColor = HCOLOR("333333")
        tf.delegate = self
        tf.tag = 100
        return tf
    }()
    
    
    private lazy var pInPutTF: UITextField = {
        let tf = UITextField()
        tf.font = TIT_3
        tf.textColor = HCOLOR("333333")
        tf.delegate = self
        tf.tag = 200
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
        
        
        backView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(40)
        }
        
        backView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab1.snp.bottom).offset(1)
            
        }
        
        backView.addSubview(tlab3)
        tlab3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(145)
        }
        
        backView.addSubview(xlab1)
        xlab1.snp.makeConstraints {
            $0.centerY.equalTo(tlab1).offset(3)
            $0.left.equalTo(tlab1.snp.right)
        }
        
        backView.addSubview(xlab2)
        xlab2.snp.makeConstraints {
            $0.centerY.equalTo(tlab3).offset(3)
            $0.left.equalTo(tlab3.snp.right)
        }
        
        backView.addSubview(tView1)
        tView1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.top.equalTo(tlab2.snp.bottom).offset(5)
        }
        
        backView.addSubview(tView2)
        tView2.snp.makeConstraints {
            $0.left.right.height.equalTo(tView1)
            $0.top.equalTo(tlab3.snp.bottom).offset(5)
        }
        
        tView1.addSubview(mlab)
        mlab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        tView2.addSubview(plab)
        plab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        tView1.addSubview(mInPutTF)
        mInPutTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-100)
        }
        
        tView2.addSubview(pInPutTF)
        pInPutTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-100)
        }
        
        self.closeBut.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc func clickAction() {
        self.disAppearAction()
        //self.clickBlock?("")
     }
    
    @objc private func clickSaveAction() {
        
    
        if self.mInPutTF.text != "" && self.pInPutTF.text != "" {
            
            //邮编
            let postCode = feeType == "1" ? "" : mInPutTF.text!
            //范围
            let radius = feeType == "1" ? mInPutTF.text! : ""
            
            HUD_MB.loading("", onView: backView)
            if isEdite {
                //编辑
                HTTPTOOl.editeDelivaryFee(amount: pInPutTF.text!, distance: radius, postcode: postCode, id: feeID).subscribe(onNext: { json in
                    //编辑成功
                    HUD_MB.dissmiss(onView: self.backView)
                    self.clickSaveBlock?("")
                    self.disAppearAction()
                }, onError: { error in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
                }).disposed(by: self.bag)
                
                
            } else {
                //保存
                HTTPTOOl.addDelivaryFee(amount: pInPutTF.text!, distance: radius, postcode: postCode, type: feeType).subscribe(onNext: { json in
                    //保存成功
                    //设置配送方式
                    HTTPTOOl.setDeliveryType(type: self.feeType).subscribe(onNext: { _ in
                        HUD_MB.dissmiss(onView: self.backView)
                        self.clickSaveBlock?("")
                        self.disAppearAction()
                    }, onError: {error in
                        HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
                    }).disposed(by: self.bag)
                    
                }, onError: {error in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
                }).disposed(by: self.bag)
                
            }

//            var tArr = curFeeList
//
//            let model = DeliveryFeeModel()
//            model.distance = Float(mInPutTF.text!) ?? 0
//            model.amount = Float(pInPutTF.text!) ?? 0
//
//
//            if isEdite {
//                //如果是编辑就先移除要编辑的Model
//                tArr.remove(at: editeIdx)
//            }
//
//            //判断设置的距离是否可用。（不存在即可用）
//            var disIsSort: Bool = true
//            for tmodel in tArr {
//                if model.distance == tmodel.distance {
//                    disIsSort = false
//                    break
//                }
//            }
//
//            if disIsSort {
//                //可用后判断费用是否可用（需递增的顺序）
//                tArr.append(model)
//                tArr.sort { $0.distance < $1.distance }
//
//                var isFeeSort: Bool = true
//                for (idx, model) in tArr.enumerated() {
//                    if idx != tArr.count - 1 {
//                        if model.amount >= tArr[idx + 1].amount {
//                            isFeeSort = false
//                            break
//                        }
//                    }
//                }
//
//                if isFeeSort {
//
//                    var parDicArr: [[String: Any]] = []
//
//                    for model in tArr {
//                        let dic = ["amount": model.amount, "distance": model.distance]
//                        parDicArr.append(dic)
//                    }
//
//                    self.clickSaveBlock?(parDicArr)
//                    self.disAppearAction()
//
//                } else {
//                    //填写的费用不可用
//                    HUD_MB.showWarnig("The delivery fee must be incremental", onView: PJCUtil.getWindowView())
//                }

//
//            } else {
//                //填写的距离不可用
//                HUD_MB.showWarnig("The delivery distance must be increasing", onView: PJCUtil.getWindowView())
//            }

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
        
        self.mInPutTF.text = ""
        self.pInPutTF.text = ""
        
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
    
    func setEditeValueWith(milesOrPostcode: String, pound: String, id: String) {
        self.mInPutTF.text = milesOrPostcode
        self.pInPutTF.text = pound
        self.feeID = id
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 100 && feeType == "2" {
            return true
        }
        
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
            $0.bottom.equalToSuperview().offset(-(height + 210 - bottomBarH - 330))
        }
    }
    
    @objc func keyboardWillHiden(notification: NSNotification) {
        self.backView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
    }
}
