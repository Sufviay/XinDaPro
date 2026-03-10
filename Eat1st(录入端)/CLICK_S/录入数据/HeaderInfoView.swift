//
//  HeaderInfoView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/22.
//

import UIKit

class HeaderInfoView: UIView {
    
    
    
    var dataModel = DayDataModel() {
        didSet {
            self.dateLab.text = dataModel.date
                        
        }
    }
    
    
    private lazy var dateView: SelectDateView = {
        let view = SelectDateView()
        view.selectBlock = { [unowned self] par in
            let info = par as! [String: Any]
            let idx = info["idx"] as! Int
            let date = info["date"] as! String
            
            if date != self.dataModel.date {
                
                FeeTypeResultModel.sharedInstance.cleanPlatData()
                
                //切换日期了
                let curDateModel = FeeTypeResultModel.sharedInstance.dayResultList[idx]
                UserDefaults.standard.stepCount = curDateModel.stepCount
                
                let subModel = DayDataModel()
                subModel.date = curDateModel.date
                subModel.nameList = curDateModel.nameList
                subModel.dayList = FeeTypeResultModel.sharedInstance.platTypeList

                
                if curDateModel.saturday {
                    //是周六
                    if curDateModel.writeDay {
                        // 已完成
                        let completeVC = CompletedController()
                        completeVC.dataModel = subModel
                        PJCUtil.currentVC()?.navigationController?.setViewControllers([completeVC], animated: false)
                    } else {
                        // 未填写
                    
                        let firstVC = SaturdayController1()
                        firstVC.dataModel = subModel
                        firstVC.code = subModel.nameList[0]
                        PJCUtil.currentVC()?.navigationController?.setViewControllers([firstVC], animated: false)
                    }
                    
                } else {
                    //不是周六
                    
                    if curDateModel.writeDay {
                        // 已完成
                        let completeVC = CompletedController()
                        completeVC.dataModel = subModel
                        PJCUtil.currentVC()?.navigationController?.setViewControllers([completeVC], animated: false)
                    } else {
                        //未填写
                        
                        if FeeTypeResultModel.sharedInstance.platTypeList.count == 0 {
                            //let firstVC = CashInController()
                            let firstVC = CashOutController()
                            firstVC.dataModel = subModel
                            firstVC.code = subModel.nameList[0]
                            PJCUtil.currentVC()?.navigationController?.setViewControllers([firstVC], animated: false)
                        } else {
                            let firstVC = JustEatsController()
                            firstVC.dataModel = subModel
                            firstVC.code = subModel.nameList[0]
                            PJCUtil.currentVC()?.navigationController?.setViewControllers([firstVC], animated: false)
                        }
                    }
                }
                
                
            }
            
            
        }
        
        return view
    }()
    
    private var stepCount: Int = UserDefaults.standard.stepCount ?? 0
    
    
    var curStep: Int = 3 {
        didSet {
            self.setLines()
            self.stepNumLab.text = "\(curStep + 1)/\(stepCount)"
            
        }
    }
    
//
//    private let tlab1: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), SFONT(17), .left)
//        lab.text = "Code"
//        return lab
//    }()
    
    private let codeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(17), .left)
        lab.text = UserDefaults.standard.userName ?? ""
        return lab
    }()
    
    
    private let dateBut: UIButton = {
        let but = UIButton()
        return but
    }()
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#A8853A"), BFONT(14), .right)
        return lab
    }()
    
    
    private let xlImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xl 1")
        img.isUserInteractionEnabled = false
        return img
    }()
    
    private let tlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#819CFF"), SFONT(8), .left)
        lab.text = "Step"
        return lab

    }()
    
    
    private let stepNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#819CFF"), SFONT(8), .right)
        return lab
    }()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 7
        
        self.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
        // 阴影偏移，默认(0, -3)
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        // 阴影透明度，默认0
        self.layer.shadowOpacity = 1
        // 阴影半径，默认3
        self.layer.shadowRadius = 2
        
        self.backgroundColor = .white
        
        
//        self.addSubview(tlab1)
//        tlab1.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(25)
//            $0.top.equalToSuperview().offset(20)
//        }
        
        self.addSubview(codeLab)
        codeLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(25)
//            $0.centerY.equalTo(tlab1)
//            $0.left.equalTo(tlab1.snp.right).offset(35)
        }
        
        

        
        self.addSubview(dateBut)
        dateBut.snp.makeConstraints {
            $0.centerY.equalTo(codeLab)
            $0.height.equalTo(40)
            $0.width.equalTo(120)
            $0.right.equalToSuperview().offset(-25)
        }
        
        
        dateBut.addSubview(xlImg)
        xlImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 7, height: 5))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        dateBut.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
        

        
        
        self.addSubview(tlab2)
        tlab2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(50)
        }
        
        
        self.addSubview(stepNumLab)
        stepNumLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-25)
        }

        dateBut.addTarget(self, action: #selector(clickDateBut), for: .touchUpInside)
        
    }
    
    
    func setLines() {
                
        let line_S: CGFloat = 7
        
        let line_W = (S_W - 70 - CGFloat(stepCount - 1) * line_S) / CGFloat(stepCount)
        
        for i in 0..<stepCount {
            
            let line = UIView()
            line.layer.cornerRadius = 1.5
            if i <= curStep {
                line.backgroundColor = HCOLOR("#465DFD")
            } else {
                line.backgroundColor = HCOLOR("#DAE1FB")
            }
            
            let framex: CGFloat = 25 + line_W * CGFloat(i) + line_S * CGFloat(i)
            
            line.frame = CGRect(x: framex, y: 62, width: line_W, height: 3)
            
            self.addSubview(line)
        
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clickDateBut() {
        ///点击切换日期
        dateView.appearAction()
        
    }

        
}




class CompleteHeaderView: UIView {
    
    var dataModel = DayDataModel() {
        didSet {
            self.dateLab.text = dataModel.date
                        
        }
    }
    
    
    private let codeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(17), .left)
        lab.text = UserDefaults.standard.userName ?? ""
        return lab
    }()
    
    private let dateBut: UIButton = {
        let but = UIButton()
        return but
    }()
    
    private let dateLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#A8853A"), BFONT(14), .right)
        return lab
    }()
    
    
    private let xlImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("xl 1")
        img.isUserInteractionEnabled = false
        return img
    }()
    
    
    
    private lazy var dateView: SelectDateView = {
        let view = SelectDateView()
        view.selectBlock = { [unowned self] par in
            let info = par as! [String: Any]
            let idx = info["idx"] as! Int
            let date = info["date"] as! String
            
            if date != self.dataModel.date {
                
                FeeTypeResultModel.sharedInstance.cleanPlatData()
                
                //切换日期了
                let curDateModel = FeeTypeResultModel.sharedInstance.dayResultList[idx]
                UserDefaults.standard.stepCount = curDateModel.stepCount
                
                
                let subModel = DayDataModel()
                subModel.date = curDateModel.date
                subModel.nameList = curDateModel.nameList
                subModel.dayList = FeeTypeResultModel.sharedInstance.platTypeList
                
                if curDateModel.saturday {
                    //是周六
                    if curDateModel.writeDay {
                        // 已完成
                        let completeVC = CompletedController()
                        completeVC.dataModel = subModel
                        PJCUtil.currentVC()?.navigationController?.setViewControllers([completeVC], animated: false)
                    } else {
                        // 未填写
                        let firstVC = SaturdayController1()
                        firstVC.dataModel = subModel
                        firstVC.code = subModel.nameList[0]
                        PJCUtil.currentVC()?.navigationController?.setViewControllers([firstVC], animated: false)
                    }
                    
                } else {
                    //不是周六
                    
                    if curDateModel.writeDay {
                        // 已完成
                        let completeVC = CompletedController()
                        completeVC.dataModel = subModel
                        PJCUtil.currentVC()?.navigationController?.setViewControllers([completeVC], animated: false)
                    } else {
                        //未填写

                        if FeeTypeResultModel.sharedInstance.platTypeList.count == 0 {
                            //let firstVC = CashInController()
                            let firstVC = CashOutController()
                            firstVC.dataModel = subModel
                            firstVC.code = subModel.nameList[0]
                            PJCUtil.currentVC()?.navigationController?.setViewControllers([firstVC], animated: false)
                        } else {
                            let firstVC = JustEatsController()
                            firstVC.dataModel = subModel
                            firstVC.code = subModel.nameList[0]
                            PJCUtil.currentVC()?.navigationController?.setViewControllers([firstVC], animated: false)
                        }
                    }
                }
                
                
            }
            
            
        }
        
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 7
        
        self.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
        // 阴影偏移，默认(0, -3)
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        // 阴影透明度，默认0
        self.layer.shadowOpacity = 1
        // 阴影半径，默认3
        self.layer.shadowRadius = 2
        
        self.backgroundColor = .white

        
        self.addSubview(codeLab)
        codeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
            //$0.left.equalTo(tlab1.snp.right).offset(35)
        }
        
        self.addSubview(dateBut)
        dateBut.snp.makeConstraints {
            $0.centerY.equalTo(codeLab)
            $0.height.equalTo(40)
            $0.width.equalTo(120)
            $0.right.equalToSuperview().offset(-25)
        }
        
        
        dateBut.addSubview(xlImg)
        xlImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 7, height: 5))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        dateBut.addSubview(dateLab)
        dateLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
        
        dateBut.addTarget(self, action: #selector(clickDateBut), for: .touchUpInside)

        
    }
    
    
    @objc private func clickDateBut() {
        ///点击切换日期
        dateView.appearAction()
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
