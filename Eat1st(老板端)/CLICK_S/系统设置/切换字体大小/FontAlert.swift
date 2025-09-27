//
//  FontAlert.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/8/25.
//

import UIKit

class FontAlert: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    private var H: CGFloat = bottomBarH + 350
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: bottomBarH + 350), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        return view
    }()

    
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("dis_cancel"), for: .normal)
        return but
    }()
    
    private let saveBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Save".local, .white, TIT_2, MAINCOLOR)
        but.layer.cornerRadius = 14
        return but
    }()
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Font size".local
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
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(FontSizeOptionCell.self, forCellReuseIdentifier: "FontSizeOptionCell")
        return tableView
    }()

    private let titStrArr: [String] = ["Large font size".local, "Medium-sized font".local, "Small font size".local]
    
    private var selectIdx: Int = 0 {
        didSet {
            table.reloadData()
        }
    }
    
    
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
            $0.bottom.equalToSuperview().offset(-bottomBarH - 40)
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
            $0.bottom.equalTo(saveBut.snp.top).offset(-10)
        }
        
        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
        saveBut.addTarget(self, action: #selector(clickSaveAction), for: .touchUpInside)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickCloseAction() {
        disAppearAction()
    }
    
    
    @objc private func clickSaveAction() {
        

        if selectIdx == 0 {
            ChangeFontManager.shared.fontsize = .large
        }
        if selectIdx == 1 {
            ChangeFontManager.shared.fontsize = .medium
        }
        if selectIdx == 2 {
            ChangeFontManager.shared.fontsize = .small
        }
        ChangeFontManager.saveFontSize()
        ChangeFontManager.updateFontSize()
        HUD_MB.loading("设置中...".local, onView: PJCUtil.getWindowView())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            HUD_MB.showSuccess("设置成功！".local, onView: PJCUtil.getWindowView())
            disAppearAction()
            PJCUtil.currentVC()?.navigationController?.setViewControllers([BossFirstController()], animated: true)
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
        
        let font = ChangeFontManager.currentFontSize()
        switch font {
        case .large:
            selectIdx = 0
        case .medium:
            selectIdx = 1
        case .small:
            selectIdx = 2
        }
        
        addWindow()
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
     
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isSelect = selectIdx == indexPath.row ? true : false
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontSizeOptionCell") as! FontSizeOptionCell
        cell.setCellData(titStr: titStrArr[indexPath.row], isSelect: isSelect)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectIdx != indexPath.row {
            selectIdx = indexPath.row
        }
        
    }
    

}
