//
//  StatisticalUnfulfilledDateCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/8/24.
//

import UIKit

class StatisticalUnfulfilledDateCell: BaseTableViewCell {

    private let customerImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_krqx")
        return img
    }()

    private let customerLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Customer cancel"
        return lab
    }()

    private let customerNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()

    private let systemImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_xtqx")
        return img
    }()

    private let systemLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Business cancel "
        return lab
    }()

    private let systemNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()

    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EEEEEE")
        return view
    }()
    
    
    
    private let deImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_de")
        return img
    }()
    
    private let deLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Delivery"
        return lab
    }()
    
    private let deNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
    }()
    

    
    private let coImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_co")
        return img
    }()
    
    private let coLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Collection"
        return lab
    }()
    
    private let coNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        return lab
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

    
    private let dineImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("tj_ts")
        //img.isHidden = true
        return img
    }()
    
    private let dineLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#ADADAD"), BFONT(11), .center)
        lab.text = "Dine-in"
        //lab.isHidden = true
        return lab
    }()
    
    private let dineNumLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(18), .center)
        lab.text = "0"
        //lab.isHidden = true
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

    
    


    override func setViews() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(customerImg)
        customerImg.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.left).offset(S_W / 6)
            $0.top.equalToSuperview().offset(20)
        }

        contentView.addSubview(customerLab)
        customerLab.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalTo(customerImg)
        }

        contentView.addSubview(customerNumLab)
        customerNumLab.snp.makeConstraints {
            $0.centerX.equalTo(customerImg)
            $0.top.equalTo(customerLab.snp.bottom).offset(2)
        }

    
        contentView.addSubview(systemImg)
        systemImg.snp.makeConstraints {
            $0.centerY.equalTo(customerImg)
            $0.centerX.equalToSuperview()
        }
        
        
        contentView.addSubview(systemLab)
        systemLab.snp.makeConstraints {
            $0.centerY.equalTo(customerLab)
            $0.centerX.equalTo(systemImg)
        }

        
        contentView.addSubview(systemNumLab)
        systemNumLab.snp.makeConstraints {
            $0.centerX.equalTo(systemImg)
            $0.centerY.equalTo(customerNumLab)
        }


        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(S_W / 3)
            $0.centerY.equalTo(customerLab)
            $0.size.equalTo(CGSize(width: 0.5, height: 30))
        }
        
        
        contentView.addSubview(deImg)
        deImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.centerX.equalTo(customerImg)
        }
        
        contentView.addSubview(deLab)
        deLab.snp.makeConstraints {
            $0.centerX.equalTo(deImg)
            $0.top.equalToSuperview().offset(110)
        }
        
        contentView.addSubview(deNumLab)
        deNumLab.snp.makeConstraints {
            $0.centerX.equalTo(deImg)
            $0.top.equalTo(deLab.snp.bottom).offset(2)
        }

        
        contentView.addSubview(coImg)
        coImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(deImg)
        }
        
        contentView.addSubview(coLab)
        coLab.snp.makeConstraints {
            $0.centerY.equalTo(deLab)
            $0.centerX.equalTo(coImg)
        }
        

        contentView.addSubview(coNumLab)
        coNumLab.snp.makeConstraints {
            $0.centerX.equalTo(coImg)
            $0.centerY.equalTo(deNumLab)
        }

        
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.size.centerX.equalTo(line1)
            $0.centerY.equalTo(deLab)
        }


        contentView.addSubview(line3)
        line3.snp.makeConstraints {
            $0.size.equalTo(line1)
            $0.right.equalToSuperview().offset(-(S_W / 3))
            $0.centerY.equalTo(line2)
        }

        
        contentView.addSubview(dineImg)
        dineImg.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.right).offset(-(S_W / 6))
            $0.centerY.equalTo(deImg)
        }
        
        contentView.addSubview(dineLab)
        dineLab.snp.makeConstraints {
            $0.centerY.equalTo(deLab)
            $0.centerX.equalTo(dineImg)
        }
        
        contentView.addSubview(dineNumLab)
        dineNumLab.snp.makeConstraints {
            $0.centerX.equalTo(dineImg)
            $0.centerY.equalTo(deNumLab)
        }
        
        
        
        contentView.addSubview(appImg)
        appImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(165)
            $0.centerX.equalTo(customerImg)
        }
        
        contentView.addSubview(appLab)
        appLab.snp.makeConstraints {
            $0.centerX.equalTo(appImg)
            $0.top.equalToSuperview().offset(190)
        }

        contentView.addSubview(appNumLab)
        appNumLab.snp.makeConstraints {
            $0.centerX.equalTo(appImg)
            $0.top.equalTo(appLab.snp.bottom).offset(2)
        }

    
        contentView.addSubview(machImg)
        machImg.snp.makeConstraints {
            $0.centerY.equalTo(appImg)
            $0.centerX.equalTo(systemImg)
        }
        
        
        contentView.addSubview(machLab)
        machLab.snp.makeConstraints {
            $0.centerX.equalTo(machImg)
            $0.centerY.equalTo(appLab)
        }

        contentView.addSubview(machNumLab)
        machNumLab.snp.makeConstraints {
            $0.centerX.equalTo(machImg)
            $0.centerY.equalTo(appNumLab)
        }

        contentView.addSubview(line4)
        line4.snp.makeConstraints {
            $0.size.equalTo(line1)
            $0.centerY.equalTo(appLab)
            $0.centerX.equalTo(line1)
        }

        
        contentView.addSubview(line5)
        line5.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }


        
    }
    
    
    func setCellData(section: Int, model: ReportModel) {
        
        if section == 8 {
            
            self.customerNumLab.text = "\(model.userCancelOrderNum)"
            self.systemNumLab.text = "\(model.busiCancelOrderNum)"

            self.deNumLab.text = "\(model.unDeOrderNum)"
            self.coNumLab.text = "\(model.unCoOrderNum)"
            self.appNumLab.text = "\(model.unAppOrderNum)"
            self.machNumLab.text = "\(model.unMachOrderNum)"
            self.dineNumLab.text = "\(model.unDineOrderNum)"
            
        }
        
        
        if section == 9 {
            
            self.customerNumLab.text = "£\(D_2_STR(model.userCacnelOrderSum))"
            self.systemNumLab.text = "£\(D_2_STR(model.busiCancelOrderSum))"
            self.deNumLab.text = "£\(D_2_STR(model.unDeOrderSum))"
            self.coNumLab.text = "£\(D_2_STR(model.unCoOrderSum))"
            self.appNumLab.text = "£\(D_2_STR(model.unAppOrderSum))"
            self.machNumLab.text = "£\(D_2_STR(model.unMachOrderSum))"
            self.dineNumLab.text = "£\(D_2_STR(model.unDineOrderSum))"
            
        }
    }

}
