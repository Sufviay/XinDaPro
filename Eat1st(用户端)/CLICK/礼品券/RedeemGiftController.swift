//
//  RedeemGiftController.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/4.
//

import UIKit

class RedeemGiftController: BaseViewController, UITableViewDelegate, UITableViewDataSource {


    private let headerImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("giftheader")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(18), .center)
        lab.text = "Gift voucher"
        return lab
    }()
    
    
    private let backBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("nav_back"), for: .normal)
        return but
    }()
    
    
    private let tlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(15), .left)
        lab.text = "BALANCE"
        return lab
    }()
    
    private let tImg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jinbi")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(21), .left)
        lab.text = "500"
        return lab
    }()
    
    private let backView1: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#FFDD60"), HCOLOR("#FFCD18"), CGSize(width: S_W - 30, height: 255))
        img.isUserInteractionEnabled = true
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()
    
    
    private let tImg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("liwu 1")
        return img
    }()
    
    
    private let backView2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        return view
        
    }()
    
    
    private let backView3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("FFFFFF").withAlphaComponent(0.7)
        view.layer.cornerRadius = 7
        return view
    }()
    
    private let tImg3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("liwu 2")
        return img
    }()
    
    private let tLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Gift voucher exchange"
        return lab
    }()
    
    private let backView4: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private lazy var table1: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = false
        
        tableView.tag = 1
        tableView.register(GiftRedeemCell.self, forCellReuseIdentifier: "GiftRedeemCell")
        return tableView
    }()

    
    private let tagView: GiftRedeemTagView = {
        let view = GiftRedeemTagView()
        return view
    }()
    
    
    private lazy var table2: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = false
        
        tableView.tag = 2
        tableView.register(GiftBuiedCell.self, forCellReuseIdentifier: "GiftBuiedCell")
        return tableView
    }()
    


    
    override func setViews() {
        
        setUpUI()
    }

    
    private func setUpUI() {
        
        naviBar.isHidden = true
        
        view.addSubview(headerImg)
        headerImg.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(190)
        }
        
        view.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH)
            $0.height.equalTo(44)
        }
        
        
        view.addSubview(backBut)
        backBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalTo(titLab)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        view.addSubview(tlab1)
        tlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(backBut.snp.bottom).offset(15)
        }
                
        view.addSubview(tImg1)
        tImg1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 17, height: 17))
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(tlab1.snp.bottom).offset(5)
        }
        
        view.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.centerY.equalTo(tImg1)
            $0.left.equalTo(tImg1.snp.right).offset(5)
        }

        view.addSubview(tImg2)
        tImg2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 120, height: 100))
            $0.right.equalToSuperview().offset(-23)
            $0.bottom.equalTo(tlab1.snp.bottom).offset(65)
        }
        
        
        view.addSubview(backView1)
        backView1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(250)
            $0.top.equalTo(tlab1.snp.bottom).offset(40)
        }
        
        
        view.addSubview(backView2)
        backView2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(backView1.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }
        
        
        backView1.addSubview(backView3)
        backView3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(225)
            $0.top.equalToSuperview().offset(15)
            $0.height.equalTo(25)
        }
        
        backView3.addSubview(tImg3)
        tImg3.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 34, height: 34))
            $0.left.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-1)
        }
        
        backView3.addSubview(tLab2)
        tLab2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(44)
        }
        
        
        backView1.addSubview(backView4)
        backView4.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(55)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        backView4.addSubview(table1)
        table1.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(170)
            $0.centerY.equalToSuperview()
        }
        
        backView2.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(35)
        }
        
        backView2.addSubview(table2)
        table2.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(tagView.snp.bottom)
            
        }
        
        

        backBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
    }
    
    
    @objc private func clickBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
}


extension RedeemGiftController {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView.tag == 1 {
            return 85
        }
        
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return 2
        }
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GiftRedeemCell") as! GiftRedeemCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftBuiedCell") as! GiftBuiedCell
        return cell

    }
    
}
