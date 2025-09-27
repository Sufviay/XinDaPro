//
//  TableSelectAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/22.
//

import UIKit
import RxSwift

class TableSelectAlert: BaseAlertView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var selectBlock: VoidStringBlock?

    private let bag = DisposeBag()
    
    private var tableArr: [TableModel] = []
    
    private var selectID: String = ""
    
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

    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", HCOLOR("465DFD"), BFONT(14), .white)
        but.layer.cornerRadius = 10
        but.layer.borderWidth = 1
        but.layer.borderColor = HCOLOR("465DFD").cgColor
        return but
    }()
    
    override func setViews() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)

        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 200, height: 350))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            
        }
        
        backView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalTo(backView.snp.centerX).offset(-10)
        }
        
        backView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-15)
            $0.height.equalTo(40)
            $0.right.equalToSuperview().offset(-15)
            $0.left.equalTo(backView.snp.centerX).offset(10)
        }

        

        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalTo(confirmBut.snp.top).offset(-10)
        }

        loadData_Net()
        
        cancelBut.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        
    }
    
    
    @objc func cancelAction() {
        disAppearAction()
    }

    
    @objc func confirmAction() {
        
        if selectID != "" {
            selectBlock?(selectID)
            disAppearAction()
        }
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
        return tableArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
        cell.tlab.text = tableArr[indexPath.row].deskName
        
        if selectID == tableArr[indexPath.row].deskId {
            cell.tlab.textColor = HCOLOR("#465DFD")
        } else {
            cell.tlab.textColor = TXTCOLOR_1
        }
        
        return cell
        
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectID = tableArr[indexPath.row].deskId
        table.reloadData()
    }

    
    private func loadData_Net() {
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.getDeskList(page: 1).subscribe(onNext: { [unowned self] (json) in
            //餐桌
            HUD_MB.dissmiss(onView: backView)
            var tArr: [TableModel] = []
            for jsonData in json["data"].arrayValue {
                let model = TableModel()
                model.updateModel(json: jsonData)
                tArr.append(model)
            }
            tableArr = tArr
            table.reloadData()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    

}
