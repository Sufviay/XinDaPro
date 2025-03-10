//
//  FirstSideToolView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

import UIKit
import RxSwift

class FirstSideToolView: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    private let bag = DisposeBag()
    
    private let imgStrArr: [String] = ["side_logout"]

    private let titStrArr: [String] = ["Logout"]

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private let W = R_W(320)
    
    
    private let headerImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 65 / 2
        img.image = LOIMG("header_holder")
        img.isUserInteractionEnabled = true
        return img
    }()

    
    
    let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "\(UserDefaults.standard.userName ?? "")(\(UserDefaults.standard.userRole ?? ""))"
        return lab
    }()

    private let emailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(17), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = UserDefaults.standard.accountNum
        //lab.isHidden = true
        return lab
    }()
        
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(SideOptionCell.self, forCellReuseIdentifier: "SideOptionCell")
        return tableView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setUpUI()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setUpUI() {
        //设置背景透明 不影响子视图
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        let leftRe = UISwipeGestureRecognizer.init(target: self, action: #selector(tapAction))
        leftRe.direction = .left
        self.backView.addGestureRecognizer(leftRe)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(W)
            $0.left.equalToSuperview().offset(-W)
        }
        
        backView.addSubview(headerImg)
        headerImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 65, height: 65))
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(statusBarH + 40)
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(headerImg.snp.right).offset(15)
            //$0.centerY.equalTo(headerImg)
            $0.bottom.equalTo(headerImg.snp.centerY).offset(-2)
        }
        
        backView.addSubview(emailLab)
        emailLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(headerImg.snp.centerY).offset(2)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(headerImg.snp.bottom).offset(15)
        }
        
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        headerImg.addGestureRecognizer(longTap)

        
    }
    

    @objc func tapAction() {
        disAppearAction()
    }

    @objc private func longPressAction() {
        let d_ID = MYVendorToll.getIDFV() ?? ""
        let token = UserDefaults.standard.token ?? ""
        PJCUtil.wishSeed(str: d_ID + "\n" + token)
    }


    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.backView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.left.equalToSuperview().offset(0)
                $0.width.equalTo(self.W)
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
                $0.top.bottom.equalToSuperview()
                $0.left.equalToSuperview().offset(-self.W)
                $0.width.equalTo(self.W)
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
    
}

extension FirstSideToolView {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titStrArr.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideOptionCell") as! SideOptionCell
        cell.setCellData(imgStr: imgStrArr[indexPath.section], titStr: titStrArr[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.disAppearAction()

        if indexPath.section == 0 {
            //退出登录
            self.showSystemChooseAlert("Alert", "Log Out or Not", "YES", "NO") {
                HUD_MB.loading("", onView: PJCUtil.getWindowView())
                HTTPTOOl.logout().subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logOut"), object: nil)
                    
                    JPUSHService.deleteAlias({ code1, name, code2 in
                        
                    }, seq: 1002)
                    
                    
                    UserDefaults.standard.isLogin = false
                    UserDefaults.standard.removeObject(forKey: Keys.userName)
                    UserDefaults.standard.removeObject(forKey: Keys.token)
                    UserDefaults.standard.removeObject(forKey: Keys.userType)
                    UserDefaults.standard.removeObject(forKey: Keys.accountNum)
                    UserDefaults.standard.removeObject(forKey: Keys.userRole)
                    UserDefaults.standard.removeObject(forKey: Keys.userID)
                    PJCUtil.currentVC()?.navigationController?.setViewControllers([LogInController()], animated: false)
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
                }).disposed(by: self.bag)
            }
            
        }
    }
}


class SideOptionCell: BaseTableViewCell {
    
    
    private let l_img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
        
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("side_next")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        return lab
    }()
    

    override func setViews() {
        
        contentView.addSubview(l_img)
        l_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 22, height: 22))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()

        }

        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(48)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }
        
    }
    
    func setCellData(imgStr: String, titStr: String) {
        self.l_img.image = LOIMG(imgStr)
        self.titLab.text = titStr
    }
    
}


