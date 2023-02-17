//
//  MenuContentCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/2.
//

import UIKit

class MenuContentCell: BaseTableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    var isSelect: Bool = false
    
    ///弹出购物车
    var showCartBlock: VoidBlock?

    ///更新购物车
    var updateCartBlock: VoidBlock?
    
    ///添加购物车（0 ->1 ）
    var addCartBlock: VoidBlock?
    
    
    ///晚餐数据
    private var dinner_Data: [ClassiftyModel] = []
    ///午餐数据
    private var lunch_Data: [DishModel] = []
    
    ///当前店铺卖的午餐还是晚餐 2午餐 3 晚餐
    private var storeLunchOrDinner: String = ""
    
    
    ///当前选中的分类下标
    private var curSel_Idx: Int = 0
    
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
        
        tableView.register(Big_MenuGoodsNoSizeCell.self, forCellReuseIdentifier: "Big_MenuGoodsNoSizeCell")
        tableView.register(Big_MenuGoodsSizeCell.self, forCellReuseIdentifier: "Big_MenuGoodsSizeCell")

        return tableView
    }()

    
    lazy var mealTable: GestureTableView = {
        let tableView = GestureTableView()
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
        tableView.tag = 2
        tableView.bounces = false
        
        tableView.register(MenuMealGoodsCell.self, forCellReuseIdentifier: "MenuMealGoodsCell")
        
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
        
        contentView.addSubview(mealTable)
        mealTable.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0 {
            return 1
        }
        else if tableView.tag == 1 {
            return dinner_Data.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return dinner_Data.count
        } else if tableView.tag == 1 {
            return dinner_Data[section].dishArr.count
        } else {
            return lunch_Data.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            let h = dinner_Data[indexPath.row].flName_C.getTextHeigh(BFONT(13), 70) + 35
            return h > 50 ? h : 50
        } else if tableView.tag == 1 {
            let model = dinner_Data[indexPath.section].dishArr[indexPath.row]
            return model.dish_H
        } else {
            return lunch_Data[indexPath.row].dish_H
        }
    }
    
    ///头部Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 1 {
            let h = dinner_Data[section].flName_C.getTextHeigh(BFONT(15), S_W - 90 - 40)
            return h + 10
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if tableView.tag == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClassifySectionHeader") as! ClassifySectionHeader
            header.titLab.text = dinner_Data[section].flName_C

            return header
        }
        return nil
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTypeCell") as! MenuTypeCell
            let isSelect: Bool = indexPath.row == curSel_Idx ? true : false
            cell.setCellData(isSelect: isSelect, name: dinner_Data[indexPath.row].flName_E)
            
            return cell
        }
        
        if tableView.tag == 1 {
            
            let model = dinner_Data[indexPath.section].dishArr[indexPath.row]
            
            if model.isSelect {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuGoodsSizeCell") as! MenuGoodsSizeCell
                cell.setCellData(model: model, type: storeLunchOrDinner)
            
            
                cell.optionBlock = { (_) in
                    ///进入选择规格页面
                    let nextVC = SelectSizeController()
                    nextVC.dishesID = model.dishID
                    PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
                }
                
                cell.jiaBlock = { (par) in
                    ///添加购物车
                    let count = par as! Int
                    var dic: [String: Any] = [:]
                    //添加购物车
                    dic = ["num": count, "id": model.dishID]
                    self.addCartBlock?(dic)
                        

                }
                cell.jianBlock = { [unowned self] (_) in
                    ///弹出购物车
                    self.showCartBlock?("")
                }
    
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuGoodsNoSizeCell") as! MenuGoodsNoSizeCell
                cell.setCellData(model: model, type: storeLunchOrDinner)
                
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
            }
        }
        
        if tableView.tag == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuMealGoodsCell") as! MenuMealGoodsCell
            cell.setCellData(model: lunch_Data[indexPath.row])
            
            
            cell.optionBlock = { [unowned self] (_) in
                ///进入选择套餐规格页面
                let nextVC = MealSelectSizeController()
                nextVC.dishesID = self.lunch_Data[indexPath.row].dishID
                PJCUtil.currentVC()?.navigationController?.pushViewController(nextVC, animated: true)
            }
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    

    
    func setCellData(model: MenuModel, curSelectedlunchOrDinner: String, storeLunchOrDinner: String) {
        self.dinner_Data = model.dinnerDataArr
        self.lunch_Data = model.lunchDataArr
        self.storeLunchOrDinner = storeLunchOrDinner
        self.l_table.reloadData()
        self.r_table.reloadData()
        self.mealTable.reloadData()
        
        if curSelectedlunchOrDinner == "lunch" {
            self.l_table.isHidden = true
            self.r_table.isHidden = true
            self.mealTable.isHidden = false
        } else {
            self.l_table.isHidden = false
            self.r_table.isHidden = false
            self.mealTable.isHidden = true
        }
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
            if curSel_Idx != indexPath.row {
                curSel_Idx = indexPath.row
                self.l_table.reloadData()
                

                
                //菜品Table滑动到相应的分类下 当分类下没有菜品时就无需跳转
                if dinner_Data[indexPath.row].dishArr.count != 0 {
                    //点击分类 发送通知主页面店铺信息置顶
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classify"), object: nil)
                    self.isSelect = true
                    self.r_table.selectRow(at: IndexPath(row: 0, section: indexPath.row), animated: false, scrollPosition: .top)
                }
            }
        }
        
        if tableView.tag == 1 {
            //点击进入菜品详情页页面
            let model = dinner_Data[indexPath.section].dishArr[indexPath.row]
            if model.isOn == "1" {
                print("aaaaa")
                let nextVC = SelectSizeController()
                nextVC.dishesID = model.dishID
                
                //如果不是规格规格商品 且已添加到购物车中 需将数量带到下一页面
                if !model.isSelect && model.cart.count != 0 {
                    nextVC.cartID = model.cart[0].cartID
                    nextVC.dishCount = model.sel_Num
                }
                                
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
            self.curSel_Idx = topIndexPath.section
            l_table.reloadData()
            // 移动 左侧 tableview 到 指定 indexpath 居中显示
            self.l_table.selectRow(at: l_indexpath, animated: true, scrollPosition: .middle)
            //self.l_table.scrollToRow(at: l_indexpath, at: .middle, animated: true)

        }
        
        //MARK: - 嵌套滑动
        
        if scrollView.tag == 1 || scrollView.tag == 2 {
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


