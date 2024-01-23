//
//  CartView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/18.
//

import UIKit

class CartView: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    
    var cleanAllBlock: VoidBlock?
    
    //删除
    var deleteBlock: VoidBlock?
    
    //进入菜品详情
    var detailBlock: VoidIntBlock?
    
    
    private var H: CGFloat = S_H - R_H(170)
    
    var dataModel = CartModel()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - R_H(170)), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()

    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("close"), for: .normal)
        but.backgroundColor = .clear
        return but
    }()
    
    private let cleanBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "CLEAN ALL", HCOLOR("#FEC501"), BFONT(10), .clear)
        but.setImage(LOIMG("clear"), for: .normal)
        return but
    }()
    
    
    private let jiaoqiBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Course Divider", HCOLOR("#080808"), BFONT(11), HCOLOR("#FEC501"))
        but.layer.cornerRadius = 7
        return but
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
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(CartJiaoQiCell.self, forCellReuseIdentifier: "CartJiaoQiCell")
        tableView.register(CartDishCell.self, forCellReuseIdentifier: "CartDishCell")
        return tableView
    }()
    
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(H)
            $0.height.equalTo(H)
        }

        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(0)
        }
        
        backView.addSubview(cleanBut)
        cleanBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.width.equalTo(100)
            $0.centerY.equalTo(closeBut)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(jiaoqiBut)
        jiaoqiBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 65 - 10)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
            $0.bottom.equalTo(jiaoqiBut.snp.top).offset(-10)
        }

        
        

        closeBut.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cleanBut.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        jiaoqiBut.addTarget(self, action: #selector(jiaoqiAction), for: .touchUpInside)
    }
    
    
    
    @objc private func tapAction() {
        disAppearAction()
    }

    //取消
    @objc private func cancelAction() {
        self.disAppearAction()
    }

    //清除购物车
    @objc private func clearAction() {
        
        showSystemChooseAlert("Tip", "Whether to empty shopping cart?", "Clean", "Cancel") { [unowned self] in
            dataModel.showJiaoqi = false
            dataModel.dishesList.removeAll()
            updateData()
            //updateData(f_d_price: "0", ser_price: "0")
            cleanAllBlock?("")
        }
    }
    
    //叫起
    @objc private func jiaoqiAction() {
        
        if dataModel.dishesList.count == 0 {
            dataModel.showJiaoqi = true
        } else {
            dataModel.dishesList.last!.showJiaoqi = true
        }
        
        table.reloadData()
        
    }
    
    
    func updateData() {
        table.reloadData()
    }
    
//    func updateData(f_d_price: String, ser_price: String) {
//        F_D_totalMoney.text = "£\(f_d_price)"
//        serviceMoney.text = "£\(ser_price)"
//    }
    
    
    func appearAction() {
        //做动画
        
        if self.isHidden == true {
            self.isHidden = false
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
    }
    
    func disAppearAction() {
        if self.isHidden == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.backView.snp.remakeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(self.H)
                    $0.height.equalTo(self.H)
                }
                self.layoutIfNeeded()
            }) { (_) in
                self.isHidden = true
            }
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel.dishesList.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if dataModel.showJiaoqi {
                return 1
            } else {
                return 0
            }
            
            //return 1
        } else {
            
            //return 2
            
            if dataModel.dishesList[section - 1].showJiaoqi {
                return 2
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 20
        } else {
            if indexPath.row == 0 {
                return dataModel.dishesList[indexPath.section - 1].cell_H
            } else {
                return 20
            }
        }
        

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartJiaoQiCell") as! CartJiaoQiCell
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartDishCell") as! CartDishCell
                cell.setCellData(model: dataModel.dishesList[indexPath.section - 1])
                
                cell.deleteBlock = { [unowned self] (_) in
                    //删除
                    showSystemChooseAlert("Tip", "Do you want to delete?", "Delete", "Cancel") { [unowned self] in
                        dataModel.dishesList.remove(at: indexPath.section - 1)
                        updateData()
                        deleteBlock?("")
                    }
                }
                
                cell.detailBlock = { [unowned self] (_) in
                    //点击菜品 进入菜品详情进行编辑
                    detailBlock?(indexPath.section - 1)
                }
    
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CartJiaoQiCell") as! CartJiaoQiCell
                return cell

            }
        }
    
    }
    
}
