//
//  AddClassifyView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/20.
//

import UIKit
import RxSwift

class AddClassifyView: UIView, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    var isEdite: Bool = false {
        didSet {
            if isEdite {
                self.titlab.text = "Edit Category".local
            } else {
                self.titlab.text = "Add Category".local
            }
        }
    }
    
    var type: PageType = .dish
    
    var classifyID: String = ""

    private let bag = DisposeBag()
    
    private var H: CGFloat = bottomBarH + 425
    
    var saveSuccessBlock: VoidBlock?
    
    var editeSuccessBlock: VoidStringBlock?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 425), byRoundingCorners: [.topLeft, .topRight], radii: 10)
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
        lab.text = "Add Category".local
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()

    private let lab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Simplified Chinese name".local
        return lab
    }()
    
    private let lab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Traditional Chinese name".local
        return lab
    }()

    private let lab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "English name".local
        return lab
    }()
    
    private let tView1: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = BACKCOLOR_3
        return view
    }()
    
    private let tView2: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = BACKCOLOR_3
        return view
    }()
    
    private let tView3: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = BACKCOLOR_3
        return view
    }()


    private let slab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
        return lab
    }()
    
    
    private let slab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
        return lab
    }()

    private let slab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
        return lab
    }()

    
    private lazy var jtInputTF: UITextField = {
        let tf = UITextField()
        tf.textColor = TXTCOLOR_1
        tf.font = TIT_3
        tf.delegate = self
        return tf
    }()
    
    private lazy var ftInputTF: UITextField = {
        let tf = UITextField()
        tf.textColor = TXTCOLOR_1
        tf.font = TIT_3
        tf.delegate = self
        return tf
    }()

    private lazy var enInputTF: UITextField = {
        let tf = UITextField()
        tf.textColor = TXTCOLOR_1
        tf.font = TIT_3
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
        
        backView.addSubview(lab1)
        lab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(90)
        }
        
        backView.addSubview(slab1)
        slab1.snp.makeConstraints {
            $0.centerY.equalTo(lab1)
            $0.left.equalTo(lab1.snp.right).offset(2)
        }
        
        backView.addSubview(tView1)
        tView1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.top.equalTo(lab1.snp.bottom).offset(7)
        }
        
        tView1.addSubview(jtInputTF)
        jtInputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }
        
        
        

        
        backView.addSubview(lab2)
        lab2.snp.makeConstraints {
            $0.left.equalTo(lab1)
            $0.top.equalTo(lab1.snp.bottom).offset(60)
        }
        
        backView.addSubview(slab2)
        slab2.snp.makeConstraints {
            $0.centerY.equalTo(lab2)
            $0.left.equalTo(lab2.snp.right).offset(2)
        }
        
        
        backView.addSubview(tView2)
        tView2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.top.equalTo(lab2.snp.bottom).offset(7)
        }
        
        tView2.addSubview(ftInputTF)
        ftInputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }
        


        
        backView.addSubview(lab3)
        lab3.snp.makeConstraints {
            $0.left.equalTo(lab1)
            $0.top.equalTo(lab2.snp.bottom).offset(60)
        }
        
        backView.addSubview(slab3)
        slab3.snp.makeConstraints {
            $0.centerY.equalTo(lab3)
            $0.left.equalTo(lab3.snp.right).offset(2)
        }
        
        backView.addSubview(tView3)
        tView3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.top.equalTo(lab3.snp.bottom).offset(7)
        }
        
        tView3.addSubview(enInputTF)
        enInputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
        }
        


        
        self.closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func clickCloseAction() {
        self.disAppearAction()

     }
    
    @objc private func clickSaveAction() {
        
        if self.jtInputTF.text == "" || self.ftInputTF.text == "" || self.enInputTF.text == "" {
            HUD_MB.showWarnig("Please make sure the information is complete!", onView: backView)
            return
        }
        self.saveAction_Net()
        
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
       
       if isEdite {
           self.loadDetail_Net()
       }
       
       addWindow()
   }
   
   func disAppearAction() {
       self.jtInputTF.text = ""
       self.ftInputTF.text = ""
       self.enInputTF.text = ""
       
              
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
            $0.bottom.equalToSuperview().offset(-(height + 210 - bottomBarH - 320))
        }
    }
    
    @objc func keyboardWillHiden(notification: NSNotification) {
        self.backView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
    }

    private func saveAction_Net() {
        HUD_MB.loading("", onView: backView)
        if isEdite {
            if type == .dish {
                HTTPTOOl.editeMenuDishClassify(id: classifyID, name_E: self.enInputTF.text!, name_C: self.jtInputTF.text!, name_H: self.ftInputTF.text!).subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: self.backView)
                    
                    let curL = PJCUtil.getCurrentLanguage()
                    
                    if curL == "en_GB" {
                        self.editeSuccessBlock?(self.enInputTF.text!)
                    } else {
                        self.editeSuccessBlock?(self.ftInputTF.text!)
                    }
                    
                    self.disAppearAction()
                    
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
                }).disposed(by: self.bag)
            }
            if type == .additional {
                HTTPTOOl.editeAttachDishClassify(id: classifyID, name_E: self.enInputTF.text!, name_C: self.jtInputTF.text!, name_H: self.ftInputTF.text!).subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: self.backView)
                    
                    let curL = PJCUtil.getCurrentLanguage()
                    
                    if curL == "en_GB" {
                        self.editeSuccessBlock?(self.enInputTF.text!)
                    } else {
                        self.editeSuccessBlock?(self.ftInputTF.text!)
                    }
                    
                    self.disAppearAction()
                    
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
                }).disposed(by: self.bag)
            }
            if type == .gift {
                HTTPTOOl.editeGiftDishClassify(id: classifyID, name_E: self.enInputTF.text!, name_C: self.jtInputTF.text!, name_H: self.ftInputTF.text!).subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: self.backView)
                    
                    let curL = PJCUtil.getCurrentLanguage()
                    
                    if curL == "en_GB" {
                        self.editeSuccessBlock?(self.enInputTF.text!)
                    } else {
                        self.editeSuccessBlock?(self.ftInputTF.text!)
                    }
                    
                    self.disAppearAction()
                    
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
                }).disposed(by: self.bag)
            }
            
        } else {
            if type == .dish {
                HTTPTOOl.addMenuDishClassify(name_E: self.enInputTF.text!, name_C: self.jtInputTF.text!, name_H: self.ftInputTF.text!).subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: self.backView)
                    self.saveSuccessBlock?("")
                    self.disAppearAction()
                    
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
                }).disposed(by: self.bag)
            }
            
            if type == .additional {
                HTTPTOOl.addMenuAttachClassify(name_E: self.enInputTF.text!, name_C: self.jtInputTF.text!, name_H: self.ftInputTF.text!).subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: self.backView)
                    self.saveSuccessBlock?("")
                    self.disAppearAction()
                    
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
                }).disposed(by: self.bag)
            }

            if type == .gift {
                HTTPTOOl.addMenuGiftClassify(name_E: self.enInputTF.text!, name_C: self.jtInputTF.text!, name_H: self.ftInputTF.text!).subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: self.backView)
                    self.saveSuccessBlock?("")
                    self.disAppearAction()
                    
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
                }).disposed(by: self.bag)
            }
        }

    }
    
    
    
    private func loadDetail_Net() {
        HUD_MB.loading("", onView: self.backView)
        if type == .dish {
            HTTPTOOl.getMenuDishClassifyDetail(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.backView)
                self.jtInputTF.text = json["data"]["nameCn"].stringValue
                self.ftInputTF.text = json["data"]["nameHk"].stringValue
                self.enInputTF.text = json["data"]["nameEn"].stringValue
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
            }).disposed(by: self.bag)
        }
        if type == .additional {
            HTTPTOOl.getAttachDishClassifyDetail(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.backView)
                self.jtInputTF.text = json["data"]["nameCn"].stringValue
                self.ftInputTF.text = json["data"]["nameHk"].stringValue
                self.enInputTF.text = json["data"]["nameEn"].stringValue
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
            }).disposed(by: self.bag)
        }
        if type == .gift {
            HTTPTOOl.getGiftDishClassifyDetail(id: classifyID).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.backView)
                self.jtInputTF.text = json["data"]["nameCn"].stringValue
                self.ftInputTF.text = json["data"]["nameHk"].stringValue
                self.enInputTF.text = json["data"]["nameEn"].stringValue
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
            }).disposed(by: self.bag)
        }

    }

}
