//
//  MenuCartView.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/7.
//

import UIKit
import RxSwift

class MenuCartView: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, SystemAlertProtocol {

    private let bag = DisposeBag()
    
    var storeID: String = ""
    
    var cartDataArr: [CartDishModel] = [] {
        didSet {
            
            //计算菜品高度
            self.H = getDishesHigh()
            self.backView.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: H), byRoundingCorners: [.topLeft, .topRight], radii: 20)
            self.table.reloadData()
        }
    }
    
    private var H: CGFloat = 300
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let deBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("cart_clean"), for: .normal)
        but.setCommentStyle(.zero, "EMPTY", HCOLOR("666666"), SFONT(13), .clear)
        //改变图片文字的间隔
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        return but
    }()
    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("cart_cancel"), for: .normal)
        return but
    }()
    
    private lazy var table: UITableView = {
        let tableView = GestureTableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MenuCartGoodsCell.self, forCellReuseIdentifier: "MenuCartGoodsCell")
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

        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(H)
            $0.height.equalTo(H)
        }
        
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
        backView.addSubview(deBut)
        deBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 80, height: 40))
            $0.left.equalToSuperview().offset(5)
            $0.centerY.equalTo(closeBut)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 50 - 30)
            $0.left.right.equalToSuperview()
        }
        
        deBut.addTarget(self, action: #selector(deleteAllAction), for: .touchUpInside)
        closeBut.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
    }
    
    
    
    
    
    //清空购物车
    @objc private func deleteAllAction() {
        self.showSystemChooseAlert("Tip", "Empty shopping cart", "YES", "NO") {
            self.emptyCart_Net()
        } _: {}
    }
    
    //取消
    @objc func cancelAction() {
        self.disAppearAction()
    }

    //计算菜品高度
    private func getDishesHigh() -> CGFloat {
        var d_h: CGFloat = 0
        for model in cartDataArr {
            d_h += model.dish_H
        }
        
        let a_h = d_h + 45 + 80 + bottomBarH
        
        return a_h > (bottomBarH + 530) ? (bottomBarH + 530) : a_h
        
    }
    
    
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
    
    
    @objc private func tapAction() {
        disAppearAction()
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
}


extension MenuCartView {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartDataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = cartDataArr[indexPath.row]
//        let n_h = model.dishName.getTextHeigh(BFONT(17), S_W - 160)
//        let d_h = model.selectOptionStr.getTextHeigh(SFONT(11), S_W - 160)
//        let h = (n_h + d_h + 90) > 130 ? (n_h + d_h + 90) : 130
        return model.dish_H
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCartGoodsCell") as! MenuCartGoodsCell
        cell.setCellData(model: cartDataArr[indexPath.row])
        
        cell.clickCountBlock = { [unowned self] (par) in
            let count = par as! Int
            self.updateCart_Net(cartID: self.cartDataArr[indexPath.row].cartID, buyNum: count, idx: indexPath.row)
        }
        
        cell.clickDeleteBlock = { [unowned self] (_) in
            self.deleteCartGoods_Net(id: self.cartDataArr[indexPath.row].cartID, idx: indexPath.row)
        }
        
        return cell

    }
    
}


extension MenuCartView {
    
    //MARK: - 修改购物车
    private func updateCart_Net(cartID: String, buyNum: Int, idx: Int) {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.updateCartNum(buyNum: buyNum, cartID: cartID).subscribe(onNext: { (json) in
            
            
            //发送通知刷新点餐页面
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
           
            if buyNum == 0 {
                self.cartDataArr.remove(at: idx)
                self.backView.snp.updateConstraints {
                    $0.height.equalTo(self.H)
                }
            } else {
                self.cartDataArr[idx].cartCount = buyNum
            }
            self.table.reloadData()
            
            if self.cartDataArr.count == 0 {
                self.disAppearAction()
            }
            HUD_MB.dissmiss(onView: self.backView)
        
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
        }).disposed(by: self.bag)
    }

    
    //MARK: - 清空购物车
    private func emptyCart_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.emptyCart(storeID: storeID).subscribe(onNext: { (json) in
            //发送通知刷新点餐页面
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
            self.cartDataArr.removeAll()
            self.table.reloadData()
            self.disAppearAction()
            HUD_MB.dissmiss(onView: self.backView)
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
        }).disposed(by: self.bag)
    }
    
    
    //MARK: - 删除购物车商品
    private func deleteCartGoods_Net(id: String, idx: Int) {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.deleteCartGoods(id: id).subscribe(onNext: { (json) in
            //发送通知刷新点餐页面
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cartRefresh"), object: nil)
           
            self.cartDataArr.remove(at: idx)
            self.backView.snp.updateConstraints {
                $0.height.equalTo(self.H)
            }
            self.table.reloadData()
            
            if self.cartDataArr.count == 0 {
                self.disAppearAction()
            }
            HUD_MB.dissmiss(onView: self.backView)

        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
        }).disposed(by: self.bag)
        
    }
    
}
