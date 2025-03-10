//
//  EditPriceView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/9/11.
//

import UIKit
import RxSwift

class EditPriceView: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    private let bag = DisposeBag()
    
    private var H: CGFloat = bottomBarH + 500
    
    private var dishesID: String = ""
    private var sellType: String = ""
    private var buffetType: String = ""
    private var dePrice: String = ""
    private var dinePrice: String = ""
    
    
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
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "Edit price"
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

        tableView.register(DishEditeChooseCell_Three.self, forCellReuseIdentifier: "DishEditeChooseCell_Three")
        tableView.register(DishEditeChooseCell.self, forCellReuseIdentifier: "DishEditeChooseCell")
        tableView.register(DishEditePriceInPutCell.self, forCellReuseIdentifier: "DishEditePriceInPutCell")
        return tableView
        
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        addNotification()
        
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
            $0.bottom.equalToSuperview().offset(-bottomBarH - 10)
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
            $0.top.equalTo(line.snp.bottom).offset(5)
            $0.bottom.equalTo(saveBut.snp.top).offset(-10)
        }
        
        
        self.closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        self.saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func clickCloseAction() {
        self.disAppearAction()

     }
    
    @objc private func clickSaveAction() {
        updatePrice_Net()
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
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        }
        if indexPath.row == 1 {
            return 90
        }

        if indexPath.row == 2 || indexPath.row == 3 {
            return 80
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell_Three") as! DishEditeChooseCell_Three
            cell.setCellData(titStr: "Method of sale", l_str: "Delivery", m_str: "Dine-in", r_str: "All", statusID: sellType)
            cell.selectBlock = { [unowned self] (type) in
                sellType = type
                table.reloadData()
            }
            return cell
        }
    
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditeChooseCell") as! DishEditeChooseCell
            cell.setChooseCellData(titStr: "Buffet", l_str: "Enable", r_Str: "Disable", statusID: buffetType)
        
            cell.selectBlock = { [unowned self] (status) in
                buffetType = status
                table.reloadData()
            }
            return cell
        }
        if indexPath.row == 2 || indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DishEditePriceInPutCell") as! DishEditePriceInPutCell
            if indexPath.row == 2 {
                cell.setCellData(money: dePrice, titStr: "Delivery Price")
            }
            if indexPath.row == 3 {
                cell.setCellData(money: dinePrice, titStr: "Dine-in Price")
            }
            
            cell.editeEndBlock = { [unowned self] (text) in
                
                if indexPath.row == 2 {
                    dePrice = text
                }
                if indexPath.row == 3 {
                    dinePrice = text
                }
            }
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
    
    
    func setAlertData(id: String, sellType: String, buffetType: String, dePrice: String, dinePrice: String) {
        dishesID = id
        self.sellType = sellType
        self.buffetType = buffetType
        self.dePrice = dePrice
        self.dinePrice = dinePrice
        table.reloadData()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}


extension EditPriceView {
    //添加监听
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHiden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    @objc func keyboardWillShow(notification: NSNotification) {
        //获取键盘高度
        let userInfo: Dictionary = notification.userInfo!
        let value = userInfo["UIKeyboardFrameEndUserInfoKey"]
        let keyboardRec = (value as AnyObject).cgRectValue
        let height = keyboardRec?.size.height ?? 0
        
        self.backView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-(height - bottomBarH - 90))
        }
    }
    
    @objc func keyboardWillHiden(notification: NSNotification) {
        self.backView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
    }


}

extension EditPriceView {
    
    //MARK: - 网络请求
    private func updatePrice_Net() {
        
        HUD_MB.loading("", onView: backView)
        HTTPTOOl.updateDishesPrice(id: dishesID, sellType: sellType, buffetType: buffetType, dePrice: dePrice, dinePrice: dinePrice).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: backView)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dishList"), object: nil)
            disAppearAction()
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
    }
    
}
