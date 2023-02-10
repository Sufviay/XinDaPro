//
//  FilterOptionView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/28.
//

import UIKit

class FilterOptionView: UIView, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var selectBlock: VoidBlock?
    
    private var selectIdx: Int = 1000

    open var filterStrArr: [ScreenTagsModel] = [] {
        didSet {
            self.table.reloadData()
        }
    }


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(SelectOptionCell.self, forCellReuseIdentifier: "SelectOptionCell")
        return tableView
    }()
    
    
    
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(20), .center)
        lab.text = "UILABLE"
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置背景透明 不影响子视图
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.frame = CGRect(x: 0, y: statusBarH + 99, width: S_W, height: S_H - statusBarH - 99)
        self.isUserInteractionEnabled = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        
        self.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        
        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    @objc func tapAction() {
        //disAppearAction()
        //发送通知隐藏筛选
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Keys.sxpxStatus), object: "sx")
    }

    
    func appearAction(_ duration: TimeInterval = 0.3) {
        PJCUtil.getWindowView().addSubview(self)
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: duration) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            self.backView.snp.remakeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.height.equalTo(50 * self.filterStrArr.count)
            }
            ///要加这个layout
            self.layoutIfNeeded()
        }
    }
    
    
    func disAppearAction(_ duration: TimeInterval = 0.3) {
        
        UIView.animate(withDuration: duration, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.backView.snp.remakeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.height.equalTo(0)
            }
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
            self.selectBlock?(self.selectIdx)
        }
    }
    
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterStrArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectOptionCell") as! SelectOptionCell
        cell.titLab.text = filterStrArr[indexPath.row].name
        if indexPath.row == selectIdx {
            cell.titLab.textColor = MAINCOLOR
        } else {
            cell.titLab.textColor = FONTCOLOR
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != selectIdx {
            selectIdx = indexPath.row
            self.table.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Keys.sxpxStatus), object: "sx")
        } else {
            selectIdx = 1000
            self.table.reloadData()
        }
    }
    
}
