//
//  AfterSalesGoodsCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/5.
//

import UIKit

class AfterSalesGoodsCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var clickCountBlock: VoidBlock?

    
    private var dataArr: [PlaintDishModel] = []
    
    
    private let backView: UIView = {
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
        
        tableView.register(AfterSalesSelectGoodsCell.self, forCellReuseIdentifier: "AfterSalesSelectGoodsCell")
        
        return tableView
    }()

    
    override func setViews() {
        
        
        contentView.backgroundColor = .white
        self.backgroundColor = .white
        
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-10)
        }

        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AfterSalesSelectGoodsCell") as! AfterSalesSelectGoodsCell
        cell.setCellData(model: dataArr[indexPath.row])
        
        cell.clickCountBlock = { [unowned self] (count) in
            self.dataArr[indexPath.row].selectCount = count as! Int
            self.clickCountBlock?("")
        }
        
        return cell
        
    }
    
    
    
    func setCellData(dataArr: [PlaintDishModel]) {
        self.dataArr = dataArr
        self.table.reloadData()
    }
    
}


class AfterSalesSelectGoodsCell: BaseTableViewCell {
    
    var clickCountBlock: VoidBlock?

    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    
    private let goodsImg: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        return img
    }()

    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .left)
        lab.text = "Dish Name 1"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let slab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let moneyLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(14), .right)
        lab.text = "10.9"
        return lab
    }()
    
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(13), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "options,options,options,options"
        lab.numberOfLines = 0
        return lab
    }()
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#777777"), SFONT(13), .left)
        lab.lineBreakMode = .byTruncatingTail
        lab.text = "x2"
        return lab
    }()
    
    
    private lazy var selectView: CountSelectView = {
        let view = CountSelectView()
        view.countBlock = { [unowned self] (count) in
            print(count as! Int)
            self.clickCountBlock?(count as! Int)
        }
        return view
    }()

    
    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.bottom.equalToSuperview()
        }
        
        
        backView.addSubview(goodsImg)
        goodsImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(55)
        }
        
        backView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalTo(goodsImg.snp.right).offset(15)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-110)
        }
        
        backView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(3)
            $0.right.equalToSuperview().offset(-110)
        }
        
        backView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(desLab.snp.bottom).offset(2)
        }
        
        backView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(nameLab)
        }
        
        backView.addSubview(slab)
        slab.snp.makeConstraints {
            $0.right.equalTo(moneyLab.snp.left).offset(-1)
            $0.bottom.equalTo(moneyLab).offset(-2)
        }
        
        backView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(moneyLab.snp.bottom).offset(10)
        }

    }
    
    
    
    func setCellData(model: PlaintDishModel) {
        self.goodsImg.sd_setImage(with: URL(string: model.listImg), placeholderImage: LOIMG("zwt"))
        self.countLab.text = "x\(model.count)"
        self.nameLab.text = model.name_C
        self.desLab.text = model.des_C
        self.moneyLab.text = String(model.price)
        self.selectView.count = model.selectCount
        self.selectView.maxCount = model.count
    }
}



