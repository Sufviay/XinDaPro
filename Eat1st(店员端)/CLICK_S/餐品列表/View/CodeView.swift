//
//  CodeView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/4/3.
//

import UIKit
import RxCocoa
import RxSwift

class CodeView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    
    private let bag = DisposeBag()
    
    ///所有
    var allDishes: [DishModel] = []
    
    var codeFilterBlock: VoidBlock?
    
    //是否为模糊查询方式
    private var isMoHu: Bool = false

    private let zmArr: [String] = ["A", "B", "C", "", "E", "W", "H", "S"]
    private lazy var zmColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 5
        
        let W = (S_W - 40 - 27) / 10
        layout.itemSize = CGSize(width: W, height: W)
        
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
        let W = (S_W - 40 - 27) / 10
        layout.itemSize = CGSize(width: W, height: W)
        
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
    
    
    private let bfBut: UIButton = {
        let but = UIButton()
        but.clipsToBounds = true
        but.layer.cornerRadius = 3
        let W = (S_W - 40 - 27) / 10
        let img = GRADIENTCOLOR(HCOLOR("#FAFAFA"), HCOLOR("#F1F1F1"), CGSize(width: W, height: (W * 2 + 5)))
        but.setBackgroundImage(img, for: .normal)
        but.setCommentStyle(.zero, "BF", HCOLOR("#666666"), BFONT(15), .clear)
        return but
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
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.font = BFONT(17)
        tf.textColor = HCOLOR("#666666")
        //tf.isEnabled = false

        return tf
    }()
    
    
    private let mohuBut: UIButton = {
        let but = UIButton()
        but.setTitle("Fuzzy\nSearch", for: .normal)
        but.titleLabel?.numberOfLines = 9
        but.setImage(LOIMG("mohu_close"), for: .normal)
        but.titleLabel?.font = SFONT(8)
        but.setTitleColor(HCOLOR("#666666"), for: .normal)
        but.adjustImageTitlePosition(.right)
        return but
    }()
    
    
    private let line1: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: S_W - 40, height: 0.5)
        view.drawDashLine(strokeColor: HCOLOR("#D8D8D8"), lineWidth: 0.5, lineLength: 5, lineSpacing: 5)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let W = (S_W - 40 - 27) / 10
        self.addSubview(zmColleciton)
        zmColleciton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
            $0.width.equalTo(W * 4 + 9.5)
            $0.height.equalTo(W * 2 + 5)
        }
        
        self.addSubview(szColleciton)
        szColleciton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(W)
            $0.top.equalTo(zmColleciton.snp.bottom).offset(5)
        }
        
        self.addSubview(bfBut)
        bfBut.snp.makeConstraints {
            $0.top.bottom.equalTo(zmColleciton)
            $0.width.equalTo(W)
            $0.right.equalTo(zmColleciton.snp.left).offset(-3)
        }

        self.addSubview(inputBackView)
        inputBackView.snp.makeConstraints {
            $0.top.bottom.equalTo(zmColleciton)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(bfBut.snp.left).offset(-3)
        }
        
        inputBackView.addSubview(cleanBut)
        cleanBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 30))
            $0.right.equalToSuperview().offset(0)
            $0.centerY.equalToSuperview().offset(-15)
        }
        
        inputBackView.addSubview(mohuBut)
        mohuBut.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 60, height: 30))
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview().offset(15)
        }
        
        inputBackView.addSubview(inputTF)
        inputTF.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-60)
        }
        
        self.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(0.5)
            $0.top.equalTo(szColleciton.snp.bottom).offset(10)
        }
        
        
        cleanBut.addTarget(self, action: #selector(clickCleanAction), for: .touchUpInside)
        mohuBut.addTarget(self, action: #selector(clickMoHuAction), for: .touchUpInside)
        bfBut.addTarget(self, action: #selector(clickBFAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickCleanAction() {
        //清空输入框
        inputTF.text = ""
        doScreen()
    }
    
    func cleanCode() {
        inputTF.text = ""
    }

    
    @objc private func clickMoHuAction() {
        if isMoHu {
            isMoHu = false
            mohuBut.setImage(LOIMG("mohu_close"), for: .normal)
        } else {
            isMoHu = true
            mohuBut.setImage(LOIMG("mohu_open"), for: .normal)
        }
        
        doScreen()
        
    }
    
    @objc private func clickBFAction() {
        inputTF.text?.append("BF")
        doScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return zmArr.count
        }
        if collectionView.tag == 2 {
            return szArr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyCell", for: indexPath) as! KeyCell
        if collectionView.tag == 1 {
            cell.setCellData(titStr: zmArr[indexPath.item])
        }
        if collectionView.tag == 2 {
            cell.setCellData(titStr: szArr[indexPath.item])
        }
        
        return cell
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
        
        doScreen()
    }
    
    
    
    
    private func doScreen() {
        
        var tArr: [DishModel] = []
        
        if inputTF.text ?? "" == "" {
            let dic: [String: Any] = ["key": "", "arr": tArr]
            codeFilterBlock?(dic)
            return
        }
        
        if isMoHu {
            //包含就可以
            for model in allDishes {
                if model.dishesCode.contains(inputTF.text!) {
                    tArr.append(model)
                }
            }
            
        } else {
            //必须相等
            for model in allDishes {
                if model.dishesCode == inputTF.text! {
                    tArr.append(model)
                }
            }
        }

        let dic: [String: Any] = ["key": inputTF.text!, "arr": tArr]
        codeFilterBlock?(dic)
    }


}
