//
//  BookingDeatilAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/22.
//

import UIKit
import RxSwift

class BookingDeatilAlert: UIView, UIGestureRecognizerDelegate, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    private var dataModel = BookingContentModel()
    
    private var H: CGFloat = bottomBarH + 350
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 350), byRoundingCorners: [.topLeft, .topRight], radii: 10)
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
        lab.text = "Detail"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .left)
        lab.text = "Ms zhang"
        return lab
    }()

    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
        lab.text = "Date:"
        return lab
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
        lab.text = "Party:"
        return lab
    }()
    
//    private let tlab3: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
//        lab.text = "Table:"
//        return lab
//    }()
    
    
    private let tlab4: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
        lab.text = "Contact way:"
        return lab
    }()
    
//    private let tlab5: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
//        lab.text = "Email:"
//        return lab
//    }()
    
    
    private let tlab6: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
        lab.text = "Create time:"
        return lab
    }()
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .right)
        lab.text = "2022-06-08 08:00PM"
        return lab
    }()
    
    
    private let partyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .right)
        lab.text = "10"
        return lab
    }()
    
    
//    private let tableLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .right)
//        lab.text = "04"
//        return lab
//    }()

    
    private let phoneLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .right)
        lab.text = "01933 403500"
        return lab
    }()


    
//    private let emailLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .right)
//        lab.text = "136000000000@163.com"
//        return lab
//    }()
//
    
    private let createTimeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(14), .right)
        lab.text = "2022-06-08"
        return lab
    }()

    
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", HCOLOR("#465DFD"), BFONT(14), .white)
        but.layer.cornerRadius = 14
        but.layer.borderWidth = 2
        but.layer.borderColor = HCOLOR("#465DFD").cgColor
        return but
    }()
    
    
    private let checkInBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Check in", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
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
        
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(80)
        }
        
        backView.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(120)
        }
        
        backView.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(155)
        }
        
//        backView.addSubview(tlab3)
//        tlab3.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.top.equalToSuperview().offset(190)
//        }

        
        backView.addSubview(tlab4)
        tlab4.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(190)
            //$0.top.equalToSuperview().offset(225)
        }


//        backView.addSubview(tlab5)
//        tlab5.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.top.equalToSuperview().offset(260)
//        }
//
        
        backView.addSubview(tlab6)
        tlab6.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(225)
            //$0.top.equalToSuperview().offset(290)
        }
        

        backView.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab1)
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        backView.addSubview(partyLab)
        partyLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab2)
            $0.right.equalToSuperview().offset(-20)
        }

//        backView.addSubview(tableLab)
//        tableLab.snp.makeConstraints {
//            $0.centerY.equalTo(tlab3)
//            $0.right.equalToSuperview().offset(-20)
//        }

        
        backView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab4)
            $0.right.equalToSuperview().offset(-20)
        }
        
//        backView.addSubview(emailLab)
//        emailLab.snp.makeConstraints {
//            $0.centerY.equalTo(tlab5)
//            $0.right.equalToSuperview().offset(-20)
//        }
        
        backView.addSubview(createTimeLab)
        createTimeLab.snp.makeConstraints {
            $0.centerY.equalTo(tlab6)
            $0.right.equalToSuperview().offset(-20)
        }

        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
            $0.right.equalTo(backView.snp.centerX).offset(-15)
        }
        
        backView.addSubview(checkInBut)
        checkInBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
            $0.bottom.equalTo(cancelBut)
            $0.left.equalTo(backView.snp.centerX).offset(15)
        }
        

        self.closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        checkInBut.addTarget(self, action: #selector(clickCheckInAction), for: .touchUpInside)
    }
    
    func setData(model: BookingContentModel) {
        
        dataModel = model
        nameLab.text = model.name
        dateLab.text = "\(model.reserveDate) \(model.reserveTime)"
        partyLab.text = model.reserveNum
        phoneLab.text = model.phone
        createTimeLab.text = model.createTime
        
        
        if model.reserveStatus == "5" {
            cancelBut.isHidden = true
            checkInBut.isHidden = true
        } else {
            cancelBut.isHidden = false
            checkInBut.isHidden = false

        }
        
    }
    
    @objc func clickCloseAction() {
        self.disAppearAction()
     }
    
    
    @objc private func tapAction() {
        disAppearAction()
    }
    
    @objc private func clickCheckInAction() {
        doCheckIn_Net(id: dataModel.userReserveId)
    }

    

    @objc private func clickCancelAction() {
        //取消
        showSystemChooseAlert("Alert", "Cancel or not?", "YES", "NO") { [unowned self] in
            doCancel_Net(id: dataModel.userReserveId)
        }

    }

    
    
    //取消预约
    private func doCancel_Net(id: String) {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.doCancelBooking(id: id).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            NotificationCenter.default.post(name: NSNotification.Name("bookList"), object: nil)
            disAppearAction()
        },  onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: self.bag)
    }
    
    
    
    //checkin
    private func doCheckIn_Net(id: String) {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.doCheckinBooking(id: id).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            NotificationCenter.default.post(name: NSNotification.Name("bookList"), object: nil)
            disAppearAction()
        },  onError: {[unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: self.bag)
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
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    

    
    
}
