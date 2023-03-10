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
    
    private let imgStrArr: [String] = ["side_home", "side_set", "side_review", "side_tousu", "side_fankui", "side_about"]

    private let titStrArr: [String] = ["Home", "Restaurant settings", "Reviews", "Complaints", "Feedback", "About"]

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: R_W(320), height: S_H), byRoundingCorners: [.topRight, .bottomRight], radii: 20)
        return view
    }()
    
    
    private let W = R_W(320)
    
    
    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("side_back")
        return img
    }()
    
    
    private let headerImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.backgroundColor = HOLDCOLOR
        img.image = LOIMG("icon")
        
        //img.image = LOIMG("header_holder")
        return img
    }()
    
    let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "\(UserDefaults.standard.userName ?? "")"
        return lab
    }()

    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, SFONT(12), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = UserDefaults.standard.accountNum
        //lab.numberOfLines = 2
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
        tableView.register(logOutCell.self, forCellReuseIdentifier: "logOutCell")
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
        
        backView.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.width.equalTo(R_W(285))
            $0.height.equalTo(SET_H(108, 285))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + R_H(35))
        }
        
        backImg.addSubview(headerImg)
        headerImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        backImg.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(headerImg.snp.right).offset(15)
            $0.bottom.equalTo(headerImg.snp.centerY).offset(-2)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backImg.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(headerImg.snp.centerY).offset(2)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(backImg.snp.bottom).offset(30)
        }
        
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
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "logOutCell") as! logOutCell
        return cell

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.disAppearAction()
        

        //退出
        self.showSystemChooseAlert("Alert", "Log Out or Not", "YES", "NO") {
            HUD_MB.loading("", onView: PJCUtil.getWindowView())
            HTTPTOOl.userLogOut().subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: PJCUtil.getWindowView())

                UserDefaults.standard.isLogin = false
                UserDefaults.standard.removeObject(forKey: Keys.userName)
                UserDefaults.standard.removeObject(forKey: Keys.token)
                UserDefaults.standard.removeObject(forKey: Keys.accountNum)
                PJCUtil.currentVC()?.navigationController?.setViewControllers([LogInController()], animated: false)
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
            }).disposed(by: self.bag)
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
        img.image = LOIMG("side_next_b")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .left)
        return lab
    }()
    

    override func setViews() {
        
        contentView.addSubview(l_img)
        l_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()

        }

        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(70)
        }
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(width: 7, height: 12))
        }
        
    }
    
    func setCellData(imgStr: String, titStr: String) {
        self.l_img.image = LOIMG(imgStr)
        self.titLab.text = titStr
    }
    
    
}



class logOutCell: BaseTableViewCell {
    
    
    var clickLogoutBlock: VoidBlock?
    
    private let backView: UIButton = {
        let but = UIButton()
        but.backgroundColor = HCOLOR("#465DFD").withAlphaComponent(0.15)
        but.layer.cornerRadius = 15
        but.isEnabled = false
        return but
        
    }()
    
    private let l_img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = LOIMG("side_tuichu")
        return img
        
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("side_next_b")
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#465DFD"), BFONT(14), .left)
        lab.text = "Logout"
        return lab
    }()

    
    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        
        backView.addSubview(l_img)
        l_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 35, height: 35))
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()

        }

        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(l_img.snp.right).offset(15)
        }
        
        backView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 7, height: 12))
        }
        
        backView.addTarget(self, action: #selector(clickLogoutAction), for: .touchUpInside)
    
    }
    
    
    @objc private func clickLogoutAction() {
        clickLogoutBlock?("")
    }
    
    
}



