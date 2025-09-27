//
//  MenuGiftDetailController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/27.
//

import UIKit
import RxSwift
import HandyJSON

class MenuGiftDetailController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {


    private let bag = DisposeBag()
    
    var giftID: String = ""
    
    private var dishModel = GiftDetailModel()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    private let rightBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dish_delete"), for: .normal)
        return but
    }()
    
    private lazy var table: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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

        tableView.register(DishDetailEditeCell.self, forCellReuseIdentifier: "DishDetailEditeCell")
        tableView.register(DishListPictureCell.self, forCellReuseIdentifier: "DishListPictureCell")        
        tableView.register(DishDetailMsgCell.self, forCellReuseIdentifier: "DishDetailMsgCell")
        
        return tableView
        
    }()

    
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Gift detail"
        self.loadData_Net()
    }

    
    
    override func setViews() {
        setUpUI()
    }
    
    
    private func setUpUI() {
        
        view.addSubview(rightBut)
        rightBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(statusBarH + 15)
            $0.size.equalTo(CGSize(width: 50, height: 40))
        }
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
            
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
        }
        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        self.rightBut.addTarget(self, action: #selector(clickRightAction), for: .touchUpInside)
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func clickRightAction() {
        //删除
        self.showSystemChooseAlert("Alert".local, "Delete or not?".local, "YES".local, "NO".local) {
            self.deleteDish_Net()
        }
    }
    
    
    
    //MARK: - Delegete
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let h1 = dishModel.dishName1.getTextHeigh(BFONT(17), S_W - 120)
            let h2 = dishModel.dishName2.getTextHeigh(SFONT(15), S_W - 120)
            return 25 + 15 + h1 + h2
        }
        if indexPath.row == 1 {
            return 66
        }
        
        if indexPath.row == 2 {
            let h = dishModel.classifyStr.getTextHeigh(TXT_1, S_W - 80)
            return h + 50
        }
        
        if indexPath.row == 3 {
            return 110
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailEditeCell") as! DishDetailEditeCell
            cell.setCellData(name1: dishModel.dishName1, name2: dishModel.dishName2)
            cell.editeBlock = { [unowned self] (_) in
                //进入编辑菜品页面
                let nextVC = MenuGiftAddController()
                nextVC.giftID = self.giftID
                nextVC.isAdd = false
                self.navigationController?.pushViewController(nextVC, animated: true)

            }
            return cell
        }
        
        if indexPath.row == 1 || indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailMsgCell") as! DishDetailMsgCell
            if indexPath.row == 1 {
                cell.setCellData(titStr: "Serial number", msgStr: dishModel.giftCode)
            }
            if indexPath.row == 2 {
                cell.setCellData(titStr: "Category", msgStr: dishModel.classifyStr)
            }
            return cell
        }
        
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishListPictureCell") as! DishListPictureCell
            cell.setCellData(titStr: "Gift picture", picUrl: dishModel.showImageUrl)
            return cell

        }
        
        let cell = UITableViewCell()
        return cell
        
        
    }
    
}


extension MenuGiftDetailController {
    
    //MARK: - 网络请求
    private func loadData_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getGiftDetail(id: giftID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.dishModel = GiftDetailModel.deserialize(from: json.dictionaryObject!, designatedPath: "data")!
            self.dishModel.updateModle()
            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    //MARK: - 删除
    private func deleteDish_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.deleteGift(id: giftID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            self.navigationController?.popViewController(animated: true)
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
}
