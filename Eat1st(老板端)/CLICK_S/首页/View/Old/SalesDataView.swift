//
//  SalesDataView.swift
//  CLICK_S
//
//  Created by 肖扬 on 2021/12/22.
//

import UIKit

class SalesDataView: UIView {

    let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()
    
    private let cashMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .center)
        lab.text = "0"
        return lab
    }()
    
    private let cashLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .center)
        lab.text = "cash"
        return lab
    }()
    
    private let sLab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    private let onlineMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(15), .right)
        lab.text = "0"
        return lab
    }()
    
    private let onlineLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .center)
        lab.text = "card"
        return lab
    }()
    
    private let sLab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(10), .right)
        lab.text = "£"
        return lab
    }()
    
    
    private let totalMoney: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(20), .left)
        lab.text = "0"
        return lab
    }()
    
    let totalLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .center)
        lab.text = ""
        return lab
    }()
    
    private let sLab3: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, SFONT(15), .right)
        lab.text = "£"
        return lab
    }()
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addSubview(cashLab)
        cashLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.centerY).offset(5)
            $0.width.equalTo((S_W - 20) / 3)
        }
        
        self.addSubview(cashMoney)
        cashMoney.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.snp.centerY).offset(-5)
        }
        
        self.addSubview(sLab1)
        sLab1.snp.makeConstraints {
            $0.bottom.equalTo(cashMoney).offset(-2)
            $0.right.equalTo(cashMoney.snp.left)
        }
        
        
        self.addSubview(onlineLab)
        onlineLab.snp.makeConstraints {
            $0.left.equalTo(cashLab.snp.right)
            $0.centerY.width.equalTo(cashLab)
        }
        
        self.addSubview(onlineMoney)
        onlineMoney.snp.makeConstraints {
            $0.centerX.equalTo(onlineLab)
            $0.centerY.equalTo(cashMoney)
        }
        
        self.addSubview(sLab2)
        sLab2.snp.makeConstraints {
            $0.bottom.equalTo(onlineMoney).offset(-2)
            $0.right.equalTo(onlineMoney.snp.left)
        }
        
        self.addSubview(totalLab)
        totalLab.snp.makeConstraints {
            $0.right.equalTo(cashLab.snp.left)
            $0.centerY.width.equalTo(cashLab)
        }

        self.addSubview(totalMoney)
        totalMoney.snp.makeConstraints {
            $0.centerX.equalTo(totalLab)
            $0.centerY.equalTo(cashMoney)
        }
        
        self.addSubview(sLab3)
        sLab3.snp.makeConstraints {
            $0.bottom.equalTo(totalMoney).offset(-3)
            $0.right.equalTo(totalMoney.snp.left)
        }
        
        self.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMoneyData(t_money: String, cashMoney: String, cardMoney: String) {
        self.totalMoney.text = t_money
        self.cashMoney.text = cashMoney
        self.onlineMoney.text = cardMoney
    }

    
}
