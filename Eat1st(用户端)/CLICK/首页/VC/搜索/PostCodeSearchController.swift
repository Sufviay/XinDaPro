//
//  PostCodeSearchController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/27.
//

import UIKit
import GooglePlaces

class PostCodeSearchController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedBlock: VoidBlock?

    
    var placeArr: [PlaceModel] = []
    
    private var rowNum: Int = 0

    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        return view
    }()
    
    
    private let tLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), SFONT(14), .center)
        lab.text = "Not seeing your address?"
        return lab
    }()
    
    private let postCodeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Use a postcode", MAINCOLOR, SFONT(14), .clear)
        return but
    }()
        
    
    override func setViews() {
        setUpUI()
    }
    
    override func setNavi() {
        self.naviBar.headerBackColor = MAINCOLOR
        self.naviBar.headerTitle = "Current Place"
        self.naviBar.headerTitleColor = .white
        self.naviBar.leftImg = LOIMG("nav_back_w")
    }
    
    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
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
        tableView.register(SearchAddressTableCell.self, forCellReuseIdentifier: "SearchAddressTableCell")
        return tableView
    }()
    
    
    
    func setUpUI() {
        
        
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(naviBar.snp.bottom)
            $0.height.equalTo(7)
        }
    
    
        
        view.addSubview(tLab)
        tLab.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        view.addSubview(postCodeBut)
        postCodeBut.snp.makeConstraints {
            $0.left.equalTo(tLab.snp.right).offset(3)
            $0.centerY.equalTo(tLab)
        }
        
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(tLab.snp.top).offset(-15)
            $0.top.equalTo(line.snp.bottom)
        }
        
        postCodeBut.addTarget(self, action: #selector(clickUsePostCodeAction), for: .touchUpInside)
        
    }
    

    @objc func clickUsePostCodeAction() {
        
        SearchPlaceManager.shared.doSearchPlace { (model) in
            UserDefaults.standard.address = model.address
            UserDefaults.standard.postCode = model.postCode
            UserDefaults.standard.local_lng = model.lng
            UserDefaults.standard.local_lat = model.lat
            self.navigationController?.setViewControllers([FirstController()], animated: true)
        }
    }
}


extension PostCodeSearchController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let address = placeArr[indexPath.row].address
        let h = address.getTextHeigh(SFONT(12), S_W - 50) + 40 + 15
        return h
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAddressTableCell") as! SearchAddressTableCell
        cell.setCellData(model: placeArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ///选地址 然后请求地址详情
            
        let model = placeArr[indexPath.row]



        let placeFields1: GMSPlaceField = [.addressComponents, GMSPlaceField.types]
        GMSPlacesClient.shared().fetchPlace(fromPlaceID: model.placeID, placeFields: placeFields1, sessionToken: nil) { place, error in
            
            if error != nil {
                HUD_MB.showError(error!.localizedDescription, onView: PJCUtil.getWindowView())
                return
            }
            
            print(place?.addressComponents! as Any)
            let arr = place!.addressComponents!
            
            
            for a in arr {
                if a.types.contains("postal_code")  {
                    UserDefaults.standard.local_lat = model.lat
                    UserDefaults.standard.local_lng = model.lng
                    UserDefaults.standard.postCode = a.name
                    UserDefaults.standard.address = model.address
                    break                    
                }
            }
            
            self.selectedBlock?("")
            self.navigationController?.popViewController(animated: true)
        }
    }
}

