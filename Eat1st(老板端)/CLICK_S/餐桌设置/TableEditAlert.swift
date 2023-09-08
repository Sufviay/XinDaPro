//
//  TableEditAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/9/1.
//

import UIKit
import RxSwift

class TableEditAlert: UIView, UIGestureRecognizerDelegate {

    var savedBlock: VoidBlock?
    
    private let bag = DisposeBag()

    private var H: CGFloat = bottomBarH + 255
    
    private var deskID: String = ""
    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 255), byRoundingCorners: [.topLeft, .topRight], radii: 20)
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
        lab.text = "Table setting"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("000000"), BFONT(16), .left)
        lab.text = "Table name"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(14), .left)
        lab.text = "*"
        return lab
    }()
    
    private let tfBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 10
        return view
    }()

    
    private let inputTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = SFONT(14)
        tf.placeholder = "name"
        return tf
    }()
    
    
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 15
        return but
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
        
        backView.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(25)
        }
        
        backView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(tLab)
            $0.left.equalTo(tLab.snp.right).offset(1)
        }
        
        backView.addSubview(tfBackView)
        tfBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
            $0.top.equalTo(tLab.snp.bottom).offset(10)
            
        }
        
        tfBackView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }
        
        
        
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)

        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setData(id: String, name: String) {
        inputTF.text = name
        deskID = id
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
            $0.bottom.equalToSuperview().offset(-(height - bottomBarH - 50))
        }
    }
    
    @objc func keyboardWillHiden(notification: NSNotification) {
        self.backView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
    }
    
    
    
    
    @objc func clickCloseAction() {
        self.disAppearAction()
     }
    
    
    @objc func clickConfirmAction() {

        if inputTF.text ?? "" != "" {
            if deskID == "" {
                addAction_Net()
            } else {
                updateAction_Net()
            }
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


    
    private func addAction_Net() {
        HUD_MB.loading("", onView: self)
        HTTPTOOl.addDesk(name: inputTF.text ?? "", remark: "").subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self)
            savedBlock?("")
            disAppearAction()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self)
        }).disposed(by: bag)
        
    }
    
    private func updateAction_Net() {
        HUD_MB.loading("", onView: self)
        HTTPTOOl.editDesk(id: deskID, name: inputTF.text ?? "" , remark: "").subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self)
            savedBlock?("")
            disAppearAction()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self)
        }).disposed(by: bag)
    }

    
    
    
}
