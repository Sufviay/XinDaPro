//
//  FirstSideToolView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/26.
//

import UIKit
import RxSwift

class FirstSideToolView: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {
    
    
    var haveMsg: Bool = false {
        didSet {
            self.table.reloadSections([6], with: .none)
        }
    }
    
    var isHome: Bool = true
    
    private let bag = DisposeBag()
    
    var logOutBlock: VoidBlock?
    //"side_share", "side_feedback", "side_about"
    private let imgStrArr: [String] = ["side_home", "side_orders", "side_address", "side_jf", "side_yhq", "side_wallet", "side_msg", "side_help", "side_logout"]

    //"Share", "Feedback", "About",
    private let titStrArr: [String] = ["Home", "Your orders", "Address book", "Point", "Coupon", "Wallet", "Message", "Help",  "Logout"]

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let W = R_W(320)
    
    private let nextBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("side_info_next"), for: .normal)
        return but
    }()
    
    
    private let headerImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 65 / 2
        img.image = LOIMG("header_holder")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(17), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "First and Last Name"
        return lab
    }()
    
    private let emailLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(17), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = ""
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
        tableView.register(SideCouponsCell.self, forCellReuseIdentifier: "SideCouponsCell")
        tableView.register(SideOptionCell.self, forCellReuseIdentifier: "SideOptionCell")
        return tableView
    }()
    
    private let deAccountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(12), .center)
        lab.text = "Delete the account"
        lab.isUserInteractionEnabled = true
        return lab
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
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
        
        backView.addSubview(nextBut)
        nextBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalTo(headerImg)
            $0.right.equalToSuperview().offset(-5)
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(headerImg.snp.right).offset(15)
            $0.right.equalTo(nextBut.snp.left).offset(-5)
            $0.bottom.equalTo(headerImg.snp.centerY).offset(-2)
        }
        
        backView.addSubview(emailLab)
        emailLab.snp.makeConstraints {
            $0.left.right.equalTo(nameLab)
            $0.top.equalTo(headerImg.snp.centerY).offset(2)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(headerImg.snp.bottom).offset(15)
        }
        
        backView.addSubview(deAccountLab)
        deAccountLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalTo(deAccountLab)
            $0.height.equalTo(0.5)
            $0.top.equalTo(deAccountLab.snp.bottom)
        }
        
        
        let deTap = UITapGestureRecognizer(target: self, action: #selector(deTapAction))
        deAccountLab.addGestureRecognizer(deTap)
        
        nextBut.addTarget(self, action: #selector(clickInfoAction), for: .touchUpInside)
        
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        headerImg.addGestureRecognizer(longTap)
        
    }
    
    
    @objc private func longPressAction() {
        let d_ID = MYVendorToll.getIDFV() ?? ""
        let token = UserDefaults.standard.token ?? ""
        PJCUtil.wishSeed(str: d_ID + "\n" + token)
    }
    
    
    @objc private func clickInfoAction() {
        self.disAppearAction()
        let nextVC = PersonalInfoController()
        nextVC.isInfoCenter = true
        nextVC.isCanEdite = false
        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @objc private func deTapAction() {
        disAppearAction()
        //删除账户
        let deAlert = DeleteAccountAlert()
        deAlert.appearAction()
    }
    

    @objc func tapAction() {
        disAppearAction()
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
        
        if UserDefaults.standard.userName == "" || UserDefaults.standard.userName == nil {
            self.nameLab.text = "UserName"
        } else {
            self.nameLab.text = UserDefaults.standard.userName
        }

        
        let email = UserDefaults.standard.userEmail ?? ""
        let phone = UserDefaults.standard.userPhone ?? ""
        
        if email != "" {
            self.emailLab.text = email
        }
        
        if  phone != "" {
            self.emailLab.text = phone
        }
        
        if email == "" && phone == "" {
            self.emailLab.text = ""
        }
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
        
        if section == 0 {
            if isHome {
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SideCouponsCell") as! SideCouponsCell
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideOptionCell") as! SideOptionCell
        
        var imgStr = ""
        if indexPath.section == 6 && haveMsg {
            imgStr = "side_msg_r"
        } else {
            imgStr = imgStrArr[indexPath.section]
        }
        
        cell.setCellData(imgStr: imgStr, titStr: titStrArr[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.disAppearAction()
        
        if indexPath.section == 0 {
            //返回首页
            //self.disAppearAction()
            PJCUtil.currentVC()?.navigationController?.popViewController(animated: true)
        }

        
        if indexPath.section == 1 {
            //点单页面
            //self.disAppearAction()
            let orderVC = OrderListController()
            PJCUtil.currentVC()?.navigationController?.pushViewController(orderVC, animated: true)
        }
        
        if indexPath.section == 2 {
            //地址管理
            let addressVC = ChooseAddressController()
            PJCUtil.currentVC()?.navigationController?.pushViewController(addressVC, animated: true)
        }
        
        if indexPath.section == 4 {
            //优惠券
            let couponVC = CouponListController()
            PJCUtil.currentVC()?.navigationController?.pushViewController(couponVC, animated: true)
        }
        
        
        if indexPath.section == 5 {
            //点击钱包
            self.disAppearAction()
            let walletVC = WalletController()
            PJCUtil.currentVC()?.navigationController?.pushViewController(walletVC, animated: true)
        }
        
        
        if indexPath.section == 7 {
            //帮助
            self.disAppearAction()
            let nextVC = FAQController()
            PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)

        }
        
        if indexPath.section == 6 {
            //点击消息
            let nextVC = MessageListController()
            PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 3 {
            //积分
            let nextVC = JiFenDetailController()
            PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 8 {
            //退出
            self.disAppearAction()
            self.showSystemChooseAlert("Alert", "Log Out or Not", "YES", "NO") {
                HUD_MB.loading("", onView: PJCUtil.getWindowView())
                HTTPTOOl.logout().subscribe(onNext: { (json) in
                    HUD_MB.dissmiss(onView: PJCUtil.getWindowView())
                    UserDefaults.removeAll()
                    FirebaseLoginManager.shared.doLogout()
                    NotificationCenter.default.post(name: NSNotification.Name("login"), object: nil)
                    PJCUtil.currentVC()?.navigationController?.popToRootViewController(animated: false)
//                    PJCUtil.currentVC()?.navigationController?.setViewControllers([FirstController()], animated: false)
                    
                }, onError: { (error) in
                    HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
                }).disposed(by: self.bag)
            }
        }
    }
}


