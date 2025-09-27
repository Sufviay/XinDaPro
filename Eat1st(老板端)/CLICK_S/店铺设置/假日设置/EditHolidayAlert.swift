//
//  EidtHolidayAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/6/26.
//

import UIKit
import RxSwift

class EditHolidayAlert: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let bag = DisposeBag()
    
    private var dataModel = HolidayModel()
    
    var savedBlock: VoidBlock?

    private var H: CGFloat = S_H - 300

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - 300), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()
    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()

    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_4, .left)
        lab.text = "Holiday".local
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        //tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(DishEditeInPutCell.self, forCellReuseIdentifier: "DishEditeInPutCell")
        tableView.register(EditSelectDateCell.self, forCellReuseIdentifier: "EditSelectDateCell")
        tableView.register(OpeningHoursInputCell.self, forCellReuseIdentifier: "OpeningHoursInputCell")
        tableView.register(DishEditeTextViewCell.self, forCellReuseIdentifier: "DishEditeTextViewCell")
        tableView.register(DishEditeChooseCell.self, forCellReuseIdentifier: "DishEditeChooseCell")
        return tableView
    }()


    
    private lazy var calendarView: CalendarAlert = {
        let view = CalendarAlert()
        
        view.clickDateBlock = { [unowned self] (par) in
            dataModel.date = par.getString("yyyy-MM-dd")
            table.reloadData()
        }
        
        return view
    }()


    ///选择时间
    private lazy var selectTimeAlert: TimeSelectView = {
        let view = TimeSelectView()
        
        view.clickBlock = { [unowned self] (par) in
            
            let typeStr = (par as! [Any])[0] as! String
            let time = (par as! [Any])[1] as! String

            if typeStr == "start" {
                dataModel.startTime = time
            }
            if typeStr == "end" {
                dataModel.endTime = time
            }
            self.table.reloadData()
        }
        return view
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
        
        
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 15)
            $0.height.equalTo(50)
        }
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titlab.snp.bottom).offset(7)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(line.snp.bottom).offset(10)
            $0.bottom.equalTo(saveBut.snp.top).offset(-15)
        }
        
        
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc private func clickCloseAction() {
        self.disAppearAction()
     }
        
    @objc private func clickSaveAction() {

        if dataModel.holidayId == "" {
            add_Net()
        } else {
            edite_Net()
        }
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
    }
    
    func disAppearAction() {
               
        UIApplication.shared.keyWindow?.endEditing(true)
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
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 {
            return 80
        }
        if indexPath.section == 2 || indexPath.section == 4 {
            return 90
        }
        if indexPath.section == 3 {
            return 115
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeInPutCell") as! DishEditeInPutCell
            cell.setCellData(titStr: "Holiday name".local, msgStr: dataModel.holiday)
            
            cell.editeEndBlock = { [unowned self] (text) in
                dataModel.holiday = text
            }
            
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = table.dequeueReusableCell(withIdentifier: "EditSelectDateCell") as! EditSelectDateCell
            cell.setCellData(date: dataModel.date)
            
            cell.clickBlock = { [unowned self] (_) in
                //弹出日期选择
                calendarView.appearAction()
            }
            
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpeningHoursInputCell") as! OpeningHoursInputCell
            cell.setCellData(titStr: "Time".local, star: dataModel.startTime, end: dataModel.endTime)
            
            cell.clickBlock = { [unowned self] (type) in
                selectTimeAlert.type = type
                selectTimeAlert.appearAction()
            }
            
            return cell

        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeTextViewCell") as! DishEditeTextViewCell
            cell.setCellData(titStr: "Remark".local, msgStr: dataModel.remark, isMust: false)
            cell.editeEndBlock = { [unowned self] (text) in
                dataModel.remark = text
            }
            return cell
        }
        
        
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            cell.setChooseCellData(titStr: "Status".local, l_str: "Enable".local, r_Str: "Disable".local, statusID: dataModel.status)
            
            cell.selectBlock = { [unowned self] (type) in
                dataModel.status = type
                tableView.reloadData()
            }
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    

    
    
    func setData(model: HolidayModel) {
        dataModel = model
        table.reloadData()
    }

    
    //MARK: - 网络请求
    private func add_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.addHoliday(model: dataModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            savedBlock?("")
            disAppearAction()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    
    
    private func edite_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.editHoliday(model: dataModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            savedBlock?("")
            disAppearAction()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    


    
}
