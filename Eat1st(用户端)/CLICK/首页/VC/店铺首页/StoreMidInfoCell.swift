//
//  StoreMidInfoCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/3/16.
//

import UIKit

class StoreMidInfoCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    private var dataModel = StoreInfoModel()
    
    private var tagArr: [String] = ["beef", "fish", "mutton"]
    
    private let color1 = HCOLOR("#FEC501")
    private let color2 = HCOLOR("#FA7268")
    private let color3 = HCOLOR("#448AFF")


    private let midImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("store_bimg")
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private let logoImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = BACKCOLOR
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        return img
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(13), .left)
        lab.text = ""
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private lazy var tagcCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.register(StoreTagCell.self, forCellWithReuseIdentifier: "StoreTagCell")
        return coll
    }()
    
    
    private lazy var starView: EvaluateStarView = {
        let view = EvaluateStarView.init(frame: CGRect(x: 0, y: 0, width: 85, height: 12))
        view.isCanTap = false
        return view
    }()

    private let plCountLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(12), .left)
        lab.text = "(456)"
        return lab
    }()
    
    private let localBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("local_y"), for: .normal)
        return but
    }()
    
    private let phoneBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("phone_y"), for: .normal)
        return but
    }()
    
    private let addressLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("999999"), SFONT(12), .left)
        lab.numberOfLines = 2
        lab.lineBreakMode = .byTruncatingTail
        lab.text = ""
        return lab
    }()
    


    
    override func setViews() {
        
        
        contentView.addSubview(midImg)
        midImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    

        midImg.addSubview(logoImg)
        logoImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 60))
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-25)
        }

        
        midImg.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(15)
            $0.right.equalTo(logoImg.snp.left).offset(-10)
        }

        
        contentView.addSubview(tagcCollection)
        tagcCollection.snp.makeConstraints {
            $0.left.right.equalTo(nameLab)
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
            $0.height.equalTo(15)
        }

        midImg.addSubview(starView)
        starView.snp.makeConstraints {
            $0.left.equalTo(nameLab)
            $0.top.equalTo(tagcCollection.snp.bottom).offset(5)
            $0.size.equalTo(CGSize(width: 85, height: 12))
        }
        
        midImg.addSubview(plCountLab)
        plCountLab.snp.makeConstraints {
            $0.centerY.equalTo(starView)
            $0.left.equalTo(starView.snp.right).offset(5)
        }
        
        
        
        
        midImg.addSubview(addressLab)
        addressLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(45)
            $0.top.equalTo(starView.snp.bottom).offset(5)
            $0.right.equalToSuperview().offset(-80)
        }


        
        let line = UIView()
        line.backgroundColor = HCOLOR("#DDDDDD")
        midImg.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 1, height: 20))
            $0.centerY.equalTo(addressLab)
            $0.left.equalTo(addressLab.snp.right).offset(-15)
        }
        
        
        
        
        midImg.addSubview(localBut)
        localBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 11, height: 14))
            $0.left.equalTo(nameLab)
            $0.centerY.equalTo(addressLab)
        }

        midImg.addSubview(phoneBut)
        phoneBut.snp.makeConstraints {
            $0.size.equalTo(localBut)
            $0.centerY.equalTo(localBut)
            $0.left.equalTo(line.snp.right).offset(15)
        }


        

        phoneBut.addTarget(self, action: #selector(clickPhoneAction), for: .touchUpInside)
        localBut.addTarget(self, action: #selector(clickLocalAction), for: .touchUpInside)

    }
    
    
    @objc private func clickPhoneAction()  {
        PJCUtil.callPhone(phone: dataModel.phone)
    }
    
    @objc func clickLocalAction()  {
        PJCUtil.showLoacl(lat: Double(dataModel.lat) ?? 0, lng: Double(dataModel.lng) ?? 0)
    }

    
    
//    func setStoreTag() {
//        
//        tView.subviews.forEach { $0.removeFromSuperview() }
//        
//        ///限制的宽度
//        let A_W: CGFloat = S_W - 160
//        ///标签高度
//        let tagH: CGFloat = 14
//        ///每个标签左右以及上下的距离
//        let d_W: CGFloat = 5
//    
//        ///计算所有标签的长度
//        var all_W: CGFloat = 0
//        for str in tagArr {
//            let w = str.getTextWidth(SFONT(10), tagH) + 20
//            all_W += w
//        }
//        all_W = all_W + CGFloat((tagArr.count - 1)) * d_W
//        
//        
//        
//        if all_W < A_W {
//            
//            let d = (A_W - all_W) / 2
//            var t_W: CGFloat = 0
//            
//            //一行显示的下 标签居中显示
//            for (idx, str) in tagArr.enumerated() {
//                
//                let lab = UILabel()
//                lab.text = str
//                lab.font = SFONT(10)
//                lab.clipsToBounds = true
//                lab.layer.cornerRadius = 3
//                lab.layer.borderWidth = 1
//                lab.textAlignment = .center
//
//                //设置标签颜色
//                
//                let t = idx % 3
//                if t == 0 {
//                    lab.textColor = color1
//                    lab.layer.borderColor = color1.cgColor
//                }
//                
//                if t == 1 {
//                    lab.textColor = color2
//                    lab.layer.borderColor = color2.cgColor
//                }
//                
//                if t == 2 {
//                    lab.textColor = color3
//                    lab.layer.borderColor = color3.cgColor
//                }
//
//                
//                let strW = str.getTextWidth(SFONT(10), tagH) + 20
//                
//                tView.addSubview(lab)
//                lab.snp.makeConstraints {
//                    $0.left.equalToSuperview().offset(80 + d + (CGFloat(idx) * d_W) + t_W)
//                    $0.size.equalTo(CGSize(width: strW, height: 14))
//                    $0.centerY.equalToSuperview()
//                }
//                
//                t_W += strW
//            }
//        }
//    }
//    
    
    func setCellData(model: StoreInfoModel) {
        self.dataModel = model

        self.logoImg.sd_setImage(with: URL(string: self.dataModel.logoImg), completed: nil)
        self.nameLab.text = self.dataModel.name
        self.addressLab.text = self.dataModel.storeAddress
        self.plCountLab.text = "(\(self.dataModel.evaluateNum))"
        self.starView.setPointValue = Int(ceil(self.dataModel.star))
        
        if dataModel.tags == "" {
            self.tagArr = []
        } else {
            self.tagArr = self.dataModel.tags.components(separatedBy: "·")
        }
        
        tagcCollection.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreTagCell", for: indexPath) as! StoreTagCell
        
        cell.tagLab.text = tagArr[indexPath.item]
        
        //设置标签颜色
        let t = indexPath.item % 3
        if t == 1 {
            cell.tagLab.textColor = color1
            cell.tagLab.layer.borderColor = color1.cgColor
        }
        
        if t == 0 {
            cell.tagLab.textColor = color2
            cell.tagLab.layer.borderColor = color2.cgColor
        }
        
        if t == 2 {
            cell.tagLab.textColor = color3
            cell.tagLab.layer.borderColor = color3.cgColor
        }
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let strW = tagArr[indexPath.item].getTextWidth(SFONT(10), 15) + 20
        return CGSize(width: strW, height: 15)
        
    }
    
    
}
