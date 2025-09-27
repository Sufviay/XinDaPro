//
//  MenuDishMoreAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/21.
//

import UIKit

class MoreAlert: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    enum MoreAlertType {
        case dish
        case combo
        case additional
        case gift
        case printer
        case table
        case openTime
        case holiday
        case onoff
        case customer
        case promotion
        case tag
    }
    
    
    
    ///选择回调
    var clickBlock: VoidStringBlock?
   
    ///提示框的类型
    var alertType: MoreAlertType = .dish
    ///设置的状态
    var statusType: String = ""
    
    
    private var celltitleArr: [String] = []
    
    ///点击位置高度
    var tap_H: CGFloat = 0

    private lazy var backView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.frame.size = CGSize(width: 150, height: 200)
        return view
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
        tableView.register(MoreAlertItemCell.self, forCellReuseIdentifier: "MoreAlertItemCell")
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
    
        self.addSubview(backView)
        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
    }
    
    
    @objc private func clickEditeAction() {
        self.clickBlock?("ed")
        self.disAppearAction()
    }
    
    
    @objc private func clickDeleteAction() {
        self.clickBlock?("de")
        self.disAppearAction()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func tapAction() {
        disAppearAction()
    }

    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        
    }
    
    func appearAction() {
        
        switch alertType {
        case .dish:
            celltitleArr = ["Detail".local, "Edit price".local, "Edit VIP".local, "Edit VAT".local, "Edit stock".local, "Edit discount".local, "Edit one free".local, "Edit special offer".local, "Delete".local]
        case .combo:
            celltitleArr = ["Detail".local, "Edit price".local, "Edit VIP".local, "Edit VAT".local, "Edit stock".local, "Edit discount".local, "Edit one free".local, "Delete".local]
        case .additional:
            
            var statusStr = ""
            if statusType == "1" {
                //启用
                statusStr = "Disable".local
            }
            if statusType == "2" {
                //禁用
                statusStr = "Enable".local
            }
            
            celltitleArr = ["Detail".local, statusStr, "Delete".local]
            
        case .gift:
            celltitleArr = ["Detail".local, "Delete".local]
            
        case .holiday:
            celltitleArr = ["Edit".local, "Delete".local]
            
        case .printer:
            var statusStr = ""
            if statusType == "1" {
                //启用
                statusStr = "Disable".local
            }
            if statusType == "2" {
                //禁用
                statusStr = "Enable".local
            }
            celltitleArr = [statusStr, "Edit".local, "Edit dishes".local, "Delete".local]
            
        case .table:
            var statusStr = ""
            if statusType == "1" {
                //启用
                statusStr = "Disable".local
            }
            if statusType == "2" {
                //禁用
                statusStr = "Enable".local
            }
            celltitleArr = [statusStr, "Edit".local, "Delete".local]
        case .openTime:
            var statusStr = ""
            if statusType == "1" {
                //启用
                statusStr = "Disable".local
            }
            if statusType == "2" {
                //禁用
                statusStr = "Enable".local
            }
            celltitleArr = ["Detail".local, "Edit".local, "Edit dishes".local, statusStr, "Delete".local]
        case .onoff:
            celltitleArr = ["In stock".local, "Sold out today".local, "Sold out indefinitely".local]
        case .customer:
            celltitleArr = ["Detail".local, "Edit tags".local, "Orders".local]
        case .promotion:
            celltitleArr = ["Detail".local, "Stop".local]
        case .tag:
            celltitleArr = ["Edit".local, "Delete".local]
        }

        
        table.reloadData()
        
        let h =  celltitleArr.count * 40 + 30
        if (tap_H + CGFloat(h) + 50) > S_H {
            //超出屏幕范围
            
            var img = LOIMG("dish_more_alert_x")
            img = img.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0), resizingMode: .stretch)
            backView.image = img

            backView.snp.remakeConstraints {
                $0.size.equalTo(CGSize(width: 150, height: h))
                $0.right.equalToSuperview().offset(-15)
                $0.top.equalToSuperview().offset(tap_H - CGFloat(h))
            }

        } else {
            //没有超出
            var img = LOIMG("dish_more_alert")
            img = img.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0), resizingMode: .stretch)
            backView.image = img
            
            backView.snp.remakeConstraints {
                $0.size.equalTo(CGSize(width: 150, height: h))
                $0.right.equalToSuperview().offset(-15)
                $0.top.equalToSuperview().offset(tap_H + 20)
            }
        }
    
        addWindow()
    }
    
    func disAppearAction() {
        self.removeFromSuperview()
    }
     
     
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if (touch.view?.isDescendant(of: self.backView))! {
             return false
         }
         return true
     }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celltitleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreAlertItemCell") as! MoreAlertItemCell
        cell.setCellData(titStr: celltitleArr[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let titStr = celltitleArr[indexPath.row]
        
        if titStr == "Delete".local {
            clickBlock?("delete")
        }
        if titStr == "Edit".local {
            clickBlock?("edit")
        }
        if titStr == "Disable".local || titStr == "Enable".local {
            clickBlock?("status")
        }
        if titStr == "Detail".local {
            clickBlock?("detail")
        }
        if titStr == "Edit price".local {
            clickBlock?("price")
        }
        if titStr == "Edit stock".local {
            clickBlock?("stock")
        }
        if titStr == "Edit discount".local {
            clickBlock?("discount")
        }
        if titStr == "Edit one free".local {
            clickBlock?("free")
        }
        if titStr == "Edit special offer".local {
            clickBlock?("special")
        }
        if titStr == "Edit dishes".local {
            clickBlock?("dish")
        }
        if titStr == "Edit VAT".local {
            clickBlock?("VAT")
        }
        if titStr == "Edit VIP".local {
            clickBlock?("VIP")
        }
        if titStr == "In stock".local {
            clickBlock?("on")
        }
        if titStr == "Sold out today".local {
            clickBlock?("off today")
        }
        if titStr == "Sold out indefinitely".local {
            clickBlock?("off inde")
        }
        if titStr == "Orders".local {
            clickBlock?("order")
        }
        if titStr == "Stop".local {
            clickBlock?("stop")
        }
        if titStr == "Edit tags".local {
            clickBlock?("tag")
        }
        disAppearAction()
    }
}



class MoreAlertItemCell: BaseTableViewCell  {
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_5, .left)
        lab.text = "Edit"
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
        }
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
    }
    
    
    func setCellData(titStr: String) {
        titLab.text = titStr
        if titStr == "Delete".local || titStr == "Stop".local {
            titLab.textColor = TXTCOLOR_4
            line.isHidden = true
        } else {
            titLab.textColor = TXTCOLOR_1
            line.isHidden = false
        }
    }
    
}




//class MenuDishMoreFourAlert: UIView, UIGestureRecognizerDelegate {
//    
//    var clickBlock: VoidStringBlock?
//    
//    ///点击位置高度
//    var tap_H: CGFloat = 0 {
//        didSet {
//            self.backView.snp.remakeConstraints {
//                $0.size.equalTo(CGSize(width: 150, height: 250))
//                $0.right.equalToSuperview().offset(-15)
//                $0.top.equalToSuperview().offset(tap_H + 20)
//            }
//        }
//    }
//        
//    private let backView: UIImageView = {
//        let view = UIImageView()
//        view.image = LOIMG("dish_more_alert")
//        view.isUserInteractionEnabled = true
//        //view.frame.size = CGSize(width: 150, height: 210)
//        return view
//    }()
//    
//    private let line1: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
//    
//    private let line2: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
//    
//    private let line3: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
//
//    private let line4: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
//
//    private let line5: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
//
//    
//    private let line6: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
//
//    
//    
//    private let editeBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        return but
//    }()
//    
//    private let deleteBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        return but
//    }()
//    
//    private let kucunBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        return but
//    }()
//    
//    private let discountBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        return but
//    }()
//    
//    private let priceBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        return but
//    }()
//    
//    private let giveOneBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        return but
//    }()
//    
//    private let baleTypeBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        return but
//    }()
//
//    
//    private let editeLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
//        lab.text = "Detail"
//        return lab
//    }()
//    
//    private let kucunLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
//        lab.text = "Edit stock"
//        return lab
//    }()
//    
//    private let discountLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
//        lab.text = "Edit discount"
//        return lab
//    }()
//
//    private let priceLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
//        lab.text = "Edit price"
//        return lab
//    }()
//    
//    
//    private let giveLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
//        lab.text = "Edit one free"
//        return lab
//    }()
//    
//    private let baleTypeLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
//        lab.text = "Edit special offer"
//        return lab
//    }()
//
//
//    
//    private let deleteLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#F75E5E"), BFONT(11), .left)
//        lab.text = "Delete"
//        return lab
//    }()
//
//    
//
//
//    
//
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        self.backgroundColor = .clear
//        self.frame = S_BS
//        self.isUserInteractionEnabled = true
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
//        tap.delegate = self
//        self.addGestureRecognizer(tap)
//        
//        self.addSubview(backView)
//
//        
//        backView.addSubview(line1)
//        line1.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(-20)
//            $0.top.equalToSuperview().offset(60)
//            $0.height.equalTo(0.5)
//        }
//        
//        backView.addSubview(line2)
//        line2.snp.makeConstraints {
//            $0.left.right.height.equalTo(line1)
//            $0.top.equalTo(line1.snp.bottom).offset(30)
//        }
//        
//        backView.addSubview(line3)
//        line3.snp.makeConstraints {
//            $0.left.right.height.equalTo(line1)
//            $0.top.equalTo(line2.snp.bottom).offset(30)
//        }
//        
//        backView.addSubview(line4)
//        line4.snp.makeConstraints {
//            $0.left.right.height.equalTo(line1)
//            $0.top.equalTo(line3.snp.bottom).offset(30)
//        }
//        
//        backView.addSubview(line5)
//        line5.snp.makeConstraints {
//            $0.left.right.height.equalTo(line1)
//            $0.top.equalTo(line4.snp.bottom).offset(30)
//        }
//        
//        backView.addSubview(line6)
//        line6.snp.makeConstraints {
//            $0.left.right.height.equalTo(line1)
//            $0.top.equalTo(line5.snp.bottom).offset(30)
//        }
//
//        
//
//        backView.addSubview(editeBut)
//        editeBut.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.bottom.equalTo(line1.snp.top)
//            $0.height.equalTo(30)
//        }
//        
//        backView.addSubview(priceBut)
//        priceBut.snp.makeConstraints {
//            $0.left.right.equalTo(editeBut)
//            $0.top.equalTo(line1.snp.bottom)
//            $0.bottom.equalTo(line2.snp.top)
//
//        }
//        
//        backView.addSubview(kucunBut)
//        kucunBut.snp.makeConstraints {
//            $0.left.right.equalTo(editeBut)
//            $0.top.equalTo(line2.snp.bottom)
//            $0.bottom.equalTo(line3.snp.top)
//        }
//        
//        backView.addSubview(discountBut)
//        discountBut.snp.makeConstraints {
//            $0.left.right.equalTo(editeBut)
//            $0.top.equalTo(line3.snp.bottom)
//            $0.bottom.equalTo(line4.snp.top)
//        }
//        
//        
//        backView.addSubview(giveOneBut)
//        giveOneBut.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalTo(line4.snp.bottom)
//            $0.height.equalTo(30)
//        }
//        
//        backView.addSubview(baleTypeBut)
//        baleTypeBut.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalTo(line5.snp.bottom)
//            $0.height.equalTo(30)
//        }
//
//
//
//        backView.addSubview(deleteBut)
//        deleteBut.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalTo(line6.snp.bottom)
//            $0.height.equalTo(30)
//        }
//
//        editeBut.addSubview(editeLab)
//        editeLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.centerY.equalToSuperview()
//        }
//        
//        priceBut.addSubview(priceLab)
//        priceLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.centerY.equalToSuperview()
//        }
//
//
//        kucunBut.addSubview(kucunLab)
//        kucunLab.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.left.equalToSuperview().offset(10)
//        }
//
//        deleteBut.addSubview(deleteLab)
//        deleteLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.centerY.equalToSuperview().offset(-2)
//        }
//        
//        discountBut.addSubview(discountLab)
//        discountLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.centerY.equalToSuperview()
//        }
//        
//        giveOneBut.addSubview(giveLab)
//        giveLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.centerY.equalToSuperview().offset(-2)
//        }
//
//        
//        baleTypeBut.addSubview(baleTypeLab)
//        baleTypeLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.centerY.equalToSuperview().offset(-2)
//        }
//
//
//
//        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
//        editeBut.addTarget(self, action: #selector(clickEditeAction), for: .touchUpInside)
//        kucunBut.addTarget(self, action: #selector(clickKuCunAction), for: .touchUpInside)
//        discountBut.addTarget(self, action: #selector(clickDiscountAction), for: .touchUpInside)
//        priceBut.addTarget(self, action: #selector(clickPriceAction), for: .touchUpInside)
//        giveOneBut.addTarget(self, action: #selector(clickGiveOneAction), for: .touchUpInside)
//        baleTypeBut.addTarget(self, action: #selector(clickBaletypeAction), for: .touchUpInside)
//    }
//    
//    
//    @objc private func clickEditeAction() {
//        self.clickBlock?("ed")
//        self.disAppearAction()
//    }
//    
//    @objc private func clickPriceAction() {
//        self.clickBlock?("pr")
//        self.disAppearAction()
//    }
//
//    
//    @objc private func clickDeleteAction() {
//        self.clickBlock?("de")
//        self.disAppearAction()
//    }
//    
//    @objc private func clickKuCunAction() {
//        self.clickBlock?("kc")
//        self.disAppearAction()
//    }
//    
//    
//    @objc private func clickGiveOneAction() {
//        self.clickBlock?("give")
//        self.disAppearAction()
//    }
//
//    @objc private func clickDiscountAction() {
//        self.clickBlock?("yh")
//        self.disAppearAction()
//    }
//
//    
//    @objc private func clickBaletypeAction() {
//        self.clickBlock?("bale")
//        self.disAppearAction()
//    }
//
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    @objc private func tapAction() {
//        disAppearAction()
//    }
//
//    
//    
//    private func addWindow() {
//        PJCUtil.getWindowView().addSubview(self)
//        
//    }
//    
//    func appearAction() {
//        addWindow()
//    }
//    
//    func disAppearAction() {
//        self.removeFromSuperview()
//    }
//     
//     
//     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//         if (touch.view?.isDescendant(of: self.backView))! {
//             return false
//         }
//         return true
//     }
//     
//    
//}
//
//
//
//
//
//import UIKit
//
//class MenuDishMoreTwoAlert: UIView, UIGestureRecognizerDelegate {
//    
//    var clickBlock: VoidStringBlock?
//    
//    
//    var alertSize = CGSize.zero
//    
//    ///点击位置高度
//    var tap_H: CGFloat = 0 {
//        didSet {
//            self.backView.snp.remakeConstraints {
//                $0.size.equalTo(CGSize(width: 170, height: 400))
//                $0.right.equalToSuperview().offset(-15)
//                $0.top.equalToSuperview().offset(tap_H + 20)
//            }
//        }
//    }
//        
//    private lazy var backView: UIImageView = {
//        let view = UIImageView()
//        view.clipsToBounds = true
//        var img = LOIMG("dish_more_alert")
//        img = img.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0), resizingMode: .stretch)
//        view.image = img
//        view.isUserInteractionEnabled = true
//        view.frame.size = CGSize(width: 170, height: 400)
//        return view
//    }()
//    
//    private let line: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#EEEEEE")
//        return view
//    }()
//    
//    
//    
//    private let editeBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        return but
//    }()
//    
//    private let deleteBut: UIButton = {
//        let but = UIButton()
//        but.backgroundColor = .clear
//        return but
//    }()
//    
//    private let editeLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .left)
//        lab.text = "Detail"
//        return lab
//    }()
//    
//    
//    
//    private let deleteLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#F75E5E"), BFONT(11), .left)
//        lab.text = "Delete"
//        return lab
//    }()
//
//    
//    
//
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        self.backgroundColor = .clear
//        self.frame = S_BS
//        self.isUserInteractionEnabled = true
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
//        tap.delegate = self
//        self.addGestureRecognizer(tap)
//        
//    
//        self.addSubview(backView)
//        
//        
//        backView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(-20)
//            $0.top.equalToSuperview().offset(42)
//            $0.height.equalTo(0.5)
//        }
//        
//
//        backView.addSubview(editeBut)
//        editeBut.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.bottom.equalTo(line.snp.top)
//            $0.height.equalTo(30)
//        }
//        
//
//        
//
//        backView.addSubview(deleteBut)
//        deleteBut.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//            $0.top.equalTo(line.snp.bottom)
//            $0.height.equalTo(30)
//        }
//
//        editeBut.addSubview(editeLab)
//        editeLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.centerY.equalToSuperview().offset(2)
//        }
//
//        deleteBut.addSubview(deleteLab)
//        deleteLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(10)
//            $0.centerY.equalToSuperview().offset(-2)
//        }
//
//        deleteBut.addTarget(self, action: #selector(clickDeleteAction), for: .touchUpInside)
//        editeBut.addTarget(self, action: #selector(clickEditeAction), for: .touchUpInside)
//    }
//    
//    
//    @objc private func clickEditeAction() {
//        self.clickBlock?("ed")
//        self.disAppearAction()
//    }
//    
//    
//    @objc private func clickDeleteAction() {
//        self.clickBlock?("de")
//        self.disAppearAction()
//    }
//    
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    @objc private func tapAction() {
//        disAppearAction()
//    }
//
//    
//    
//    private func addWindow() {
//        PJCUtil.getWindowView().addSubview(self)
//        
//    }
//    
//    func appearAction() {
//        addWindow()
//    }
//    
//    func disAppearAction() {
//        self.removeFromSuperview()
//    }
//     
//     
//     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//         if (touch.view?.isDescendant(of: self.backView))! {
//             return false
//         }
//         return true
//     }
//     
//    
//}
//
