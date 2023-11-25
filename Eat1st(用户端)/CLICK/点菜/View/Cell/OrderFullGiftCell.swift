//
//  OrderFullGiftCell.swift
//  CLICK
//
//  Created by 肖扬 on 2023/10/19.
//

import UIKit

class OrderFullGiftCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectGiftDishBlock: VoidBlock?
    
    private var selectedID: String = ""

    private var dishArr: [CartDishModel] = []
    
    private var canChoose: Bool = false

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private let re_titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(13), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("order_alert")
        return img
    }()
        
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
        tableView.isScrollEnabled = false
        tableView.register(GiftDishesCell.self, forCellReuseIdentifier: "GiftDishesCell")
        return tableView
    }()
    
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.top.equalToSuperview()
        }
        

        backView.addSubview(re_titlab)
        re_titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 13, height: 13))
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalTo(re_titlab)
        }
    
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
            //$0.top.equalTo(re_titlab.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    
        
    }
    
    
    func setCellData(model: FullGiftModel, selGiftDishesID: String) {
        
        selectedID = selGiftDishesID
        
        if model.chooseType == "2" {
            //可以选择
            canChoose = true
        } else {
            canChoose = false
        }
        
        dishArr = model.dishesList
        re_titlab.text = "Free when the order amount is up £\(D_2_STR(model.price))"
        table.reloadData()

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishArr.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dishArr[indexPath.row].giftDish_H
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftDishesCell") as! GiftDishesCell
        let sel = selectedID == dishArr[indexPath.row].giftDishesId ? true : false
        cell.setCellData(model: dishArr[indexPath.row], canChoose: canChoose, isSelected: sel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if canChoose {
            
            let model = dishArr[indexPath.row]
            
            if model.giftDishesId == selectedID {
                selectedID = ""
            } else {
                selectedID = model.giftDishesId
            }
            selectGiftDishBlock?(selectedID)
        }
    }
}



class GiftDishesCell: BaseTableViewCell {
    
    
    var canChoose: Bool = false
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        return img
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.numberOfLines = 0
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "Dish Name 1"
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .right)
        lab.text = "x1"
        return lab
    }()

    
    private let freeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#2AD389"), BFONT(18), .right)
        lab.text = "FREE"
        return lab
    }()
    
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("unsel")
        return img
    }()
    
    private let tview: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#DADADA").withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(CGSize(width: 55, height: 55))
        }
        
        goodsImg.addSubview(tview)
        tview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 13, height: 13))
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
        

        contentView.addSubview(freeLab)
        freeLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-45)
            $0.bottom.equalTo(goodsImg.snp.centerY).offset(-2)
        }

        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-45)
            $0.top.equalTo(freeLab.snp.bottom).offset(2)
        }
        
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(75)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-100)
        }
        
        
        
    }
    
    
    func setCellData(model: CartDishModel, canChoose: Bool, isSelected: Bool) {
        nameLab.text = model.dishName
        goodsImg.sd_setImage(with: URL(string: model.dishImg))
        
        if canChoose {
            nameLab.textColor = FONTCOLOR
            countLab.textColor = HCOLOR("666666")
            tview.isHidden = true
            
        } else {
            nameLab.textColor = HCOLOR("#DADADA")
            countLab.textColor = HCOLOR("#DADADA")
            tview.isHidden = false
        }
        
        
        if isSelected {
            selectImg.image = LOIMG("coupon_sel")
        } else {
            selectImg.image = LOIMG("coupon_unsel")
        }
        
    }
    
    
    func setCouponCellData(model: CartDishModel, canChoose: Bool, isSelected: Bool) {
        
        if isSelected {
            selectImg.image = LOIMG("coupon_sel")
        } else {
            selectImg.image = LOIMG("coupon_unsel")
        }

        selectImg.isHidden = !canChoose
        
        
        nameLab.text = model.dishName
        goodsImg.sd_setImage(with: URL(string: model.dishImg))
        tview.isHidden = true

    }
    
    
}
