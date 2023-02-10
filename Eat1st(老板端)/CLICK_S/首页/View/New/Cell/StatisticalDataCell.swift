//
//  StatisticalDataCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/30.
//

import UIKit

class StatisticalDataCell: BaseTableViewCell {

    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()


    private let line4: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    private let line5: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    private let cashImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_cash")
        return img
    }()
    
    private let posImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_pos")
        return img
    }()

    private let cardImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_card")
        return img
    }()
    
    
    private let cashNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    
    private let posNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    
    private let cardNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()


    
    private let cashLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Cash"
        return lab
    }()
    
    private let posLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Pos"
        return lab
    }()
    
    private let cardLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Card"
        return lab
    }()

    
    private let deImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_de")
        return img
    }()
    
    private let deNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Delivery"
        return lab
    }()

    
    private let coImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_co")
        return img
    }()
    
    private let coNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Collection"
        return lab
    }()
    
    
    private let appImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_app")
        return img
    }()
    
    private let appNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    
    private let appLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "From App"
        return lab
    }()
    

    private let machImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_mach")
        return img
    }()
    
    private let machNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    
    private let machLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "From machine"
        return lab
    }()

    
    
    


    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(S_W / 3)
            $0.top.equalToSuperview().offset(30)
            $0.size.equalTo(CGSize(width: 1, height: 30))
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-(S_W / 3))
            $0.top.equalToSuperview().offset(25)
            $0.size.equalTo(line1)
        }
        
        contentView.addSubview(cashImg)
        cashImg.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.left).offset(S_W / 6)
            $0.top.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(posImg)
        posImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(cashImg)
        }
        
        contentView.addSubview(cardImg)
        cardImg.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.right).offset(-(S_W / 6))
            $0.centerY.equalTo(cashImg)
        }
        
        contentView.addSubview(cashNumLab)
        cashNumLab.snp.makeConstraints {
            $0.centerX.equalTo(cashImg)
            $0.top.equalToSuperview().offset(40)
        }
        
        contentView.addSubview(posNumLab)
        posNumLab.snp.makeConstraints {
            $0.centerX.equalTo(posImg)
            $0.centerY.equalTo(cashNumLab)
        }
        
        contentView.addSubview(cardNumLab)
        cardNumLab.snp.makeConstraints {
            $0.centerX.equalTo(cardImg)
            $0.centerY.equalTo(cashNumLab)
        }
        
        contentView.addSubview(cashLab)
        cashLab.snp.makeConstraints {
            $0.top.equalTo(cashNumLab.snp.bottom).offset(2)
            $0.centerX.equalTo(cashImg)
        }
        
        contentView.addSubview(posLab)
        posLab.snp.makeConstraints {
            $0.centerY.equalTo(cashLab)
            $0.centerX.equalTo(posImg)
        }
        
        contentView.addSubview(cardLab)
        cardLab.snp.makeConstraints {
            $0.centerY.equalTo(cashLab)
            $0.centerX.equalTo(cardImg)
        }

        contentView.addSubview(deImg)
        deImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.centerX.equalTo(contentView.snp.left).offset(S_W / 4)
        }
        
        contentView.addSubview(coImg)
        coImg.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.right).offset(-(S_W / 4))
            $0.centerY.equalTo(deImg)
        }
        
        contentView.addSubview(deNumLab)
        deNumLab.snp.makeConstraints {
            $0.centerX.equalTo(deImg)
            $0.top.equalToSuperview().offset(110)
        }
        
        contentView.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.top.equalTo(deNumLab.snp.bottom).offset(2)
            $0.centerX.equalTo(deImg)
        }
        
        contentView.addSubview(coNumLab)
        coNumLab.snp.makeConstraints {
            $0.centerX.equalTo(coImg)
            $0.centerY.equalTo(deNumLab)
        }
        
        contentView.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.centerY.equalTo(deLab)
            $0.centerX.equalTo(coImg)
        }
        
        contentView.addSubview(line3)
        line3.snp.makeConstraints {
            $0.size.equalTo(line1)
            $0.centerY.equalTo(deNumLab)
            $0.centerX.equalToSuperview()
        }
        
        
        contentView.addSubview(appImg)
        appImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(165)
            $0.centerX.equalTo(deImg)
        }
        
        contentView.addSubview(appNumLab)
        appNumLab.snp.makeConstraints {
            $0.centerX.equalTo(appImg)
            $0.top.equalToSuperview().offset(190)
        }
        
        contentView.addSubview(appLab)
        appLab.snp.makeConstraints {
            $0.centerX.equalTo(appImg)
            $0.top.equalTo(appNumLab.snp.bottom).offset(2)
        }
        
        
        contentView.addSubview(machImg)
        machImg.snp.makeConstraints {
            $0.centerY.equalTo(appImg)
            $0.centerX.equalTo(coImg)
        }
        
        contentView.addSubview(machNumLab)
        machNumLab.snp.makeConstraints {
            $0.centerX.equalTo(machImg)
            $0.centerY.equalTo(appNumLab)
        }
        
        contentView.addSubview(machLab)
        machLab.snp.makeConstraints {
            $0.centerX.equalTo(machImg)
            $0.centerY.equalTo(appLab)
        }
        
        
        contentView.addSubview(line4)
        line4.snp.makeConstraints {
            $0.size.equalTo(line1)
            $0.centerY.equalTo(appNumLab)
            $0.centerX.equalToSuperview()
        }

        
        contentView.addSubview(line5)
        line5.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
    
    
    func setCellData(section: Int, model: ReportModel) {
        
        if section == 5 {
            
            self.cashNumLab.text = "\(model.cashOrderNum_All)"
            self.posNumLab.text = "\(model.posOrderNum_All)"
            self.cardNumLab.text = "\(model.cardOrderNum_All)"
            self.deNumLab.text = "\(model.deOrderNum)"
            self.coNumLab.text = "\(model.coOrderNum)"
            self.appNumLab.text = "\(model.appOrderNum)"
            self.machNumLab.text = "\(model.machOrderNum)"
            
        }
        
        if section == 6 {
            
            self.cashNumLab.text = "£ \(D_2_STR(model.cashOrderSum_All))"
            self.posNumLab.text = "£ \(D_2_STR(model.posOrderSum_All))"
            self.cardNumLab.text = "£ \(D_2_STR(model.cardOrderSum_All))"
            self.deNumLab.text = "£ \(D_2_STR(model.deOrderSum))"
            self.coNumLab.text = "£ \(D_2_STR(model.coOrderSum))"
            self.appNumLab.text = "£ \(D_2_STR(model.appOrderSum))"
            self.machNumLab.text = "£ \(D_2_STR(model.machOrderSum))"
            
        }
        

    }
    
}
