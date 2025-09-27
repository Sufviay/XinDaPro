//
//  RestaurantSettingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/8.
//

import UIKit

class RestaurantSettingController: HeadBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private var imgStrArr: [String] = ["set_menu", "set_item", "set_area", "set_deFee", "set_time", "set_holiday", "set_set", "set_pay", "set_printer", "set_table"]
    private var nameStrArr: [String] = ["Menu".local, "ltem availability".local, "Delivery area".local, "Delivery charges".local, "Opening hours".local, "Holiday".local, "Restaurant details settings".local, "Payment method".local, "Printer".local, "Dine-in table management".local]
    private var desStrArr: [String] = ["View and edit your menu".local,
                                       "Take items off menu temporarily if they go out of stock".local,
                                       "Manage the area you delivery to".local,
                                       "Manage how much you charge for delivery".local,
                                       "Set the days and times you want to take orders".local,
                                       "Set holiday times".local,
                                       "Make changes to your restaurant details and fees".local,
                                       "Change user app payment method setting".local,
                                       "Printer setting".local,
                                       "Manage your table".local]
    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: 65), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
//    private let line: UIImageView = {
//        let img = UIImageView()
//        img.image = GRADIENTCOLOR(HCOLOR("#FFC65E"), HCOLOR("#FF8E12"), CGSize(width: 70, height: 3))
//        img.clipsToBounds = true
//        img.layer.cornerRadius = 1
//        return img
//    }()
//    
//    
//    private let titleLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#333333"), BFONT(20), .left)
//        lab.text = "Restaurant settings"
//        return lab
//    }()
    
    
    
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
        
//        backView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(-10)
//            $0.size.equalTo(CGSize(width: 70, height: 3))
//            $0.left.equalToSuperview().offset(20)
//        }
//        
//        backView.addSubview(titleLab)
//        titleLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.bottom.equalTo(line.snp.top).offset(-3)
//        }
        
        
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backView).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
        
    }
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Restaurant settings".local
    }
    
    
    @objc func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return imgStrArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let h = desStrArr[indexPath.section].getTextHeigh(TXT_2, S_W - 140) + 50
        
        return h
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSettingItemCell") as! RestaurantSettingItemCell
        cell.setCellData(imgStr: imgStrArr[indexPath.section], nameStr: nameStrArr[indexPath.section], desStr: desStrArr[indexPath.section])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let nextVC = MenuListController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 1 {
            let nextVC = DishesItemOnOffController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 3 {
            
            let nextVC = ChangeDistanceController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 4 {
            let nextVC = StoreTimeSettingController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 5 {
            //假日设置
            let nextVC = HolidaySettingController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 6 {
            //餐廳詳情設置
            let nextVC = StoreDetailSettingController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 7 {
            //支付方式
            let nextVC = PaymentMethodController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 8 {
            //打印機
            let nextVC = PrinterSettingController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
        if indexPath.section == 9 {
            //餐桌設置
            let nextVC = DeskSettingController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }

}


class RestaurantSettingItemCell: BaseTableViewCell {


    private let sImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        return lab
    }()
    
    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_2, TXT_2, .left)
        lab.numberOfLines = 0
        return lab
    }()
    
    private let nextImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("set_next")
        return img
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    override func setViews() {
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(70)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(70)
            $0.top.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-70)
        }
        
        
        contentView.addSubview(nextImg)
        nextImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
        
        
        
    }
    
    
    func setCellData(imgStr: String, nameStr: String, desStr: String) {
        self.nameLab.text = nameStr
        self.desLab.text = desStr
        self.sImg.image = LOIMG(imgStr)
    }
    
    
}

