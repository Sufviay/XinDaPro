//
//  DeskCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/1/11.
//

import UIKit

class DeskCell: UICollectionViewCell {

    
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.1).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        
        return view
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        //这样会导致阴影设置无效
        view.layer.masksToBounds = true
        return view
    }()
    
    private let t_view: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#00D184")
        return view
    }()
    
    private let b_view: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#FAFAFA")
        return view
    }()
    
    private let desklab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(17), .left)
        lab.text = "TABLE"
        return lab
    }()
    
    private let deskNum: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(20), .left)
        lab.text = "01"
        return lab
    }()
    
    private let totallab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .left)
        lab.text = "TOTAL"
        return lab
    }()
    
    private let totalMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(17), .left)
        lab.text = "£130"
        return lab
    }()
    
    
    private let creditlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(14), .left)
        lab.text = "CREDIT"
        return lab
    }()

    
    private let creditMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(17), .left)
        lab.text = "£4"
        return lab
    }()
    
    
    private let b_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(13), .left)
        lab.text = "Order quantity"
        return lab
    }()
    
    private let b_num: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#DF1936"), BFONT(14), .left)
        lab.text = "99"
        return lab
    }()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
                
        contentView.addSubview(shadowView)
        shadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shadowView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(t_view)
        t_view.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-35)
        }
        
        backView.addSubview(b_view)
        b_view.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(t_view.snp.bottom)
        }

        t_view.addSubview(desklab)
        desklab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(30)
        }
        
        t_view.addSubview(deskNum)
        deskNum.snp.makeConstraints {
            $0.bottom.equalTo(desklab).offset(2)
            $0.left.equalTo(desklab.snp.right).offset(10)
        }
        
//        t_view.addSubview(totallab)
//        totallab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(R_W(155))
//            $0.top.equalToSuperview().offset(15)
//        }
        
        t_view.addSubview(creditlab)
        creditlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(R_W(155))
            $0.centerY.equalTo(desklab)
        }
        
//        t_view.addSubview(totalMoney)
//        totalMoney.snp.makeConstraints {
//            $0.bottom.equalTo(totallab).offset(2)
//            $0.left.equalTo(totallab.snp.right).offset(20)
//        }
        
        t_view.addSubview(creditMoney)
        creditMoney.snp.makeConstraints {
            $0.bottom.equalTo(creditlab).offset(2)
            $0.left.equalTo(creditlab.snp.right).offset(20)
        }
        
        b_view.addSubview(b_lab)
        b_lab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        b_view.addSubview(b_num)
        b_num.snp.makeConstraints {
            $0.left.equalTo(b_lab.snp.right).offset(10)
            $0.centerY.equalTo(b_lab)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(model: DeskModel) {
        
        deskNum.text = model.deskName
        creditMoney.text = "£\(D_2_STR(model.advancePrice))"
        b_num.text = String(model.workNum + model.settleNum)
        
        
        if model.deskStatus == .Empty {
            t_view.backgroundColor = .white
            b_view.backgroundColor = HCOLOR("#FAFAFA")
            desklab.textColor = HCOLOR("#FEC501")
            deskNum.textColor = HCOLOR("#000000")
            b_lab.textColor = HCOLOR("#666666")
            b_num.textColor = HCOLOR("#333333")
            
            creditlab.isHidden = true
            creditMoney.isHidden = true
        }
        
        if model.deskStatus == .Occupied {
            t_view.backgroundColor = HCOLOR("#EEEEEE")
            b_view.backgroundColor = HCOLOR("#E6E6E6")
            desklab.textColor = HCOLOR("#FFFFFF")
            deskNum.textColor = HCOLOR("#FFFFFF")
            b_lab.textColor = HCOLOR("#FFFFFF")
            b_num.textColor = HCOLOR("#FFFFFF")
            
            creditlab.isHidden = true
            creditMoney.isHidden = true
        }
        
        if model.deskStatus == .Process {
            t_view.backgroundColor = HCOLOR("#FA634D")
            b_view.backgroundColor = HCOLOR("#FAFAFA")
            desklab.textColor = HCOLOR("#FFFFFF")
            deskNum.textColor = HCOLOR("#FFFFFF")
            b_lab.textColor = HCOLOR("#666666")
            b_num.textColor = HCOLOR("#DF1936")
            
            creditlab.isHidden = false
            creditMoney.isHidden = false
        }
        
        if model.deskStatus == .Settlement {
            t_view.backgroundColor = HCOLOR("#00D184")
            b_view.backgroundColor = HCOLOR("#FAFAFA")
            desklab.textColor = HCOLOR("#FFFFFF")
            deskNum.textColor = HCOLOR("#FFFFFF")
            b_lab.textColor = HCOLOR("#666666")
            b_num.textColor = HCOLOR("#DF1936")
            
            creditlab.isHidden = false
            creditMoney.isHidden = false
        }
        
    
    }
    
    
    
}
