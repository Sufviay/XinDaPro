//
//  EditPrintAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/10/18.
//

import UIKit
import RxSwift

class EditPrintAlert: UIView, UIGestureRecognizerDelegate {

    private let bag = DisposeBag()
    
    var savedBlock: VoidBlock?
    
    
    private var printNum: String = "" {
        didSet {
            if printNum == "1" {
                img1.image = LOIMG("spec_sel")
                img2.image = LOIMG("spec_unsel")
            }
            else if printNum == "2" {
                img1.image = LOIMG("spec_unsel")
                img2.image = LOIMG("spec_sel")
            } else {
                img1.image = LOIMG("spec_unsel")
                img2.image = LOIMG("spec_unsel")
            }
        }
    }
    
    private var printerID: String = "" {
        didSet {
            if printerID == "" {
                titlab.text = "Add"
            } else {
                titlab.text = "Edite"
            }
        }
    }
    
    private var H: CGFloat = bottomBarH + 440

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 440), byRoundingCorners: [.topLeft, .topRight], radii: 20)
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
        lab.text = "Printer Edit"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private let namelab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(17), .left)
        lab.text = "Printer name"
        return lab
    }()
    
    private let iplab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(17), .left)
        lab.text = "Printer IP"
        return lab
    }()
    
    private let copieslab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(17), .left)
        lab.text = "Printe copies"
        return lab
    }()
    
    private let sLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(16), .left)
        lab.text = "*"
        return lab
    }()

    
    private let sLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(16), .left)
        lab.text = "*"
        return lab
    }()
    
    private let sLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), SFONT(16), .left)
        lab.text = "*"
        return lab
    }()

    
    
    private let tfBack1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let tfBack2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#8F92A1").withAlphaComponent(0.06)
        view.layer.cornerRadius = 7
        return view
    }()
    
    
    private let nameTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = SFONT(15)
        return tf
    }()
    
    
    private let ipTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = SFONT(15)
        return tf
    }()
    
    
    private let oneBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let twoBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    
    private let img1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel")
        return img
    }()
    
    private let img2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("spec_unsel")
        return img
    }()

    
    private let oneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(14), .left)
        lab.text = "Print one copy"
        return lab
    }()
    
    private let twoLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(14), .left)
        lab.text = "Print two copies"
        return lab
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
        
        backView.addSubview(namelab)
        namelab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(30)
        }
        
        backView.addSubview(sLab1)
        sLab1.snp.makeConstraints {
            $0.centerY.equalTo(namelab)
            $0.left.equalTo(namelab.snp.right)
        }
        
        
        backView.addSubview(iplab)
        iplab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(110)
        }
        
        backView.addSubview(sLab2)
        sLab2.snp.makeConstraints {
            $0.centerY.equalTo(iplab)
            $0.left.equalTo(iplab.snp.right)
        }

        
        backView.addSubview(copieslab)
        copieslab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(190)
        }
        
        backView.addSubview(sLab3)
        sLab3.snp.makeConstraints {
            $0.centerY.equalTo(copieslab)
            $0.left.equalTo(copieslab.snp.right)
        }
        
        
        backView.addSubview(tfBack1)
        tfBack1.snp.makeConstraints {
            $0.height.equalTo(35)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(namelab.snp.bottom).offset(5)
        }
        
        tfBack1.addSubview(nameTF)
        nameTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.bottom.equalToSuperview()
        }
        
        backView.addSubview(tfBack2)
        tfBack2.snp.makeConstraints {
            $0.height.equalTo(35)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(iplab.snp.bottom).offset(5)
        }
        
        tfBack2.addSubview(ipTF)
        ipTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(oneBut)
        oneBut.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(copieslab.snp.bottom).offset(5)
            $0.width.equalTo(S_W / 2)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(twoBut)
        twoBut.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.height.width.top.equalTo(oneBut)
        }
        
        
        oneBut.addSubview(img1)
        img1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        oneBut.addSubview(oneLab)
        oneLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }

        
        twoBut.addSubview(img2)
        img2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        twoBut.addSubview(twoLab)
        twoLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
        }

        
        
        self.closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
        oneBut.addTarget(self, action: #selector(clickOneAction), for: .touchUpInside)
        twoBut.addTarget(self, action: #selector(clickTwoAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickCloseAction() {
        self.disAppearAction()

     }
    
    
    
    @objc private func clickOneAction() {
        if printNum == "1" {
            printNum = ""
        } else {
            printNum = "1"
        }
    }
    
    
    @objc private func clickTwoAction() {
        
        if printNum == "2" {
            printNum = ""
        } else {
            printNum = "2"
        }
    }
    
    @objc private func clickSaveAction() {
        if nameTF.text != "" && ipTF.text != "" && printNum != "" {
            if printerID == "" {
                add_Net()
            } else {
                edite_Net()
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
            $0.bottom.equalToSuperview().offset(-(height - 115 - 70))
        }
    }
    
    @objc func keyboardWillHiden(notification: NSNotification) {
        self.backView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
    }
    
    
    func setData(name: String, ip: String, id: String, copy: String) {
        printerID = id
        nameTF.text = name
        ipTF.text = ip
        printNum = copy
    }

    
    
    //MARK: - 网络请求
    private func add_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.addPrinter(name: nameTF.text!, ip: ipTF.text!, printNum: printNum).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            savedBlock?("")
            disAppearAction()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    
    
    private func edite_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.editPrinter(id: printerID, name: nameTF.text!, ip: ipTF.text!, printNum: printNum).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            savedBlock?("")
            disAppearAction()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    

}
