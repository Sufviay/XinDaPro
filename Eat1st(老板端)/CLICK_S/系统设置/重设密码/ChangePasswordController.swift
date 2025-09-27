//
//  ChangePasswordController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/15.
//

import UIKit
import RxSwift


class ChangePasswordController: HeadBaseViewController {
    
    
    private let bag = DisposeBag()
    
    private var isHide1: Bool = true
    private var isHide2: Bool = true
    private var isHide3: Bool = true


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    private let backView1: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = BACKCOLOR_3
        return view
    }()
    
    private let backView2: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = BACKCOLOR_3
        return view
    }()

    private let backView3: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = BACKCOLOR_3
        return view
    }()
    
    
    private let titlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Old Password".local
        return lab
    }()
    
    private let titlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "New Password".local
        return lab
    }()

    private let titlab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Re-enter Password".local
        return lab
    }()


    
    
    private let sLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(15), .left)
        lab.text = "*"
        return lab
    }()
    
    private let sLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(15), .left)
        lab.text = "*"
        return lab
    }()

    private let sLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(15), .left)
        lab.text = "*"
        return lab
    }()

    
    private let hideBut1: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("hide_b"), for: .normal)
        return but
    }()
    
    private let hideBut2: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("hide_b"), for: .normal)
        return but
    }()

    
    private let hideBut3: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("hide_b"), for: .normal)
        return but
    }()

    
    private let oldTF: UITextField = {
        let tf = UITextField()
        tf.font = TXT_1
        tf.isSecureTextEntry = true
        tf.textColor = TXTCOLOR_1
        tf.setPlaceholder("Please enter the old password".local, color: TFHOLDCOLOR)
        return tf
    }()
    
    
    private let newTF: UITextField = {
        let tf = UITextField()
        tf.font = TXT_1
        tf.isSecureTextEntry = true
        tf.textColor = TXTCOLOR_1
        tf.setPlaceholder("Please enter a new password".local, color: TFHOLDCOLOR)
        return tf
    }()

    private let reTF: UITextField = {
        let tf = UITextField()
        tf.font = TXT_1
        tf.isSecureTextEntry = true
        tf.textColor = TXTCOLOR_1
        tf.setPlaceholder("Please enter a new password again".local, color: TFHOLDCOLOR)
        return tf
    }()
    
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 15
        return but
    }()

    
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Change password".local
    }

    
    override func setViews() {
        setUpUI()
    }

    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        
        backView.addSubview(titlab1)
        titlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
        backView.addSubview(titlab2)
        titlab2.snp.makeConstraints {
            $0.left.equalTo(titlab1)
            $0.top.equalTo(titlab1.snp.bottom).offset(70)
        }

        backView.addSubview(titlab3)
        titlab3.snp.makeConstraints {
            $0.left.equalTo(titlab1)
            $0.top.equalTo(titlab2.snp.bottom).offset(70)
        }

        
        backView.addSubview(backView1)
        backView1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(45)
            $0.top.equalTo(titlab1.snp.bottom).offset(7)
        }
        
        backView.addSubview(backView2)
        backView2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(45)
            $0.top.equalTo(titlab2.snp.bottom).offset(7)
        }
        
        backView.addSubview(backView3)
        backView3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(45)
            $0.top.equalTo(titlab3.snp.bottom).offset(7)
        }

        
        backView.addSubview(sLab1)
        sLab1.snp.makeConstraints {
            $0.centerY.equalTo(titlab1)
            $0.left.equalTo(titlab1.snp.right)
        }

        backView.addSubview(sLab2)
        sLab2.snp.makeConstraints {
            $0.centerY.equalTo(titlab2)
            $0.left.equalTo(titlab2.snp.right)
        }

        backView.addSubview(sLab3)
        sLab3.snp.makeConstraints {
            $0.centerY.equalTo(titlab3)
            $0.left.equalTo(titlab3.snp.right)
        }

        
        backView1.addSubview(hideBut1)
        hideBut1.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(60)
        }
        
        
        backView2.addSubview(hideBut2)
        hideBut2.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(60)
        }
        
        backView3.addSubview(hideBut3)
        hideBut3.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(60)
        }

        
        backView1.addSubview(oldTF)
        oldTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(hideBut1.snp.left).offset(-10)
            $0.top.bottom.equalToSuperview()
        }

        backView2.addSubview(newTF)
        newTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(hideBut2.snp.left).offset(-10)
            $0.top.bottom.equalToSuperview()
        }

        
        backView3.addSubview(reTF)
        reTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(hideBut3.snp.left).offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 35)
        }

        
        
        
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        hideBut1.addTarget(self, action: #selector(clickHideAction1), for: .touchUpInside)
        hideBut2.addTarget(self, action: #selector(clickHideAction2), for: .touchUpInside)
        hideBut3.addTarget(self, action: #selector(clickHideAction3), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func clickHideAction1() {
        isHide1 = !isHide1
        oldTF.isSecureTextEntry = isHide1
        
        if isHide1 {
            hideBut1.setImage(LOIMG("hide_b"), for: .normal)
        } else {
            hideBut1.setImage(LOIMG("show_b"), for: .normal)
        }
        
    }

    @objc private func clickHideAction2() {
        isHide2 = !isHide2
        newTF.isSecureTextEntry = isHide2
        
        if isHide2 {
            hideBut2.setImage(LOIMG("hide_b"), for: .normal)
        } else {
            hideBut2.setImage(LOIMG("show_b"), for: .normal)
        }


    }

    @objc private func clickHideAction3() {
        isHide3 = !isHide3
        reTF.isSecureTextEntry = isHide3
        
        if isHide3 {
            hideBut3.setImage(LOIMG("hide_b"), for: .normal)
        } else {
            hideBut3.setImage(LOIMG("show_b"), for: .normal)
        }

    }
    
    @objc private func clickSaveAction() {
        
        if oldTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please enter the old password".local, onView: view)
            return
        }
        
        if newTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please enter a new password".local, onView: view)
            return
        }
        
        if reTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please enter a new password again".local, onView: view)
            return
        }
        
        if newTF.text ?? "" != reTF.text ?? "" {
            HUD_MB.showWarnig("The two entered passwords are not the same".local, onView: view)
            return
        }
        changPW_Net()
        
    }
    
    
    private func changPW_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.changePassword(new: newTF.text!, old: oldTF.text!, reNew: reTF.text!).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            navigationController?.pushViewController(PssswordSuccesController(), animated: true)
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }



}
