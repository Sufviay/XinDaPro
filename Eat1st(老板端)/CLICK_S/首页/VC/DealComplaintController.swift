//
//  DealComplaintController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/9/4.
//

import UIKit
import RxSwift
import SwiftyJSON


class ReasonModel: NSObject {
    
    var name: String = ""
    var code: String = ""
    
    func updateModel(json: JSON) {
        self.name = json["plaintName"].stringValue
        self.code = json["plaintId"].stringValue
    }
}

class TSContentModel: NSObject {
    var content: String = ""
    var orderID: String = ""
    var tsTime: String = ""
    var clTime: String = ""
    var imgList: [String] = []
    
    
    func updateModel(json: JSON) {
        self.content = json["content"].stringValue
        self.orderID = json["orderId"].stringValue
        self.tsTime = json["createTime"].stringValue
        self.clTime = json["handleTime"].stringValue
        
        
        var tArr: [String] = []
        for jsondata in json["imageList"].arrayValue {
            tArr.append(jsondata["url"].stringValue)
        }
        self.imgList = tArr
    }
}


class DealComplaintController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, CommonToolProtocol, SDPhotoBrowserDelegate {

    
    private let bag = DisposeBag()
    
    var orderID: String = ""
    var tsName: String = "" {
        didSet {
            self.nameLab.text = tsName
        }
    }
    
    var tsPhone: String = ""

    private var dataModel = TSContentModel() {
        didSet {
            self.timeLab.text = dataModel.tsTime
            self.inputTF.text = dataModel.content
        }
    }
    
    private var dataArr: [ReasonModel] = []

    private let backView1: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var selectIdx: Int = 100
    
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(18), .left)
        lab.text = "name"
        return lab
    }()
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .right)
        lab.text = "2021-08-07"
        return lab
    }()
    
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        view.isHidden = true
        return view
    }()
    
    private lazy var picColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let W = (S_W - 120) / 4
        layout.itemSize = CGSize(width: W , height: W)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 60)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = true
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.showsVerticalScrollIndicator = false
        coll.register(PicImgCell.self, forCellWithReuseIdentifier: "PicImgCell")
        return coll
    }()
    
    
    private let inputTF: UITextView = {
        let tf = UITextView()
        tf.font = SFONT(14)
        tf.textColor = FONTCOLOR
        tf.backgroundColor = .clear
        return tf
    }()
    
    private let dealBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "To deal with", .white, SFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Need to contact users? "
        return lab
    }()
    
    private let callBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Make a phone call", MAINCOLOR, SFONT(14), .clear)
        return but
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
        tableView.register(ReasonOptionCell.self, forCellReuseIdentifier: "ReasonOptionCell")
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    
    override func setViews() {
        loadTSContent_Net()
        
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = "Dealing with complaints"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpUI() {
        view.backgroundColor = HCOLOR("F7F7F7")
        
        
        var b_H: CGFloat = 0
        if dataModel.imgList.count > 4 {
            b_H = 230 + (S_W - 120) / 4
        } else {
            b_H = 220
        }
        
        view.addSubview(backView1)
        backView1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.height.equalTo(b_H)
        }
        
        
        backView1.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(10)

        }
        
        backView1.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalTo(nameLab)
            $0.right.equalToSuperview().offset(-10)
        }
        
        backView1.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(45)
            $0.height.equalTo(1)
        }
        
        
        var c_H: CGFloat = 0
        if dataModel.imgList.count > 4 {
            c_H = (S_W - 120) / 2 + 10
        } else if (dataModel.imgList.count == 0) {
            c_H = 0
        } else {
            c_H = (S_W - 120) / 4
        }
        
        backView1.addSubview(picColleciton)
        picColleciton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-60)
            $0.top.equalToSuperview().offset(65)
            $0.height.equalTo(c_H)
        }
        
        backView1.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-20)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(picColleciton.snp.bottom).offset(15)
        }
        
        view.addSubview(dealBut)
        dealBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(45)
        }
        
        view.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(50))
            $0.bottom.equalTo(dealBut.snp.top).offset(-10)
        }
        
        view.addSubview(callBut)
        callBut.snp.makeConstraints {
            $0.left.equalTo(tlab.snp.right)
            $0.centerY.equalTo(tlab)
        }
                
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalTo(backView1)
            $0.top.equalTo(backView1.snp.bottom).offset(10)
            $0.bottom.equalTo(dealBut.snp.top).offset(-60)
        }
        
        callBut.addTarget(self, action: #selector(clickCallAction), for: .touchUpInside)
        dealBut.addTarget(self, action: #selector(clickDealAction), for: .touchUpInside)
        
    }
    
    
    @objc func clickDealAction() {
        if selectIdx == 100 {
            HUD_MB.showWarnig("Please select", onView: self.view)
            return
        }
        dealAction_Net()
    }
    
    @objc func clickCallAction() {
        
        PJCUtil.callPhone(phone: tsPhone)
        
    }
    
    //MARK: - 网络请求
    
    func loadTSContent_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.loadComplainContent(orderId: orderID).subscribe(onNext: { (json) in

            let model = TSContentModel()
            model.updateModel(json: json["data"])
            self.dataModel = model
            self.loadTSDealContent_Net()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    private func loadTSDealContent_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.getComplaintDealContent().subscribe(onNext: { (json) in
            HUD_MB.dissmiss(onView: self.view)
            
            var tArr: [ReasonModel] = []
            for jsondata in json["data"].arrayValue {
                let model = ReasonModel()
                model.updateModel(json: jsondata)
                tArr.append(model)
            }
            self.dataArr = tArr
            self.setUpUI()
            
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
    
    private func dealAction_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.dealComplaintAction(orderID: orderID, code: dataArr[selectIdx].code).subscribe(onNext: { (json) in
            HUD_MB.showSuccess("", onView: self.view)
            DispatchQueue.main.after(time: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }

}

extension DealComplaintController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonOptionCell") as! ReasonOptionCell
        let select = selectIdx == indexPath.row ? true : false
        cell.setCellData(str: dataArr[indexPath.row].name, selected: select)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectIdx == indexPath.row {
            selectIdx = 100
        } else {
            selectIdx = indexPath.row
        }
        tableView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.imgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicImgCell", for: indexPath) as! PicImgCell
        cell.picImg.sd_setImage(with: URL(string: dataModel.imgList[indexPath.item]), completed: nil)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //放大图片
        showImage(collectionView, dataModel.imgList.count, indexPath.item)
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return UIImage()
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        return URL(string: dataModel.imgList[index])
    }

    
    
    
}



class PicImgCell: UICollectionViewCell {
    
    let picImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HOLDCOLOR
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
