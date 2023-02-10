//
//  StoreIntroduceTimeCell.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/4.
//

import UIKit

class StoreIntroduceTimeCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    private var strArr: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]


    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    
    private let tagLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(14), .left)
        lab.text = "Can be delivered, can eat"
        return lab
    }()
    
    
    private let tLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Delivery hours"
        return lab
    }()
    
    private let tLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Delivery hours"
        return lab
    }()
    
    private lazy var collection1: GestureCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (S_W - 20) / 2 , height: 30)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let coll = GestureCollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.tag = 1
        coll.showsVerticalScrollIndicator = false
        coll.register(TimeCollecitonCell.self, forCellWithReuseIdentifier: "TimeCollecitonCell")
        return coll
    }()
    
    private lazy var collection2: GestureCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (S_W - 20) / 2 , height: 30)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let coll = GestureCollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .clear
        coll.tag = 2
        coll.showsVerticalScrollIndicator = false
        coll.register(TimeCollecitonCell.self, forCellWithReuseIdentifier: "TimeCollecitonCell")
        return coll
    }()

    
    
    
    

    
    override func setViews() {
        
        contentView.backgroundColor = HCOLOR("#F7F7F7")
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(tagLab)
        tagLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
        backView.addSubview(tLab1)
        tLab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(40)
        }
        
        backView.addSubview(collection1)
        collection1.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(130)
            $0.top.equalToSuperview().offset(65)
        }
    
        backView.addSubview(tLab2)
        tLab2.snp.makeConstraints {
            $0.left.equalTo(tLab1)
            $0.top.equalTo(collection1.snp.bottom)
            $0.height.equalTo(40)
        }
        
        backView.addSubview(collection2)
        collection2.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(130)
            $0.top.equalTo(collection1.snp.bottom).offset(40)
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollecitonCell", for: indexPath) as! TimeCollecitonCell
        cell.setCellData(dayStr: strArr[indexPath.row])
        return cell
    }

    
    
}


class TimeCollecitonCell: UICollectionViewCell {
    
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        return lab
    }()
    
    
    private let timeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "8:00--21:00"
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(timeLab)
        timeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(90)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(dayStr: String) {
        self.titlab.text = dayStr
    }
    
    
    
}


class SetDayTimeCell: BaseTableViewCell {

    var clickBlock: VoidBlock?

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(15), .center)
        lab.text = "Monday"
        lab.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W - 20, height: 40), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        lab.backgroundColor = HCOLOR("#EEEEEE")
        return lab
    }()
    
    private let point1: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let point2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#144DDE")
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Delivery"
        return lab
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        lab.text = "Collection"
        return lab
    }()
    
    
    private let deStartBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "00:00:00", FONTCOLOR, SFONT(15), HCOLOR("#EEEEEE"))
        return but
    }()
    
    private let deEndBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "00:00:00", FONTCOLOR, SFONT(15), HCOLOR("#EEEEEE"))
        return but
    }()
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = FONTCOLOR
        return view
    }()

    
    private let coStartBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "00:00:00", FONTCOLOR, SFONT(15), HCOLOR("#EEEEEE"))
        return but
    }()
    
    private let coEndBut: UIButton = {
        let but = UIButton()
        but.layer.cornerRadius = 6
        but.setCommentStyle(.zero, "00:00:00", FONTCOLOR, SFONT(15), HCOLOR("#EEEEEE"))
        return but
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = FONTCOLOR
        return view
    }()
    
    override func setViews() {
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
        }
        
        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        backView.addSubview(point1)
        point1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(tlab.snp.bottom).offset(25)
        }
        
        backView.addSubview(point2)
        point2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 8, height: 8))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(point1.snp.bottom).offset(35)
        }
        
        backView.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.centerY.equalTo(point1)
            $0.left.equalTo(point1.snp.right).offset(10)
        }
        
        backView.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.centerY.equalTo(point2)
            $0.left.equalTo(point2.snp.right).offset(10)
        }
        
        backView.addSubview(deEndBut)
        deEndBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.centerY.equalTo(point1)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.centerY.equalTo(point1)
            $0.right.equalTo(deEndBut.snp.left).offset(-5)
        }
        
        backView.addSubview(deStartBut)
        deStartBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.centerY.equalTo(point1)
            $0.right.equalTo(line1.snp.left).offset(-5)
        }
        
        backView.addSubview(coEndBut)
        coEndBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.centerY.equalTo(point2)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 10, height: 1))
            $0.centerY.equalTo(point2)
            $0.right.equalTo(coEndBut.snp.left).offset(-5)
        }
        
        backView.addSubview(coStartBut)
        coStartBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 90, height: 30))
            $0.centerY.equalTo(point2)
            $0.right.equalTo(line2.snp.left).offset(-5)
        }
    }
    
    
    @objc private func clickDeStartAction() {
        clickBlock?("des")
    }
    
    @objc private func clickDeEndAction() {
        clickBlock?("dee")
    }
    
    @objc private func clickCoStartAction() {
        clickBlock?("cos")
    }
    
    @objc private func clickCoEndAction() {
        clickBlock?("coe")
    }


    func setCellData(model: DaySetTimeModel) {
        self.tlab.text = model.weekDay
        self.deStartBut.setTitle(model.deliveryBegin, for: .normal)
        self.deEndBut.setTitle(model.deliveryEnd, for: .normal)
        self.coStartBut.setTitle(model.takeBegin, for: .normal)
        self.coEndBut.setTitle(model.takeEnd, for: .normal)
    }
    
    

}

