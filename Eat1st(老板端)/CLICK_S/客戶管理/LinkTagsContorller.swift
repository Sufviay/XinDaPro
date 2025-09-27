//
//  LinkTagsContorller.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/25.
//

import UIKit
import RxSwift

class LinkTagsContorller: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let bag = DisposeBag()
    
    private var dataArr: [CustomerTagModel] = []
    
    var selectTags: [CustomerTagModel] = []
    var userID: String = ""

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    

    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
            
        //回弹效果
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(LinkTagsInfoCell.self, forCellReuseIdentifier: "LinkTagsInfoCell")
        return tableView
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.frame = table.bounds
        return view
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 14
        return but
    }()

    

    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Customer Tags".local
    }

    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }

    
    private func setUpUI() {
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(S_H - statusBarH - 80)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        
        view.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(saveBut.snp.top).offset(-10)
        }
        leftBut.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        table.mj_header = CustomRefreshHeader() { [unowned self] in
            loadData_Net(true)
        }
        

    }


    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc private func saveAction() {
        saveData_Net()
    }


    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let h1 = dataArr[indexPath.row].name1.getTextHeigh(TIT_3, S_W - 80)
        let h2 = dataArr[indexPath.row].name2.getTextHeigh(TXT_1, S_W - 80)
        return h1 + h2 + 35
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "LinkTagsInfoCell") as! LinkTagsInfoCell
    
        var select: Bool = false
        let model = dataArr[indexPath.row]
        let arr = selectTags.filter { $0.tagId == model.tagId }
        if arr.count != 0 {
            select = true
        }
        cell.setCellData(name1: model.name1, name2: model.name2, isSelect: select)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.row]
        let arr = selectTags.filter { $0.tagId == model.tagId }
        if arr.count != 0 {
            selectTags = selectTags.filter { $0.tagId != model.tagId }
        } else {
            selectTags.append(model)
        }
        table.reloadData()
    }
    
    
    
    private func loadData_Net(_ isLoading: Bool = false) {
        
        if !isLoading {
            HUD_MB.loading("", onView: view)
        }
        
        HTTPTOOl.getCustomerTagList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: view)
            
            var tArr: [CustomerTagModel] = []
            for jsonData in json["data"].arrayValue {
                let model = CustomerTagModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            dataArr = tArr
            
            if dataArr.count == 0 {
                table.addSubview(noDataView)
            } else {
                noDataView.removeFromSuperview()
            }
            
            table.reloadData()
            table.mj_header?.endRefreshing()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
            table.mj_header?.endRefreshing()
        }).disposed(by: bag)
    }
    
    
    private func saveData_Net() {
        
        var taglist: [String] = []
        for model in selectTags {
            taglist.append(model.tagId)
        }
        HUD_MB.loading("", onView: view)
        HTTPTOOl.userLinkTags(userID: userID, tagList: taglist).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.showSuccess("Success".local, onView: view)
            DispatchQueue.main.after(time: .now() + 1.5) {
                self.navigationController?.popViewController(animated: true)
            }

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)
    }




}


class LinkTagsInfoCell: BaseTableViewCell {
    
    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dish_unsel_b")
        return img
    }()
    
    private let nameLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let nameLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_1, .left)
        lab.numberOfLines = 0
        return lab
    }()

    
    override func setViews() {
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(nameLab1)
        nameLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(nameLab2)
        nameLab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(nameLab1.snp.bottom).offset(5)
        }
    }
    
    
    func setCellData(name1: String, name2: String, isSelect: Bool) {
        nameLab1.text = name1
        nameLab2.text = name2
        
        if isSelect {
            sImg.image = LOIMG("dish_sel_b")
        } else {
            sImg.image = LOIMG("dish_unsel_b")
        }
        
    }
    
}
