//
//  LocationController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/29.
//

import UIKit
import GooglePlaces

class LocationController: BaseViewController, CLLocationManagerDelegate {


    private let backImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("back_img")
        return img
    }()
    
    
    private let m_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("local_mimg")
        return img
    }()
    
    private let simg1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tag_r")
        return img
    }()
    
    private let simg2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tag_p")
        return img
    }()

    private let simg3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tag_c")
        return img
    }()

    private let simg4: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tag_m")
        return img
    }()
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    
    private let localImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("loacl_noData")
        return img
    }()
    
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        let tempStr = "Let us use your location to show you\ngreat food places nearby"
        lab.attributedText = tempStr.attributedString(font: SFONT(15), textColor: FONTCOLOR, lineSpaceing: 10, wordSpaceing: 0)
        lab.textAlignment = .center
        return lab
    }()
    
    
    private let useLocationBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Use my location", .white, SFONT(15), MAINCOLOR)
        but.layer.cornerRadius = 45 / 2
        return but
    }()
    
    private let usePostCodeBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "No Thanks, use a postcode", HCOLOR("#144DDE"), SFONT(14), .clear)
        return but
    }()
    
    
    private var placesClient = GMSPlacesClient.shared()
    
    lazy var locationManager = CLLocationManager()
    
    override func setViews() {
        setUpUI()
        
        
    }
    
    func setUpUI() {
        
        self.naviBar.isHidden = true
        
        view.addSubview(backImg)
        backImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(m_img)
        m_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: R_W(72), height: SET_H(92, 72)))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(R_H(165))
        }
        
        view.addSubview(simg1)
        simg1.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-R_W(35))
            $0.top.equalToSuperview().offset(R_H(100))
            $0.width.equalTo(R_W(115))
            $0.height.equalTo(SET_H(35, 115))
        }
        
        view.addSubview(simg2)
        
        simg2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(25))
            $0.top.equalToSuperview().offset(R_H(145))
            $0.width.equalTo(R_W(125))
            $0.height.equalTo(SET_H(35, 125))
        }
        
        view.addSubview(simg3)
        simg3.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(53))
            $0.top.equalToSuperview().offset(R_H(290))
            $0.width.equalTo(R_W(90))
            $0.height.equalTo(SET_H(35, 90))
        }
        
        view.addSubview(simg4)
        simg4.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-R_W(15))
            $0.top.equalToSuperview().offset(R_H(250))
            $0.width.equalTo(R_W(95))
            $0.height.equalTo(SET_H(35, 95))
        }

        
    
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(260)
        }
        
        
        
        backView.addSubview(localImg)
        localImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 45, height: 45))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(35)
        }
        
        backView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(localImg.snp.bottom).offset(15)
        }

        backView.addSubview(useLocationBut)
        useLocationBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(45)
            $0.top.equalTo(localImg.snp.bottom).offset(75)
        }
        
        backView.addSubview(usePostCodeBut)
        usePostCodeBut.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(useLocationBut.snp.bottom).offset(10)
        }
        
        usePostCodeBut.addTarget(self, action: #selector(clickPostCodeAction), for: .touchUpInside)
        useLocationBut.addTarget(self, action: #selector(clickLocationAction), for: .touchUpInside)
    }
    
    
    @objc private func clickLocationAction() {

        //定位
        SearchPlaceManager.shared.doLocationCurrentPlace { [unowned self] (placeArr) in
            DispatchQueue.main.async {
            
                let nextVC = PostCodeSearchController()
                nextVC.placeArr = placeArr
                
                nextVC.selectedBlock = { [unowned self] (_) in
                    
                    self.navigationController?.setViewControllers([FirstController()], animated: true)

                }
                
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

 
    
    @objc private func clickPostCodeAction() {
        ///搜索地址
        SearchPlaceManager.shared.doSearchPlace { (model) in
            
            UserDefaults.standard.address = model.address
            UserDefaults.standard.postCode = model.postCode
            UserDefaults.standard.local_lng = model.lng
            UserDefaults.standard.local_lat = model.lat

            DispatchQueue.main.async {
                self.navigationController?.setViewControllers([FirstController()], animated: true)
            }
        }
    }
}
