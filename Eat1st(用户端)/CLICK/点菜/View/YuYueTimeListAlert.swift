//
//  YuYueTimeListAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2022/7/8.
//


import UIKit
import RxSwift
import SwiftyJSON

class YuYueTimeModel: NSObject {
    
    var date: String = ""
    var timeList: [String] = []
    
    func updateModel(json: JSON) {
        self.date = json["deliveryDate"].stringValue
        
        var t_arr: [String] = []
        for jsonData in json["timeList"].arrayValue {
            let time = jsonData["deliveryTime"].stringValue
            t_arr.append(time)
        }
        self.timeList = t_arr
    }
    
}


class YuYueTimeListAlert: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var storeID: String = ""
    //1 外卖 2 自取
    var type: String = ""
    
    var clickTimeBlock: VoidBlock?
    
    private let bag = DisposeBag()
    
    private var H: CGFloat = bottomBarH + 340
    
    private var dateArr: [YuYueTimeModel] = []
    
    private var c_dateIdx = 0
    private var c_timeIdx = 10000


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 340), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("cart_cancel"), for: .normal)
        return but
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .center)
        lab.text = "Select the estimated time of delivery"
        return lab
    }()

    
    private lazy var date_Table: GestureTableView = {
        let tableView = GestureTableView()
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
        tableView.bounces = false
        tableView.tag = 0
        tableView.register(DateCell.self, forCellReuseIdentifier: "DateCell")
        return tableView
    }()
    
    private lazy var time_Table: GestureTableView = {
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
        tableView.bounces = false
        tableView.tag = 1
        tableView.register(TimeCell.self, forCellReuseIdentifier: "TimeCell")
        return tableView
    }()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = S_BS
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)

        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(H)
            $0.height.equalTo(H)
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(titLab)
        }
        
        backView.addSubview(date_Table)
        date_Table.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-bottomBarH)
            $0.top.equalToSuperview().offset(60)
            $0.width.equalTo(110)
        }
    
        backView.addSubview(time_Table)
        time_Table.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.left.equalTo(date_Table.snp.right)
            $0.bottom.top.equalTo(date_Table)
            
        }
        
        
        closeBut.addTarget(self, action: #selector(tapAction), for: .touchUpInside)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func tapAction() {
        disAppearAction()
    }

    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
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
    
    func appearAction() {
        addWindow()
        c_dateIdx = 0
        c_timeIdx = 10000
        date_Table.reloadData()
        time_Table.reloadData()
        loadData_Net()
    }
    
    func disAppearAction() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.snp.remakeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview().offset(self.H)
                $0.height.equalTo(self.H)
            }
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }


}


extension YuYueTimeListAlert {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if tableView.tag == 0 {
            return dateArr.count
        }
        
        if dateArr.count == 0 {
            return 0
        }
        return dateArr[c_dateIdx].timeList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return 45
        }
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
            let isSel = c_dateIdx == indexPath.row ? true : false
            cell.setCellData(isSelect: isSel, msg: dateArr[indexPath.row].date)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimeCell
        let isSel = c_timeIdx == indexPath.row ? true : false
        cell.setCellData(isSelect: isSel, msg: dateArr[c_dateIdx].timeList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            if c_dateIdx != indexPath.row {
                c_dateIdx = indexPath.row
                self.date_Table.reloadData()
                self.time_Table.reloadData()
            }
        } else {
            self.c_timeIdx = indexPath.row
            self.time_Table.reloadData()
            self.clickTimeBlock?("\(dateArr[c_dateIdx].date) \(dateArr[c_dateIdx].timeList[c_timeIdx])")
            self.disAppearAction()
        }
        
    }
    
}

extension YuYueTimeListAlert {
    
    //请求时间列表
    private func loadData_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.getChooseTimeList_YD(storeID: storeID, type: type).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.backView)
            
            var tArr: [YuYueTimeModel] = []
            for jsonData in json["data"].arrayValue {
                let model = YuYueTimeModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            
            self.dateArr = tArr
            self.date_Table.reloadData()
            self.time_Table.reloadData()
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
        }).disposed(by: self.bag)
        
    }
    
}


class DateCell: BaseTableViewCell {
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        return lab
    }()

    
    override func setViews() {
        
        contentView.backgroundColor = HCOLOR("#F9F9F9")
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
    }
    
    func setCellData(isSelect: Bool, msg: String) {
        self.titLab.text = msg
        if isSelect {
            self.contentView.backgroundColor = .white
        } else {
            self.contentView.backgroundColor = HCOLOR("F9F9F9")
        }
    }
    
}

class TimeCell: BaseTableViewCell {
    
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(15), .left)
        return lab
    }()

    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("time_sel")
        return img
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    
    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(35)
        }
        
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
    }
    
    func setCellData(isSelect: Bool, msg: String) {
        self.titLab.text = msg
        self.selectImg.isHidden = !isSelect
        if isSelect {
            self.titLab.textColor = MAINCOLOR
        } else {
            self.titLab.textColor = FONTCOLOR
        }
    }
    
}
