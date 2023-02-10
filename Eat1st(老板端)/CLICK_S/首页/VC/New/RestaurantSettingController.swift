//
//  RestaurantSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/8.
//

import UIKit

class RestaurantSettingController: HeadBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private var imgStrArr: [String] = ["set_menu", "set_item", "set_area", "set_deFee", "set_time", "set_set", "set_pay"]
    private var nameStrArr: [String] = ["Menu", "ltem availability", "Delivery area", "Delivery charges", "Opening hours", "Restaurant details", "Payment Method"]
    private var desStrArr: [String] = ["View and edit your menu",
                                       "Take items off menu temporarily if they go out of stock",
                                       "Manage the area you deliver to",
                                       "Manage how much you charge for delivery",
                                       "Set the days and times you want to take orders",
                                       "Make changes to your menu, restaurant details and bag fees",
                                       "Change user app payment method setting"]
    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: 65), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private let titleLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(20), .left)
        lab.text = "Restaurant settings"
        return lab
    }()
    
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
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
        tableView.register(RestaurantSettingItemCell.self, forCellReuseIdentifier: "RestaurantSettingItemCell")

        return tableView
    }()

    
    
    override func setViews() {
        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(65)
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
        }
        
        backView.addSubview(titleLab)
        titleLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalTo(line.snp.top).offset(-3)
        }
        
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
        
    }
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Eat1st\nPartner Center"
    }
    
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return imgStrArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 || section == 1 || section == 3 || section == 4 || section == 6 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSettingItemCell") as! RestaurantSettingItemCell
        cell.setCellData(imgStr: imgStrArr[indexPath.section], nameStr: nameStrArr[indexPath.section], desStr: desStrArr[indexPath.section])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let nextVC = MenuListController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 1 {
            let nextVC = DishesItemOnOffController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 3 {
            
            //let nextVC = DeliveryAreaController()
            let nextVC = ChangeDistanceController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 4 {
            let nextVC = StoreTimeSettingController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 6 {
            let nextVC = PaymentMethodController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

}
