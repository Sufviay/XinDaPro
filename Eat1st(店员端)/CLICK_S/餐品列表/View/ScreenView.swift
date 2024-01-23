//
//  ScreenView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/13.
//

import UIKit
import RxSwift


class ScreenView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let bag = DisposeBag()
    ///所有
    var allDishes: [DishModel] = []
//    ///筛选后
//    var screenDishes: [DishModel] = []

    ///确定筛选
    var clickConfirmBlock: VoidBlock?

    
    
    
    //分组数据
    private var dataArr: [[GroupModel]] = []
    ///选择的分组数据
    private var selectDataArr: [GroupModel?] = []
    
    private let backView: UIView = {        
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - bottomBarH - statusBarH - 44 - R_H(136)), byRoundingCorners: [.bottomLeft, .bottomRight], radii: 20)
        return view
    }()
    
    
    private let zmArr: [String] = ["A", "B", "C", "", "E", "W", "H", "S"]
    
    private lazy var zmColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 5
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.bounces = true
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.tag = 1
        coll.register(KeyCell.self, forCellWithReuseIdentifier: "KeyCell")
        return coll
    }()
    
    
    private let szArr: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    private lazy var szColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 5
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.bounces = true
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.tag = 2
        coll.register(KeyCell.self, forCellWithReuseIdentifier: "KeyCell")
        return coll
    }()
    
    
    private lazy var fzColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 7
        
        layout.sectionInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.bounces = false
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.tag = 3
        coll.register(GroupCell.self, forCellWithReuseIdentifier: "GroupCell")
        coll.register(GroupFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "GroupFooter")
        return coll
    }()
    
    
    private let inputBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FAFAFA")
        view.layer.cornerRadius = 6
        return view
    }()
    

    private let cleanBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.setImage(LOIMG("qingchu"), for: .normal)
        return but
    }()
    
    private let inputTF: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.font = BFONT(17)
        tf.textColor = HCOLOR("#666666")
        tf.isEnabled = false
        return tf
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: S_W - 40, height: 0.5)
        view.drawDashLine(strokeColor: HCOLOR("#D8D8D8"), lineWidth: 0.5, lineLength: 5, lineSpacing: 5)
        return view
    }()
    
    
    private let confimBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Confirm", HCOLOR("#000000"), BFONT(13), HCOLOR("#FEC501"))
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let resetBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Reset", HCOLOR("#FEC501"), BFONT(13), .white)
        but.clipsToBounds = true
        but.layer.cornerRadius = 10
        but.layer.borderWidth = 2
        but.layer.borderColor = HCOLOR("#FEC501").cgColor
        return but
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        loadData_Net()
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setViews() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.frame = CGRect(x: 0, y: statusBarH + 44, width: S_W, height: S_H - statusBarH - 44 )
        self.isUserInteractionEnabled = true

        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: S_W, height: S_H - bottomBarH - statusBarH - 44 - R_H(136)))
            $0.left.right.top.equalToSuperview()
        }


        let W = (S_W - 40 - 27) / 10
        backView.addSubview(zmColleciton)
        zmColleciton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
            $0.width.equalTo(W * 4 + 9)
            $0.height.equalTo(W * 2 + 5)
        }
        
        backView.addSubview(szColleciton)
        szColleciton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(W)
            $0.top.equalTo(zmColleciton.snp.bottom).offset(5)
        }
        
        backView.addSubview(inputBackView)
        inputBackView.snp.makeConstraints {
            $0.top.bottom.equalTo(zmColleciton)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(zmColleciton.snp.left).offset(-15)
        }
        
        inputBackView.addSubview(cleanBut)
        cleanBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.right.equalToSuperview().offset(0)
            $0.centerY.equalToSuperview()
        }
        
        inputBackView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-50)
        }
        
        
        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(szColleciton.snp.bottom).offset(15)
        }
    
        backView.addSubview(confimBut)
        confimBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
            $0.left.equalTo(backView.snp.centerX).offset(10)
        }
        
        backView.addSubview(resetBut)
        resetBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
            $0.right.equalTo(backView.snp.centerX).offset(-10)
        }

        
        backView.addSubview(fzColleciton)
        fzColleciton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(line1.snp.bottom)
            $0.bottom.equalTo(resetBut.snp.top).offset(-20)
        }
        
        resetBut.addTarget(self, action: #selector(clickResetAction), for: .touchUpInside)
        confimBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        cleanBut.addTarget(self, action: #selector(clickCleanAction), for: .touchUpInside)
    }
    
    
    
    
    //MARK: - 点击确定， 进行筛选
    @objc private func clickConfirmAction() {
    
        //可以进行筛选
        doScreen()

        
        
    }
    
    @objc private func clickResetAction() {
        inputTF.text = ""
        for idx in 0..<selectDataArr.count {
            selectDataArr[idx] = nil
        }
        fzColleciton.reloadData()
    }
    

    @objc private func clickCleanAction() {
        //清空输入框
        inputTF.text = ""
    }

    
    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)

    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        removeFromSuperview()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 3 {
            return dataArr.count
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return zmArr.count
        }
        if collectionView.tag == 2 {
            return szArr.count
        }
        if collectionView.tag == 3 {
            return dataArr[section].count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
            let model = dataArr[indexPath.section][indexPath.item]
            var isSelect = false
            if selectDataArr[indexPath.section] != nil {
                if selectDataArr[indexPath.section]!.groupId == model.groupId {
                    isSelect = true
                }
            }
            cell.setCellData(model: dataArr[indexPath.section][indexPath.item], isSelect: isSelect)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyCell", for: indexPath) as! KeyCell
        if collectionView.tag == 1 {
            cell.setCellData(titStr: zmArr[indexPath.item])
        }
        if collectionView.tag == 2 {
            cell.setCellData(titStr: szArr[indexPath.item])
        }
        
        return cell
    }
    
    
    //设置每一个Item的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 3 {
            let model = dataArr[indexPath.section][indexPath.item]
            let cn_w = model.nameHk.getTextWidth(BFONT(9), 10) + 40
            let en_w = model.nameEn.getTextWidth(BFONT(9), 10) + 40
            
            let c_w = cn_w > en_w ? cn_w : en_w
            return CGSize(width: c_w, height: 33)
        }
        
        let W = (S_W - 40 - 27) / 10
        return CGSize(width: W , height: W)
    
    }
    
    
    //设置分区头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView.tag == 3 {
            if kind == UICollectionView.elementKindSectionFooter {
                //分区尾
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "GroupFooter", for: indexPath) as! GroupFooter
                return footer
                
            }
        }
        return UICollectionReusableView()
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    
        if collectionView.tag == 3 {
            return CGSize(width: S_W, height: 1)
        }
        
        return .zero
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            //点击字母
            let str = zmArr[indexPath.item]
            if str == "" {
                //去除一个字符
                if inputTF.text ?? "" != "" {
                    inputTF.text?.removeLast()
                }
                
            } else {
                //添加字符
                inputTF.text?.append(str)
            }
        }
        
        if collectionView.tag == 2 {
            //点击数字
            let str = szArr[indexPath.item]
            inputTF.text?.append(str)
        }
        
        if collectionView.tag == 3 {
            let model = dataArr[indexPath.section][indexPath.item]
            
            if model.searchType == "2" {
                //点击了分类分组 需要把选择的分类去掉 还需要把选择的其他分类分组去掉
                selectDataArr[0] = nil
                for (idx, model) in selectDataArr.enumerated() {
                    if idx != indexPath.section && model?.searchType == "2" {
                        selectDataArr[idx] = nil
                    }
                }
            }
            
            if model.classifyId != "" {
                //点击分类 需要把分类分组去掉
                for (idx, model) in selectDataArr.enumerated() {
                    if model != nil {
                        if model?.searchType == "2" {
                            selectDataArr[idx] = nil
                        }
                    }
                }
            }
            
            if selectDataArr[indexPath.section] == nil {
                selectDataArr[indexPath.section] = model
            } else {
                if selectDataArr[indexPath.section]!.groupId == model.groupId {
                    selectDataArr[indexPath.section] = nil
                } else {
                    selectDataArr[indexPath.section] = model
                }
            }
            collectionView.reloadData()
        }
    }
    
    
    

    
    //MARK: - 网络请求
    
    private func loadData_Net() {
        HUD_MB.loading("", onView: backView)
        
        //先请求分类
        HTTPTOOl.getDishesClassiftyList().subscribe(onNext: { [unowned self] (json) in
            dataArr.removeAll()
            selectDataArr.removeAll()
            var cArr: [GroupModel] = []
            for jsonData in json["data"].arrayValue {
                let model = GroupModel()
                model.updateWithClassifty(json: jsonData)
                cArr.append(model)
            }
            dataArr.append(cArr)
            selectDataArr.append(nil)
            
            //请求分组列表
            HTTPTOOl.getDishesGroupList().subscribe(onNext: { [unowned self] (json) in
                HUD_MB.dissmiss(onView: backView)
                
                var groupIDArr: [String] = []
                var fzArr: [[GroupModel]] = []
                var tArr: [GroupModel] = []
                
                for jsonData in json["data"].arrayValue {
                    let parentID = jsonData["parentId"].stringValue
                    if parentID == "0" {
                        let groupID = jsonData["groupId"].stringValue
                        groupIDArr.append(groupID)
                        fzArr.append([])
                        selectDataArr.append(nil)
                    } else {
                        let model = GroupModel()
                        model.updateWithGroup(json: jsonData)
                        tArr.append(model)
                    }
                }
                
                
                for model in tArr {
                    for (idx, id) in groupIDArr.enumerated() {
                        if model.parentId == id {
                            fzArr[idx].append(model)
                        }
                    }
                }
                dataArr += fzArr
                fzColleciton.reloadData()
                
            }, onError: { [unowned self] (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
            }).disposed(by: bag)

            
            
        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
        }).disposed(by: bag)
        
        
    }
    
    
}


extension ScreenView {
    
    
    //处理筛选的逻辑操作
    private func doScreen() {
        
        
        //处理筛选条件
        let dealScreenData = selectDataArr.filter { $0 != nil }
        
        //生成筛选词
        var tStr = ""
        if inputTF.text ?? "" != "" {
            tStr += "\(inputTF.text!) "
        }
        
        
        for (idx, model) in dealScreenData.enumerated() {
            if idx == 0 {
                tStr += "\(model!.nameEn)(\(model!.nameHk))"
            } else {
                tStr += " - \(model!.nameEn)(\(model!.nameHk))"
            }
        }
        
        
        //对每个筛选词进行处理
        //1 对菜品编码进行筛
        var tArr: [DishModel] = []
        
        if inputTF.text ?? "" != "" {
            
            for model in allDishes {
                if model.dishesCode.localizedCaseInsensitiveContains(inputTF.text!) {
                    tArr.append(model)
                }
            }
            
            if tArr.count == 0 {
                let dic: [String: Any] = ["key": tStr, "arr": tArr]
                clickConfirmBlock?(dic)
                disAppearAction()
                return
            }
            
        } else {
            
            if dealScreenData.count != 0 {
                tArr = allDishes
            } else {
                let dic: [String: Any] = ["key": tStr, "arr": tArr]
                clickConfirmBlock?(dic)
                disAppearAction()
                return
            }
        }
        
        
        //2 对菜品选择的分组进行筛选
    
        for model in dealScreenData {
            
            
            if model!.classifyId != "" {
                //如果 model.classifyId不是空, 进行分类的筛选
                
//                if tArr.count == 0 && inputTF.text ?? "" == "" {
//                    //还没搜索呢，要对全部的菜品进行搜索
//                    tArr = allDishes.filter { $0.classifyId == model!.classifyId }
//                } else {
                    //已经有搜索内容了 对已经搜索出来的进行筛选
                    tArr = tArr.filter { $0.classifyId == model!.classifyId }
//                }
            }
            
            if model!.searchType == "2" {
                //要先对分类名字进行字符串匹配，然后根据匹配的分类再去筛选菜品
                
                //所有的分类
                let allFLArr = dataArr.first!
                //筛选条件，中文或者英文任意包含都可以
                let sxFLArr = allFLArr.filter { $0.nameEn.localizedCaseInsensitiveContains(model!.nameEn) || $0.nameHk.localizedCaseInsensitiveContains(model!.nameHk) }
                
               
                //根据筛选出来的分类 再对菜品进行筛选
//                if tArr.count == 0 && inputTF.text ?? "" == "" {
//                    for model in sxFLArr {
//                        for dish in allDishes {
//                            if dish.classifyId == model.classifyId {
//                                tArr.append(dish)
//                            }
//                        }
//                    }
//                } else {
                    
                    tArr = tArr.filter({ dmodel in
                        //菜品分类ID 是在筛选出来的分类中存在的
                        (sxFLArr.filter { $0.classifyId == dmodel.classifyId}).count != 0
                    
                    })
//                }
            }
            
            if model?.searchType == "1" {
                //对菜品名字进行的筛选 中文或者英文任意包含都可以
                
//                if tArr.count == 0 && inputTF.text ?? "" == "" {
//                    //所有的菜
//                    tArr = allDishes.filter { $0.dishesNameEn.localizedCaseInsensitiveContains(model!.nameEn) || $0.dishesNameHk.localizedCaseInsensitiveContains(model!.nameHk) }
//                } else {
                    tArr = tArr.filter { $0.dishesNameEn.localizedCaseInsensitiveContains(model!.nameEn) || $0.dishesNameHk.localizedCaseInsensitiveContains(model!.nameHk) }
//                }

            }
            
        }
        
        let dic: [String: Any] = ["key": tStr, "arr": tArr]
        clickConfirmBlock?(dic)
        disAppearAction()
        
    }
    
}
