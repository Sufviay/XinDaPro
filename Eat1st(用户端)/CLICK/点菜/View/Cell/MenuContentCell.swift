//
//  MenuContentCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/2.
//

import UIKit

class MenuContentCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    var deskID: String = ""
    
    var isSelect: Bool = false
    
    ///弹出购物车
    var showCartBlock: VoidBlock?

    ///更新购物车
    var updateCartBlock: VoidBlock?
    
    ///添加购物车（0 ->1 ）
    var addCartBlock: VoidBlock?
    
    ///菜品数据
    private var dishData = MenuModel()
    
    ///当前菜品是否可以购买
    private var canBuy: Bool = false
    
//    ///当前选中的分类下标
//    private var curSel_Idx: Int = 0
    
    //是否可以滑动
    var canSroll: Bool = false
    
    ///适配放大模式
    private var isBig: Bool = (S_W - 230) < 140

    
    private lazy var l_table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = HCOLOR("#F9F9F9")
        //去掉单元格的线
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.bounces = true
        tableView.tag = 0
        tableView.register(MenuTypeCell.self, forCellReuseIdentifier: "MenuTypeCell")
        
        return tableView
    }()
    
    lazy var r_table: GestureTableView = {
        let tableView = GestureTableView(frame: .zero, style: .grouped)
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
        tableView.tag = 1
        tableView.bounces = false
                
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        
        
        tableView.register(ClassifySectionHeader.self, forHeaderFooterViewReuseIdentifier: "ClassifySectionHeader")
        tableView.register(MenuGoodsNoSizeCell.self, forCellReuseIdentifier: "MenuGoodsNoSizeCell")
        tableView.register(MenuGoodsSizeCell.self, forCellReuseIdentifier: "MenuGoodsSizeCell")
        tableView.register(MenuDishesCell.self, forCellReuseIdentifier: "MenuDishesCell")
        
        //tableView.register(Big_MenuGoodsNoSizeCell.self, forCellReuseIdentifier: "Big_MenuGoodsNoSizeCell")
        //tableView.register(Big_MenuGoodsSizeCell.self, forCellReuseIdentifier: "Big_MenuGoodsSizeCell")

        return tableView
    }()

    
    

    override func setViews() {
    
        contentView.backgroundColor = .white
        addCenterNotification()
        
        contentView.addSubview(l_table)
        l_table.snp.makeConstraints {
            $0.left.bottom.top.equalToSuperview()
            $0.width.equalTo(90)
        }
        
        contentView.addSubview(r_table)
        r_table.snp.makeConstraints {
            $0.left.equalTo(l_table.snp.right)
            $0.right.bottom.top.equalToSuperview()
        }
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0 {
            return 1
        }
        
        return dishData.pageDataArr.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return dishData.pageDataArr.count
        }
        return dishData.pageDataArr[section].dishArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            let h = dishData.pageDataArr[indexPath.row].flName_C.getTextHeigh(BFONT(13), 70) + 35
            return h > 50 ? h : 50
        }
        let model = dishData.pageDataArr[indexPath.section].dishArr[indexPath.row]
        return model.dish_H
        
        
    }
    
    ///头部Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 1 {
            let h = dishData.pageDataArr[section].flName_C.getTextHeigh(BFONT(15), S_W - 90 - 40)
            return h + 10
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if tableView.tag == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClassifySectionHeader") as! ClassifySectionHeader
            header.titLab.text = dishData.pageDataArr[section].flName_C

            return header
        }
        return nil
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTypeCell") as! MenuTypeCell
            let isSelect: Bool = indexPath.row == dishData.classifyIdx ? true : false
            cell.setCellData(isSelect: isSelect, name: dishData.pageDataArr[indexPath.row].flName_E)
            
            return cell
        }
        
        if tableView.tag == 1 {
            
            let model = dishData.pageDataArr[indexPath.section].dishArr[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDishesCell") as! MenuDishesCell
            cell.setCellData(model: model, canBuy: canBuy)
            
            cell.optionBlock = { [unowned self] _ in
                ///进入选择规格页面
                
                if model.dishesType == "1" {
                    //单品
                    let nextVC = SelectSizeController()
                    nextVC.dishesID = model.dishID
                    nextVC.canBuy = self.canBuy
                    nextVC.deskID = self.deskID
                    PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
                }
                if model.dishesType == "2" {
                    //套餐
                    let nextVC = MealSelectSizeController()
                    nextVC.dishesID = model.dishID
                    nextVC.canBuy = self.canBuy
                    nextVC.deskID = self.deskID
                    PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            
            cell.clickCountBlock = { [unowned self] (par) in
                
                let count = par as! Int
                var dic: [String: Any] = [:]
                if model.sel_Num == 0 {
                    //添加购物车
                    dic = ["num": count, "id": model.dishID]
                    self.addCartBlock?(dic)
                    
                } else {
                    //更新购物车
                    dic = ["num": count, "id": model.cart[0].cartID]
                    self.updateCartBlock?(dic)
                }
            }

            
            return cell

            
//            //套餐也要去选择规格
//            if model.isSelect || model.dishesType == "2" {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuGoodsSizeCell") as! MenuGoodsSizeCell
//                cell.setCellData(model: model, canBuy: canBuy)
//
//
//                cell.optionBlock = { [unowned self] _ in
//                    ///进入选择规格页面
//
//                    if model.dishesType == "1" {
//                        //单品
//                        let nextVC = SelectSizeController()
//                        nextVC.dishesID = model.dishID
//                        nextVC.canBuy = self.canBuy
//                        nextVC.deskID = self.deskID
//                        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
//                    }
//                    if model.dishesType == "2" {
//                        //套餐
//                        let nextVC = MealSelectSizeController()
//                        nextVC.dishesID = model.dishID
//                        nextVC.canBuy = self.canBuy
//                        nextVC.deskID = self.deskID
//                        PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
//                    }
//                }
//
//                return cell
//
//            } else {
//
//                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuGoodsNoSizeCell") as! MenuGoodsNoSizeCell
//                cell.setCellData(model: model, canBuy: canBuy)
//
//                cell.clickCountBlock = { [unowned self] (par) in
//
//                    let count = par as! Int
//                    var dic: [String: Any] = [:]
//                    if model.sel_Num == 0 {
//                        //添加购物车
//                        dic = ["num": count, "id": model.dishID]
//                        self.addCartBlock?(dic)
//
//                    } else {
//                        //更新购物车
//                        dic = ["num": count, "id": model.cart[0].cartID]
//                        self.updateCartBlock?(dic)
//                    }
//                }
//
//                return cell
//            }
        }
                
        let cell = UITableViewCell()
        return cell
    }
    

    
    func setCellData(model: MenuModel, deskID: String) {
        self.dishData = model
        self.deskID = deskID
        
        if dishData.openTimeArr.count == 0 {
            canBuy = false
        } else {

            let timeModel = dishData.openTimeArr[dishData.curTimeIdx]
            if timeModel.nowType == "1" {
                //当前时间不在时间段内
                canBuy = false
            } else {
                if timeModel.deliverStatus == "2" && timeModel.collectStatus == "2" {
                    canBuy = false
                } else {
                    canBuy = true
                }
            }
        }
        
        if dishData.isChangeSelectTime {
            //滑动到最最顶部
            self.l_table.setContentOffset(.zero, animated: false)
            self.r_table.setContentOffset(.zero, animated: false)
            dishData.isChangeSelectTime = false
        }

        self.l_table.reloadData()
        self.r_table.reloadData()
        

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "topTable"), object: nil)
    }

    
}

extension MenuContentCell {
    
    
    //滑动处理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            //点击分类 菜品Table滑动到相应的分类下
            if dishData.classifyIdx != indexPath.row {
                dishData.classifyIdx = indexPath.row
                self.l_table.reloadData()
                

                
                //菜品Table滑动到相应的分类下 当分类下没有菜品时就无需跳转
                if dishData.pageDataArr[indexPath.row].dishArr.count != 0 {
                    //点击分类 发送通知主页面店铺信息置顶
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classify"), object: nil)
                    self.isSelect = true
                    canSroll = true
                    self.r_table.selectRow(at: IndexPath(row: 0, section: indexPath.row), animated: false, scrollPosition: .top)
                }
            }
        }
        
        if tableView.tag == 1 {
            //点击进入菜品详情页页面
            let model = dishData.pageDataArr[indexPath.section].dishArr[indexPath.row]
            
            if model.dishesType == "1" {
                //单品
                if model.isOn == "1" {
                    print("aaaaa")
                    let nextVC = SelectSizeController()
                    nextVC.dishesID = model.dishID
                    nextVC.canBuy = canBuy
                    nextVC.deskID = deskID
                    //如果不是规格规格商品 且已添加到购物车中 需将数量带到下一页面
                    if !model.isSelect && model.cart.count != 0 {
                        nextVC.cartID = model.cart[0].cartID
                        nextVC.dishCount = model.sel_Num
                    }
                                    
                    PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            if model.dishesType == "2" {
                //套餐
                let nextVC = MealSelectSizeController()
                nextVC.dishesID = model.dishID
                nextVC.canBuy = canBuy
                nextVC.deskID = deskID
                PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //MARK: - 联动
        ///菜品滑动  分类滑动到相对应的分类下
        if scrollView.tag == 1 && isSelect == false {
            
            //取出显示在 视图 且最靠上 的 cell 的 indexpath
            guard let topIndexPath = self.r_table.indexPathsForVisibleRows?.first else {
                return
            }
            // 左侧 talbelview 移动到的位置 indexpath
            let l_indexpath = IndexPath(row: topIndexPath.section, section: 0)
            dishData.classifyIdx = topIndexPath.section
            l_table.reloadData()
            // 移动 左侧 tableview 到 指定 indexpath 居中显示
            self.l_table.selectRow(at: l_indexpath, animated: true, scrollPosition: .middle)
        }
        
        //MARK: - 嵌套滑动
        
        if scrollView.tag == 1 {
            let y = scrollView.contentOffset.y

            print("---------------\(y)")

            if !canSroll {
                //保持不动
                scrollView.contentOffset = .zero
            }

            /**
             当contentOffset.y <= 0 即table滑动到顶部时
             table保持不动并向上层table发送通知
             让其可以开始滑动
             */

            if y <= 0 {
                self.canSroll = false
                scrollView.contentOffset = .zero
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "botTable"), object: nil)
            }
        }
        
    }
    
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("aaa")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == 1 {
            self.isSelect = false
        }
    }
    
    
}

extension MenuContentCell {
    //注册通知中心 等待上层table发来通知
    func addCenterNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(slideAction), name: NSNotification.Name(rawValue: "topTable"), object: nil)
        
    }
    
    //收到通知进行操作
    @objc func slideAction() {
        //上层tabel滑动到指定位置后发来通知，下层table可以开始滑动了
        self.canSroll = true
    }

}


