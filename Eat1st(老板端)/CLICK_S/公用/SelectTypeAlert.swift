//
//  SelectTypeAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/25.
//

import UIKit
import RxSwift



class TypeModel: NSObject {
    
    var id: String = ""
    var name: String = ""
    
    
    
    override init() {}
    
    
     init(id: String, name: String) {
        self.id = id
        self.name = name
    }
        
}



class SelectTypeAlert: BaseAlertView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    enum AlertType {
        case customerTag
        case platformType
        case logType
        case mealTime
    }
    
    var alertType: AlertType = .customerTag
    
    private let bag = DisposeBag()

    private var typeArr: [TypeModel] = []
    
    var selectBlock: VoidBlock?
    
    private var selectIdx: Int = 0
        
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = true
        tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
        return tableView
    }()

    
    override func setViews() {
        
        
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 200, height: 360))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(alertType)
        
        if alertType == .customerTag {
            loadData_Net()
        }
        
        if alertType == .platformType {
            let model1 = TypeModel(id: "", name: "All".local)
            let model3 = TypeModel(id: "0", name: "Eat1st")
            let model4 = TypeModel(id: "1", name: "Deliveroo")
            let model5 = TypeModel(id: "2", name: "Uber Eats")
    
            typeArr = [model1, model3, model4, model5]
            table.reloadData()
        }
        
        if alertType == .logType {
            let model1 = TypeModel(id: "", name: "All".local)
            let model2 = TypeModel(id: "1", name: "Rejected order".local)
            let model3 = TypeModel(id: "2", name: "Cancelled order".local)
            let model4 = TypeModel(id: "3", name: "Changed order".local)
            let model5 = TypeModel(id: "4", name: "Discounted order".local)
            let model6 = TypeModel(id: "5", name: "Changed payment method".local)
            let model7 = TypeModel(id: "6", name: "Credit".local)
            let model8 = TypeModel(id: "7", name: "Delete credit".local)
            let model9 = TypeModel(id: "8", name: "Print summary".local)
            let model10 = TypeModel(id: "9", name: "Delete dishes".local)
            let model11 = TypeModel(id: "10", name: "Top up".local)
            let model12 = TypeModel(id: "11", name: "Wallet spent".local)
            let model13 = TypeModel(id: "12", name: "change service charge".local)
            let model14 = TypeModel(id: "13", name: "Gift voucher".local)
            
            typeArr = [model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12, model13, model14]
            table.reloadData()

        }
        
        if alertType == .mealTime {
            let model1 = TypeModel(id: "", name: "All".local)
            let model2 = TypeModel(id: "1", name: "Breakfast".local + "\n(9:00 - 11:59)")
            let model3 = TypeModel(id: "2", name: "Lunch".local + "\n(12:00 - 16:30)")
            let model4 = TypeModel(id: "3", name: "Dinner".local + "\n(17:30 - 22:00)")
            typeArr = [model1, model2, model3, model4]
            table.reloadData()
        }
        
        
    }
    
    override func appearAction() {
        super.appearAction()
    }
    
    
    @objc func tapAction() {
        disAppearAction()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let h = typeArr[indexPath.row].name.getTextHeigh(TIT_3, 130)
        let cell_h = (h + 25) > 50 ? (h + 25) : 50
        return cell_h
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
        if alertType == .mealTime {
            cell.tlab.textAlignment = .center
        } else {
            cell.tlab.textAlignment = .left
        }
        
        let isSelect = indexPath.row == selectIdx ? true : false
        cell.setCellData(str: typeArr[indexPath.row].name, isSelect: isSelect)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIdx = indexPath.row
        tableView.reloadData()
        selectBlock?(typeArr[indexPath.row])
        disAppearAction()
    }

    
    private func loadData_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.getCustomerTagList().subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            
            let model = TypeModel()
//            model.id = ""
//            if MyLanguageManager.shared.language == .Chinese {
//                model.name = "全部"
//            } else {
//                model.name = "All"
//            }
            model.name = "All".local
            
            var tarr: [TypeModel] = [model]
            for jsonData in json["data"].arrayValue {
                let model = TypeModel()
                model.id = jsonData["tagId"].stringValue
                if MyLanguageManager.shared.language == .Chinese {
                    model.name = jsonData["nameHk"].stringValue
                } else {
                    model.name = jsonData["nameEn"].stringValue
                }
                tarr.append(model)
            }
            typeArr = tarr
            table.reloadData()
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    
    
    
    
}


class TextCell: BaseTableViewCell {

    let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_3, .center)
        lab.numberOfLines = 0
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        
    }
    
    func setCellData(str: String, isSelect: Bool)  {
        self.tlab.text = str
        if isSelect {
            self.tlab.textColor = MAINCOLOR
            
        } else {
            self.tlab.textColor = TXTCOLOR_1
        }
    }
    
}
