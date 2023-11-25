//
//  AreaAlert.swift
//  CLICK
//
//  Created by 肖扬 on 2023/10/25.
//

import UIKit
import RxSwift
import SwiftyJSON

class CountryModel: NSObject {
    
    ///手机国际区号
    var areaCode: String = ""
    ///国家代码
    var countryCode: String = ""
    ///国家繁体名字
    var nameHk: String = ""
    ///英文名字
    var nameEn: String = ""
    
    var name: String = ""
    
    
    func updateModel(json: JSON) {
        areaCode = json["areaCode"].stringValue
        countryCode = json["countryCode"].stringValue
        nameEn = json["nameEn"].stringValue
        nameHk = json["nameHk"].stringValue
        
        
        
        let curL = PJCUtil.getCurrentLanguage()
        if curL == "en_GB" {
            name = nameEn
        } else {
            name = nameHk
        }
        
    }
    
    
    
}



class AreaAlert: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    private let bag = DisposeBag()
    
    var dataArr: [CountryModel] = [] {
        didSet {
            table.reloadData()
        }
    }
    
    var clickCountryBlock: VoidBlock?
    
    ///点击位置高度
    var tap_H: CGFloat = 0 {
        didSet {
            backView.snp.remakeConstraints {
                $0.size.equalTo(CGSize(width: 160, height: 230))
                $0.left.equalToSuperview().offset(25)
                $0.top.equalToSuperview().offset(tap_H)
            }
        }
    }
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.12).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        return view
    }()

    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
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
        tableView.register(CountryCell.self, forCellReuseIdentifier: "CountryCell")
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
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        
        //loadData_Net()
        
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
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
        cell.setCellData(model: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickCountryBlock?(dataArr[indexPath.row])
        disAppearAction()
    }
    

    
//    private func loadData_Net() {
////        HUD_MB.loading("", onView: backView)
//        HTTPTOOl.getCountryList().subscribe(onNext: { [unowned self] (json) in
// //           HUD_MB.dissmiss(onView: backView)
//
//            var tarr: [CountryModel] = []
//            for jsondata in json["data"].arrayValue {
//                let model = CountryModel()
//                model.updateModel(json: jsondata)
//                tarr.append(model)
//            }
//
//            dataArr = tarr
//            table.reloadData()
//
//        }, onError: { [unowned self] (error) in
////            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
//        }).disposed(by: bag)
//    }

}



class CountryCell: BaseTableViewCell {
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#CCCCCC")
        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(11), .left)
        return lab
    }()
    
    
    private let codeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#000000"), BFONT(11), .right)
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
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        contentView.addSubview(codeLab)
        codeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
    }
    
    
    func setCellData(model: CountryModel) {
        nameLab.text = model.name
        codeLab.text = model.areaCode
    }
    
}
