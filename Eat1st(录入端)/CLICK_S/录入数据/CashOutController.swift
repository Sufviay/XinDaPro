//
//  CashOutController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/23.
//

import UIKit
import RxSwift

class CashOutController: HeadBaseViewController, UITableViewDelegate, UITableViewDataSource  {
    
    private let bag = DisposeBag()
    
    var code: String = "" {
        didSet {
            self.idx = dataModel.nameList.firstIndex(of: code) ?? 0
        }
    }


    private var idx: Int = 0 {
        didSet {
            self.headView.curStep = idx
            self.nextBut.setTitle("Submit", for: .normal)
            if idx == 0 {
                lastBut.isHidden = true
                leftBut.isHidden = true
            }

        }
    }

    ///上传的图片
    private var picImgArr: [UIImage] = []

    private let name1Arr = ["Driver(£)", "Part Time(£)", "Goods(£)", "Other(£)", "Pre Paid(£)", "Remain(£)"]
    private let name2Arr = ["司機", "兼職", "商品", "其他", "預付", "剩餘"]

    private lazy var headView: HeaderInfoView = {
        let view = HeaderInfoView()
        view.dataModel = dataModel
        return view
    }()

    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(17), .left)
        lab.text = "Cash Out"
        return lab
    }()

    private let line: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 1.5
        img.image = GRADIENTCOLOR(HCOLOR("#FF8E12"), HCOLOR("#FFC65E"), CGSize(width: 45, height: 3))
        return img
    }()



    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        //tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(DataInPutCell_H.self, forCellReuseIdentifier: "DataInPutCell_H")
        tableView.register(DataUploadImgCell.self, forCellReuseIdentifier: "DataUploadImgCell")
        tableView.register(DateChooseCell.self, forCellReuseIdentifier: "DateChooseCell")
        
        
        return tableView
    }()



    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)

    }

    override func setViews() {
        setUpUI()


    }


    private func setUpUI() {

        view.addSubview(headView)
        headView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(85)
            $0.top.equalTo(headImg.snp.bottom).offset(-30)
        }

        view.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(headView.snp.bottom).offset(25)
        }

        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
        }


        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(lastBut.snp.top).offset(-10)
            $0.top.equalTo(line.snp.bottom).offset(10)
        }

        if idx == 0 {
            nextBut.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-40)
                $0.left.equalToSuperview().offset(40)
                $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
                $0.height.equalTo(50)
            }
        } else {
            nextBut.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-20)
                $0.width.equalTo((S_W - 55) / 2)
                $0.bottom.equalToSuperview().offset(-bottomBarH - 20)
                $0.height.equalTo(50)
            }

        }
    }



    override func nextAction() {

        if dataModel.driverCashOut == "" {
            HUD_MB.showWarnig("Please fill in the data!", onView: self.view)
            return
        }
        
        HUD_MB.loading("", onView: self.view)
        
//        HTTPTOOl.uploadImages(images: picImgArr) { [unowned self] json in
//            HUD_MB.dissmiss(onView: view)
//            var imgList: [String] = []
//            for jsonData in json["data"].arrayValue {
//                imgList.append(jsonData["imageUrl"].stringValue)
//            }
//            self.dataModel.imagesList = imgList
//            //保存数据
//            //self.doSaveAction_Net()
//
//        } failure: { [unowned self] error in
//            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
//        }


        
        

        
        if picImgArr.count != 0 {
            //上传图片

            HTTPTOOl.uploadImages(images: picImgArr) { [unowned self] json in
                var imgList: [String] = []
                for jsonData in json["data"].arrayValue {
                    imgList.append(jsonData["imageUrl"].stringValue)
                }
                self.dataModel.imagesList = imgList
                //保存数据
                self.doSaveAction_Net()

            } failure: { [unowned self] error in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }


        } else {
            self.doSaveAction_Net()
        }
    }



    private func doSaveAction_Net() {

        if self.dataModel.goodsCashOut == "" {
            self.dataModel.goodsCashOut = "0"
        }
        if self.dataModel.otherCashOut == "" {
            self.dataModel.otherCashOut = "0"
        }
        if self.dataModel.partTime == "" {
            self.dataModel.partTime = "0"
        }
        if self.dataModel.prePaid == "" {
            self.dataModel.prePaid = "0"
        }
        if self.dataModel.reMain == "" {
            self.dataModel.reMain = "0"
        }

        HTTPTOOl.doSaveAction(model: dataModel).subscribe(onNext: { [unowned self] (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            for model in FeeTypeResultModel.sharedInstance.dayResultList {
                if model.date == dataModel.date {
                    model.writeDay = true
                }
            }
            let nextVC = CompletedController()
            nextVC.dataModel = dataModel
            self.navigationController?.pushViewController(nextVC, animated: false)

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }



    deinit {
        print("\(self.classForCoder) 销毁")
    }

}


extension CashOutController {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 7
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 6 {
            let w = (S_W - 80) / 5

            if picImgArr.count > 4 {
                return (w * 2 + 10) + 45
            } else {
                return w + 45
            }

        }

        
        return 55
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataUploadImgCell") as! DataUploadImgCell
            cell.setCellData(picArr: picImgArr)

            cell.editeImgblock = { [unowned self] (arr) in
                self.picImgArr = arr
                self.table.reloadData()
            }

            return cell
        }


        let cell = tableView.dequeueReusableCell(withIdentifier: "DataInPutCell_H") as! DataInPutCell_H

        var content: String = ""
        if indexPath.row == 0 {
            content = dataModel.driverCashOut
        }
        if indexPath.row == 1 {
            content = dataModel.partTime
        }
        
        if indexPath.row == 2 {
            content = dataModel.goodsCashOut
        }
        if indexPath.row == 3 {
            content = dataModel.otherCashOut
        }
        if indexPath.row == 4 {
            content = dataModel.prePaid
        }
        if indexPath.row == 5 {
            content = dataModel.reMain
        }

        cell.setCellData(name1: name1Arr[indexPath.row], name2: name2Arr[indexPath.row], content: content)

        cell.editeEndBlock = { [unowned self] (msg) in
            if indexPath.row == 0 {
                self.dataModel.driverCashOut = msg
            }
            if indexPath.row == 1 {
                self.dataModel.partTime = msg
            }
            if indexPath.row == 2 {
                self.dataModel.goodsCashOut = msg
            }
            if indexPath.row == 3 {
                self.dataModel.otherCashOut = msg
            }
            if indexPath.row == 4 {
                self.dataModel.prePaid = msg
            }
            if indexPath.row == 5 {
                self.dataModel.reMain = msg
            }
        }

        return cell
    }


}
