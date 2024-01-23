//
//  DishDetailAttachCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/17.
//

import UIKit

class DishDetailAttachCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {

    //选择的分类下标
    private var selectIdx_C: Int = 0
    
    private var dataArr: [AttachClassifyModel] = []
    
    //选择的附加数据
    private var selectAttArr: [AttachModel] = []

    var selectBlock: VoidBlock?
    
    
    private let line1: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: S_W - 60, height: 0.5)
        view.drawDashLine(strokeColor: HCOLOR("#D8D8D8"), lineWidth: 0.5, lineLength: 5, lineSpacing: 5)
        return view
    }()

    
    
    private lazy var l_table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = HCOLOR("#FAFAFA")
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
        
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 6
        tableView.tag = 1
        tableView.register(AttachClassifyCell.self, forCellReuseIdentifier: "AttachClassifyCell")
        return tableView
    }()
    
    
    private lazy var r_table: UITableView = {
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
        tableView.register(AttachOptionCell.self, forCellReuseIdentifier: "AttachOptionCell")
        return tableView
    }()
    
    
    override func setViews() {
        
//        contentView.addSubview(titLab)
//        titLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(15)
//            $0.top.equalToSuperview().offset(15)
//        }
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(15)
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(l_table)
        l_table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(30)
            $0.width.equalTo(75)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        
        contentView.addSubview(r_table)
        r_table.snp.makeConstraints {
            $0.top.bottom.equalTo(l_table)
            $0.left.equalTo(l_table.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-15)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return dataArr.count
        }
        if tableView.tag == 2 {
            if dataArr.count != 0 {
                return dataArr[selectIdx_C].attachList.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return dataArr[indexPath.row].cell_H
        }
        
        if tableView.tag == 2 {
            return dataArr[selectIdx_C].attachList[indexPath.row].cell_H
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachClassifyCell") as! AttachClassifyCell
            
            let isSel = indexPath.row == selectIdx_C ? true: false
            
            cell.setCellData(model: dataArr[indexPath.row], isSelect: isSel)
            return cell
        }
        
        if tableView.tag == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachOptionCell") as! AttachOptionCell
            let model = dataArr[selectIdx_C].attachList[indexPath.row]
            let isSel =  selectAttArr.filter { $0.attachId == model.attachId }.count == 0 ? false : true
            cell.setCellData(model: model, isSelect: isSel)
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            //点击左侧分类刷新右侧
            if indexPath.row != selectIdx_C {
                selectIdx_C = indexPath.row
                l_table.reloadData()
                r_table.reloadData()
            }
        }
        
        if tableView.tag == 2 {
            
            //点击附加
            let model = dataArr[selectIdx_C].attachList[indexPath.row]
            
            if selectAttArr.filter({ $0.attachId == model.attachId }).count == 0 {
                selectAttArr.append(model)
            } else {
                selectAttArr = selectAttArr.filter { $0.attachId != model.attachId }
            }
            r_table.reloadData()
            selectBlock?(selectAttArr)
        }
        
    }
    
    
    
    func setCellData(modelArr: [AttachClassifyModel], selectAttach: [AttachModel]) {
        selectIdx_C = 0
        dataArr = modelArr
        selectAttArr = selectAttach
        l_table.reloadData()
        r_table.reloadData()
    }
}


class AttachClassifyCell: BaseTableViewCell {
    
    private let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(13), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(11), .left)
        lab.numberOfLines = 0
        return lab
    }()

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FEC501")
        return view
    }()
    
    
    override func setViews() {
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 4, height: 25))
        }
        
        contentView.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(namelab1.snp.bottom)
        }
        
    }
    
    
    func setCellData(model: AttachClassifyModel, isSelect: Bool) {
        namelab1.text = model.nameEn
        namelab2.text = model.nameHk
        
        if isSelect {
            line.isHidden = false
            namelab1.textColor = HCOLOR("#FEC501")
            namelab2.textColor = HCOLOR("#FEC501")
        } else {
            line.isHidden = true
            namelab1.textColor = HCOLOR("#000000")
            namelab2.textColor = HCOLOR("#888888")
        }
        
    }

}

class AttachOptionCell: BaseTableViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FAFAFA")
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let namelab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(13), .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let namelab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(11), .left)
        lab.numberOfLines = 0
        return lab
    }()

    private let moneylab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(11), .right)
        lab.text = "+£0.00"
        return lab
    }()
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xuanzhong")
        return img
    }()

    
    override func setViews() {
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        
        backView.addSubview(moneylab)
        moneylab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        backView.addSubview(namelab1)
        namelab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-90)
        }
        
        backView.addSubview(namelab2)
        namelab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-90)
            $0.top.equalTo(namelab1.snp.bottom)
        }
        
        backView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.right.bottom.equalToSuperview()
            $0.size.equalTo(CGSize(width: 15, height: 13))
        }

    }
    
    
    func setCellData(model: AttachModel, isSelect: Bool) {
        namelab1.text = model.nameEn
        namelab2.text = model.nameHk
        
        moneylab.text = "£\(D_2_STR(model.price))"
        
        
        if isSelect {
            selectImg.isHidden = false
            backView.backgroundColor = HCOLOR("#FEF7DF")
            backView.layer.borderWidth = 2
            backView.layer.borderColor = HCOLOR("#FEC501").cgColor
            
        } else {
            selectImg.isHidden = true
            backView.backgroundColor = HCOLOR("#FAFAFA")
            backView.layer.borderWidth = 0
            backView.layer.borderColor = HCOLOR("#FEC501").cgColor
        }

    }
    
}
