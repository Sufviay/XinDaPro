//
//  DishSelectClassifyView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/24.
//

import UIKit
import RxSwift

class DishSelectClassifyView: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var confirmBlock: VoidBlock?
    
    private let bag = DisposeBag()
    
    ///店铺ID
    var storeID: String = ""
    ///选择的ID
    var selectID: String = ""
    
    
    private var dataArr: [ClassiftyModel] = []

    private var H: CGFloat = bottomBarH + 500
    
    var type: String = ""
       

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 500), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()
    
    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Classification"
        return lab
    }()
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()
    
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()
    
    
    private lazy var table: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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

        tableView.register(SelectLabCell.self, forCellReuseIdentifier: "SelectLabCell")

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
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
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
        
        backView.addSubview(saveBut)
        saveBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-bottomBarH - 40)
            $0.height.equalTo(50)
        }

        backView.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(70)
            $0.bottom.equalTo(saveBut.snp.top).offset(-20)
        }


        self.closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func clickCloseAction() {
        self.disAppearAction()

     }

    
    @objc private func clickSaveAction() {
        
        if selectID == "" {
            confirmBlock?(["", ""])
        } else {
            for tmode in dataArr {
                if tmode.id == selectID {
                    confirmBlock?([tmode.id, tmode.name])
                }
            }
        }
        
        self.disAppearAction()
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
       self.loadData_Net()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLabCell") as! SelectLabCell
        let model = dataArr[indexPath.row]
        let isSel = model.id == selectID
        cell.setCellData(isSelect: isSel, titStr: model.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        if model.id != selectID {
            selectID = model.id
        } else {
            selectID = ""
        }
        self.table.reloadData()
    }
    
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: backView)
        
        HTTPTOOl.getStoreDishesClassify(id: storeID).subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.backView)
            
            var tArr: [ClassiftyModel] = []
            for jsondata in json["data"].arrayValue {
                let model = ClassiftyModel()
                model.updateModel(json: jsondata)
                tArr.append(model)
            }
            self.dataArr = tArr
            self.table.reloadData()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.backView)
        }).disposed(by: self.bag)
        
    }
    
}



class SelectLabCell: BaseTableViewCell {
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), SFONT(14), .left)
        return lab
    }()
    
    override func setViews() {
        
        contentView.addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(35)
        }
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(65)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    
    func setCellData(isSelect: Bool, titStr: String)  {
        self.titLab.text = titStr
        
        if isSelect {
            self.selectImg.image = LOIMG("dish_sel_b")
            self.titLab.textColor = HCOLOR("#465DFD")
        } else {
            self.selectImg.image = LOIMG("dish_unsel_b")
            self.titLab.textColor = HCOLOR("#333333")

        }
    }
}


