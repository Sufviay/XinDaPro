//
//  ScreenView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/13.
//

import UIKit
import RxSwift


class ScreenView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    private let bag = DisposeBag()
    ///所有的菜品
    var allDishes: [DishDisplayModel] = []
    
    ///分类数据
    var classifyData = ClassifyDataModel() {
        didSet {
            if classifyData.waiterClassifyStatus == "2" {
                dataArr = classifyData.classifyList_Off
            }
            if classifyData.waiterClassifyStatus == "1" {
                dataArr = classifyData.classifyList_On
            }
            collection.reloadData()
        }
    }
        
    ///确定筛选
    var clickConfirmBlock: VoidBlock?

    
    private var selIdx_1: Int = 1000
    private var selIdx_2: Int = 1000
    
    //分组数据
    private var dataArr: [ClassifyModel] = []
    
    ///选择的分组数据
    private var selectDataArr: [[GroupModel]] = []
    
    ///所有的二级分类数据
    private var secondClassifyArr: [GroupModel] = []
    
    private let backView: UIView = {        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
     
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.bounces = false
        coll.backgroundColor = .clear
        coll.showsVerticalScrollIndicator = false
        coll.register(GroupCell.self, forCellWithReuseIdentifier: "GroupCell")
        coll.register(GroupFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "GroupFooter")
        return coll
    }()
    
    private let closeBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("close"), for: .normal)
        return but
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setViews() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.isUserInteractionEnabled = true

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-200)
            $0.top.equalTo(statusBarH + 44)
        }


        
        backView.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(55)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(closeBut)
        closeBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 55, height: 55))
            $0.top.right.equalToSuperview()
        }

        closeBut.addTarget(self, action: #selector(clickCloseAction), for: .touchUpInside)
    }
    
    
    @objc private func clickCloseAction() {
        disAppearAction()
    }

    @objc private func tapAction() {
        disAppearAction()
    }    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.backView))! {
            return false
        }
        return true
    }

    
    private func addWindow() {
        PJCUtil.getWindowView().addSubview(self)
        
        self.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }

    }
    
    func appearAction() {
        addWindow()
    }
    
    func disAppearAction() {
        removeFromSuperview()
        
        var selectID_C: String = ""
        var colNum: Int = 0
        var dispayType: String = ""
        
        if classifyData.waiterClassifyStatus == "1" {
            if selIdx_2 == 1000 {
                selectID_C = ""
                colNum = 4
                dispayType = "1"
            } else {
                let model = dataArr[selIdx_1].subList[selIdx_2]
                selectID_C = model.classify
                colNum = model.colNum
                dispayType = model.displayType
            }
        } else {
            if selIdx_1 == 1000 {
                selectID_C = ""
                colNum = 4
                dispayType = "1"
            } else {
                let model = dataArr[selIdx_1]
                selectID_C = model.classify
                colNum = model.colNum
                dispayType = model.displayType
            }
        }
    
        let infoDic: [String: Any] = ["cID": selectID_C, "type": dispayType, "num": colNum]
        clickConfirmBlock?(infoDic)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if classifyData.waiterClassifyStatus == "1" {
            //开启了店员分类
            return 2
        }
        
        if classifyData.waiterClassifyStatus == "2" {
            
            return 1
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return dataArr.count
        } else {
            if selIdx_1 != 1000 {
                return dataArr[selIdx_1].subList.count
            } else {
                return 0
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        var model = ClassifyModel()
        var isSelect = false
        if indexPath.section == 0 {
            model = dataArr[indexPath.item]
            
            if selIdx_1 != 1000 {
                isSelect = indexPath.item == selIdx_1 ? true : false
            }
            
        }
        if indexPath.section == 1 {
            model = dataArr[selIdx_1].subList[indexPath.item]
            
            if selIdx_2 != 1000 {
                isSelect = indexPath.item == selIdx_2 ? true : false
            }
            
        }
        
        cell.setCellData(model: model, isSelect: isSelect)
        return cell
        
    }
    
    
    //设置每一个Item的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var model = ClassifyModel()
        
        if indexPath.section == 0 {
            model = dataArr[indexPath.item]
        }
        if indexPath.section == 1 {
            model = dataArr[selIdx_1].subList[indexPath.item]
        }
        let cn_w = model.classifyNameHk.getTextWidth(BFONT(15), 15) + 35
        let en_w = model.classifyNameEn.getTextWidth(BFONT(15), 15) + 35
        
        let c_w = cn_w > en_w ? cn_w : en_w
        return CGSize(width: c_w, height: 60)
    
    }
    
    
    //设置分区头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            //分区尾
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "GroupFooter", for: indexPath) as! GroupFooter
            return footer
            
        }

        return UICollectionReusableView()
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        return CGSize(width: UIScreen.main.bounds.width, height: 1)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            selIdx_2 = 1000
            
            if selIdx_1 == indexPath.item  {
                selIdx_1 = 1000
            } else {
                selIdx_1 = indexPath.item
            }
        }
        
        if indexPath.section == 1 {
            if selIdx_2 == indexPath.item {
                selIdx_2 = 1000
            } else {
                selIdx_2 = indexPath.item
            }
        }
        
        collection.reloadData()
        
        if classifyData.waiterClassifyStatus == "1" {
            //开启
            if selIdx_2 != 1000 {
                disAppearAction()
            }
        }
        
        if classifyData.waiterClassifyStatus == "2" {
            //关闭
            if selIdx_1 != 1000 {
                disAppearAction()
            }
        }
        
        
//        let model = dataArr[indexPath.section][indexPath.item]
//        
//        if classifyData.waiterClassifyStatus == "2" {
//            //关闭状态 用的是旧的分类
//            if selectDataArr[indexPath.section].count == 0 {
//                //没有选中的 添加
//                selectDataArr[indexPath.section].append(model)
//                
//            } else {
//                //已有选中的 进行判断
//                
//                //如果点击的是已选择的 取消选中状态
//                
//                if selectDataArr[indexPath.section][0].groupId == model.groupId {
//                    //取消选中
//                    selectDataArr[indexPath.section].removeAll()
//                } else {
//                    //只能单选
//                    selectDataArr[indexPath.section][0] = model
//                }
//            }
//            
//            //去掉其他的选择的分类
//            if model.searchType == "2" || model.classifyId != "" {
//                //点击了分类 要取消已选择的分类
//                for (idx, arr) in selectDataArr.enumerated() {
//                    for smodel in arr {
//                        if smodel.searchType == "2" || smodel.classifyId != "" {
//                            if smodel.groupId != model.groupId {
//                                selectDataArr[idx].removeAll()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        
//        
//        if classifyData.waiterClassifyStatus == "1" {
//            //开启状态
//            
//            //没有选中的，直接添加进去
//            if selectDataArr[indexPath.section].count == 0 {
//                
//                selectDataArr[indexPath.section].append(model)
//                
//                //如果是第一行 一级分类,就要展开二级分类
//                if indexPath.section == 0 {
//                    dataArr[1] = model.sub_Group
//                }
//                
//            }
//            //已经有选中的 要进行判断了
//            else {
//                
//                //如果是点击了已选择的 取消选中状态
//                
//                if selectDataArr[indexPath.section][0].groupId == model.groupId {
//                    //取消选中状态
//                    selectDataArr[indexPath.section].removeAll()
//                    if indexPath.section == 0 {
//                        //如果是取消第一行 一级分类，就要吧二级分类数据也取消掉（dataArr和selectDataArr）
//                        dataArr[1].removeAll()
//                        selectDataArr[1].removeAll()
//                    }
//                }
//                                
//                //如果点击的是未选择的
//                else {
//                    
//                    //只能单选
//                    selectDataArr[indexPath.section][0] = model
//                    
//                    //如果是第一行 一级分类
//                    if indexPath.section == 0 {
//                        //切换二级分类 并删除一选择的二级
//                        dataArr[1] = model.sub_Group
//                        selectDataArr[1].removeAll()
//                    }
//                }
//            }
//            
//            //去掉其他的选择的分类
//            
//            if model.classifyId != "" {
//                //点击的一级二级分类 要去掉分组中的分类
//                
//                for (idx, arr) in selectDataArr.enumerated() {
//                    for smodel in arr {
//                        if smodel.searchType == "2" {
//                            selectDataArr[idx].removeAll()
//                        }
//                    }
//                }
//            }
//            
//            if model.searchType == "2" {
//                //点击的是分组分类。去掉一二级分类 和其他分组分类
//                for (idx, arr) in selectDataArr.enumerated() {
//                    for smodel in arr {
//                                                
//                        if smodel.searchType == "2" || smodel.classifyId != "" {
//                            if smodel.groupId != model.groupId {
//                                selectDataArr[idx].removeAll()
//                            }
//                        }
//                    }
//                }
//                dataArr[1].removeAll()
//            }
//        }
//        collectionView.reloadData()
    }
    
    


    
    //MARK: - 网络请求
    
//    private func loadData_Net() {
//        HUD_MB.loading("", onView: backView)
//        
//            
//        //请求分组列表
//        HTTPTOOl.getDishesGroupList().subscribe(onNext: { [unowned self] (json) in
//            HUD_MB.dissmiss(onView: backView)
//            
//            
//            //处理分类
//            
//            if classifyData.waiterClassifyStatus == "2" {
//                //只有一个分类
//                
//                var cArr: [GroupModel] = []
//                for c_model in classifyData.classifyList_Off {
//                    let model = GroupModel()
//                    model.updateWithClassifty(model: c_model)
//                    cArr.append(model)
//                }
//                dataArr.append(cArr)
//                selectDataArr.append([])
//            }
//            
//            if classifyData.waiterClassifyStatus == "1" {
//                //开启二级分类
//                
//                var cArr: [GroupModel] = []
//
//                for c_model in classifyData.classifyList_On {
//                    let model = GroupModel()
//                    model.updateWithClassifty(model: c_model)
//                    
//                    var tarr: [GroupModel] = []
//                    for sc_model in c_model.subList {
//                        let smodel = GroupModel()
//                        smodel.updateWithClassifty(model: sc_model)
//                        smodel.isSecond = true
//                        tarr.append(smodel)
//                        secondClassifyArr.append(smodel)
//                    }
//                    model.sub_Group = tarr
//                    cArr.append(model)
//                }
//                                
//                dataArr = [cArr, []]
//                selectDataArr = [[], []]
//            }
//            
//            
//            
//            //处理分组
//            
//            var groupIDArr: [String] = []
//            var fzArr: [[GroupModel]] = []
//            var tArr: [GroupModel] = []
//            
//            /**
//                当parentId为0时就是一个新的分组
//                此时的groupID就是新分组的groupID的集合
//                然后根据groupID 进行分类
//             */
//        
//            
//            for jsonData in json["data"]["groupList"].arrayValue {
//                let parentID = jsonData["parentId"].stringValue
//                if parentID == "0" {
//                    let groupID = jsonData["groupId"].stringValue
//                    groupIDArr.append(groupID)
//                    fzArr.append([])
//                    selectDataArr.append([])
//                } else {
//                    let model = GroupModel()
//                    model.updateWithGroup(json: jsonData)
//                    if model.searchType == "1" {
//                        for reJson in json["data"]["classifyList"].arrayValue {
//                            
//                            if json["data"]["busiClassifyStatus"].stringValue == "2" {
//                                //旧分类
//                                if model.groupId == reJson["groupId"].stringValue {
//                                    model.relClassifyArr.append(reJson["classifyOneId"].stringValue)
//                                }
//                            }
//                            if json["data"]["busiClassifyStatus"].stringValue == "1" {
//                                //新的二级分类
//                                if model.groupId == reJson["groupId"].stringValue {
//                                    model.relClassifyArr.append(reJson["classifyTwoId"].stringValue)
//                                }
//                            }
//                        }
//                    }
//                    tArr.append(model)
//                }
//            }
//            
//            
//            for model in tArr {
//                for (idx, id) in groupIDArr.enumerated() {
//                    if model.parentId == id {
//                        fzArr[idx].append(model)
//                    }
//                }
//            }
//            dataArr += fzArr
//            fzColleciton.reloadData()
//            
//        }, onError: { [unowned self] (error) in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: backView)
//        }).disposed(by: bag)
//
//        
//    }
    
    
}


//extension ScreenView {
//    
//    
//    //处理筛选的逻辑操作
//    private func doScreen() {
//        
//        
//        
//
//        
//        var tArr: [DishModel] = []
//        
//        var dealScreenData: [GroupModel] = []
//        
//        for arr in selectDataArr {
//            for model in arr {
//                dealScreenData.append(model)
//            }
//        }
//        
//        
//        //生成筛选词
//        var tStr = ""
//        
//        for (idx, model) in dealScreenData.enumerated() {
//            if idx == 0 {
//                tStr += "\(model.nameEn)(\(model.nameHk))"
//            } else {
//                tStr += " - \(model.nameEn)(\(model.nameHk))"
//            }
//        }
//
//        
//        
//        //分类数据
//        var flArr: [GroupModel] = []
//        //分组数据
//        var fzArr: [GroupModel] = []
//        
//        //处理分类 和 分组。
//        for model in dealScreenData {
//            if model.classifyId != "" || model.searchType == "2" {
//                flArr.append(model)
//            } else {
//                fzArr.append(model)
//            }
//        }
//        
//        
//        //旧分类
//        if classifyData.waiterClassifyStatus == "2" {
//            
//            //分类数组只有一个。
//            
//            if flArr.count == 0 {
//                //没有分类数据直接 进行分组筛选
//                tArr = allDishes
//                
//                for model in fzArr {
//                    tArr = tArr.filter { $0.dishesNameEn.localizedCaseInsensitiveContains(model.nameEn) || $0.dishesNameHk.localizedCaseInsensitiveContains(model.nameHk) }
//                    //筛选相关联的分类
//                    if model.relClassifyArr.count != 0 {
//                        tArr = tArr.filter { dishModel in
//                            model.relClassifyArr.contains(dishModel.classifyId)
//                        }
//                    }
//                }
//            } else {
//                //有分类数据 先处理分类筛选
//                //遍历菜品 处理分类
//                for dish in allDishes {
//                    
//                    for model in flArr {
//                        //分类ID 相同加入
//                        if model.classifyId != "" {
//                            if dish.classifyId == model.classifyId {
//                                tArr.append(dish)
//                            }
//                        }
//                        
//                        if model.searchType == "2" {
//                            //要先对分类名字进行字符串匹配，然后根据匹配的分类再去筛选菜品
//            
//                            //所有的分类
//                            let allFLArr = dataArr.first!
//                            //筛选条件，中文或者英文任意包含都可以
//                            let sxFLArr = allFLArr.filter { $0.nameEn.localizedCaseInsensitiveContains(model.nameEn) || $0.nameHk.localizedCaseInsensitiveContains(model.nameHk) }
//                            //然后筛选没有选择过的分类菜品
//                            for sxmodel in sxFLArr {
//                                
//                                if dish.classifyId == sxmodel.classifyId {
//                                    tArr.append(dish)
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                //再处理分组筛选
//                if tArr.count != 0 {
//                    for model in fzArr {
//                        tArr = tArr.filter { $0.dishesNameEn.localizedCaseInsensitiveContains(model.nameEn) || $0.dishesNameHk.localizedCaseInsensitiveContains(model.nameHk) }
//                        //筛选相关联的分类
//                        if model.relClassifyArr.count != 0 {
//                            tArr = tArr.filter { dishModel in
//                                model.relClassifyArr.contains(dishModel.classifyId)
//                            }
//                        }
//
//                    }
//                }
//            }
//        }
//
//        
//        
//        //开启了二级分类
//        if classifyData.waiterClassifyStatus == "1" {
//            
//
//            if flArr.count == 0 {
//                //没有分类数据直接 进行分组筛选
//                
//                tArr = allDishes
//                
//                for model in fzArr {
//                    tArr = tArr.filter { $0.dishesNameEn.localizedCaseInsensitiveContains(model.nameEn) || $0.dishesNameHk.localizedCaseInsensitiveContains(model.nameHk) }
//                    
//                    if model.relClassifyArr.count != 0 {
//                        //筛选相关联的二级分类
//                        
//
//                        tArr = tArr.filter { dishModel in
//                            
//                            var isCon: Bool = false
//                            for secondID in dishModel.S_classifyIds {
//                                if model.relClassifyArr.contains(secondID) {
//                                    isCon = true
//                                    break
//                                }
//                            }
//                            
//                            return isCon
//                        }
//                    }
//                }
//            } else {
//                //有 先处理分类
//                for dish in allDishes {
//                    
//                    for model in flArr {
//                        if model.classifyId != "" {
//                            
//                            //一级分类
//                            if !model.isSecond {
//                                if dish.F_classifyIds.contains(model.classifyId) {
//                                    if !tArr.contains(dish) {
//                                        tArr.append(dish)
//                                    }
//                                    
//                                }
//                            }
//                            //二级分类
//                            if model.isSecond {
//                                tArr = tArr.filter { $0.S_classifyIds.contains(model.classifyId) }
//                            }
//                            
//                        }
//                        
//                        if model.searchType == "2" {
//                            //分组中的分类
//                            //要先对二级分类名字进行字符串匹配，然后根据匹配的分类再去筛选菜品
//                            //筛选条件，中文或者英文任意包含都可以
//                            let sxFLArr = secondClassifyArr.filter { $0.nameEn.localizedCaseInsensitiveContains(model.nameEn) || $0.nameHk.localizedCaseInsensitiveContains(model.nameHk) }
//                            
//                            for sxmodel in sxFLArr {
//                                if dish.S_classifyIds.contains(sxmodel.classifyId) {
//                                    if !tArr.contains(dish) {
//                                        tArr.append(dish)
//                                    }
//                                }
//                            }
//                        }
//
//                    }
//                    
//                }
//                
//                //再处理分组筛选
//                if tArr.count != 0 {
//                    for model in fzArr {
//                        tArr = tArr.filter { $0.dishesNameEn.localizedCaseInsensitiveContains(model.nameEn) || $0.dishesNameHk.localizedCaseInsensitiveContains(model.nameHk) }
//                        //筛选相关联的二级分类
//                        if model.relClassifyArr.count != 0 {
//                            //筛选相关联的二级分类
//                            
//
//                            tArr = tArr.filter { dishModel in
//                                
//                                var isCon: Bool = false
//                                for secondID in dishModel.S_classifyIds {
//                                    if model.relClassifyArr.contains(secondID) {
//                                        isCon = true
//                                        break
//                                    }
//                                }
//                                
//                                return isCon
//                            }
//                        }
//
//                    }
//                }
//
//            }
//            
//        }
//        
//      
//        
////
////        
////        var tArr: [DishModel] = allDishes
////        
////        
////        //2 对菜品选择的分组进行筛选
////    
////        for model in dealScreenData {
////            
////            if model!.classifyId != "" {
////                //如果 model.classifyId不是空, 进行分类的筛选
////                tArr = tArr.filter { $0.classifyId == model!.classifyId }
////
////            }
////            
////            if model!.searchType == "2" {
////                //要先对分类名字进行字符串匹配，然后根据匹配的分类再去筛选菜品
////                
////                //所有的分类
////                let allFLArr = dataArr.first!
////                //筛选条件，中文或者英文任意包含都可以
////                let sxFLArr = allFLArr.filter { $0.nameEn.localizedCaseInsensitiveContains(model!.nameEn) || $0.nameHk.localizedCaseInsensitiveContains(model!.nameHk) }
////                
////                tArr = tArr.filter({ dmodel in
////                    //菜品分类ID 是在筛选出来的分类中存在的
////                    (sxFLArr.filter { $0.classifyId == dmodel.classifyId}).count != 0
////                
////                })
////            }
////            
////            if model?.searchType == "1" {
////                //对菜品名字进行的筛选 中文或者英文任意包含都可以
////                tArr = tArr.filter { $0.dishesNameEn.localizedCaseInsensitiveContains(model!.nameEn) || $0.dishesNameHk.localizedCaseInsensitiveContains(model!.nameHk) }
////
////            }
////            
////        }
////        
//        let dic: [String: Any] = ["key": tStr, "arr": tArr]
//        clickConfirmBlock?(dic)
//        disAppearAction()
////        
//    }
//    
//}
