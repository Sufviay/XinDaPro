//
//  DishCollCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/4/24.
//

import UIKit

class DishCollCell_Code: UICollectionViewCell {
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.1).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        
        view.layer.borderColor = MAINCOLOR.cgColor
        return view
    }()
    
    private let dishCodeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(16), .center)
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.addSubview(dishCodeLab)
        dishCodeLab.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(code: String, isSel: Bool) {
        dishCodeLab.text = code
        
        if isSel {
            backView.layer.borderWidth = 2
        } else {
            backView.layer.borderWidth = 0
        }
        
    }
    
}



class DishCollCell_Name: UICollectionViewCell {
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.1).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        view.layer.borderColor = MAINCOLOR.cgColor
        return view
    }()
    
    
    private let codeBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#EE7763")
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    private let dishCodeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, BFONT(15), .left)
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()

    
    private let name_C: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(15), .left)
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()
    
    private let name_E: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#888888"), SFONT(14), .left)
        lab.numberOfLines = 2
        return lab
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        
        backView.addSubview(codeBackView)
        codeBackView.snp.makeConstraints {
            $0.height.equalTo(25)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(10)
        }
        
        codeBackView.addSubview(dishCodeLab)
        dishCodeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }


        backView.addSubview(name_C)
        name_C.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(45)
        }
        
        backView.addSubview(name_E)
        name_E.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(name_C.snp.bottom).offset(5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCellData(model: DishModel, type: String, colNum: Int, isSel: Bool) {
        
        let cell_W = (UIScreen.main.bounds.width - CGFloat(colNum + 1) * 15) / CGFloat(colNum)
        let code_W = model.dishesCode.getTextWidth(BFONT(15), 20) + 25
        
        if (code_W + 30) > cell_W {
            codeBackView.snp.makeConstraints {
                $0.left.equalToSuperview().offset(15)
                $0.right.equalToSuperview().offset(-15)
                $0.top.equalToSuperview().offset(10)
                $0.height.equalTo(25)
            }
            
        } else {
            codeBackView.snp.remakeConstraints {
                $0.height.equalTo(25)
                $0.left.equalToSuperview().offset(15)
                $0.width.equalTo(code_W)
                $0.top.equalToSuperview().offset(10)
            }
        }
        
        if type == "2" {
            //只有名称
            codeBackView.isHidden = true
            
            name_C.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(15)
                $0.right.equalToSuperview().offset(-15)
                $0.top.equalToSuperview().offset(25)
            }
        }
        if type == "3" {
            //编号和名称
            codeBackView.isHidden = false
            
            name_C.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(15)
                $0.right.equalToSuperview().offset(-15)
                $0.top.equalToSuperview().offset(45)
            }
        }
        
        dishCodeLab.text = model.dishesCode
        name_C.text = model.dishesNameHk
        name_E.text = model.dishesNameEn
        
        if isSel {
            backView.layer.borderWidth = 2
        
        } else {
            backView.layer.borderWidth = 0
        }
    }
}




class DishClassifyHeader: UICollectionReusableView {
    
    
    var clickBlock: VoidBlock?
    
    private let selectBut: UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        return but
    }()
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(17), .left)
        return lab
    }()
    
    private let selectImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("zk_c")
        return img
    }()

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(selectBut)
        selectBut.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(40)
            $0.centerY.equalToSuperview()
        }
        
        titLab.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(titLab.snp.bottom)
            $0.height.equalTo(4)
        }
        
        
        addSubview(selectImg)
        selectImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-50)
        }
        
        selectBut.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }
    
    
    
    @objc private func clickAction() {
        clickBlock?("")
    }
    
    
    func setCellData(titStr: String, isShow: Bool) {
        setGroupName(titStr: titStr)
        if isShow {
            selectImg.image = LOIMG("sq")
        } else {
            selectImg.image = LOIMG("zk")
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setGroupName(titStr: String) {
        
        let info = ["00": "茶位及什項",
                    "01": "特式午餐",
                    "02": "自助餐收費",
                    "03": "自助-頭盤",
                    "04": "自助-湯",
                    "05": "自助-海鮮",
                    "06": "自助-肉",
                    "07": "自助-鐵板",
                    "08": "自助-雞",
                    "09": "自助-咖哩",
                    "10": "自助-菜豆腐",
                    "11": "自助-飯麵",
                    "12": "自助-齋頭盤",
                    "13": "自助-齋湯",
                    "14": "自助-齋主菜",
                    "15": "單點-套餐",
                    "16": "單點-頭盤",
                    "17": "單點-湯",
                    "18": "單點-龍蝦",
                    "19": "單點-蟹",
                    "20": "單點-帶子",
                    "21": "單點-魷魚",
                    "22": "單點-魚",
                    "23": "單點-雞",
                    "24": "單點-牛",
                    "25": "單點-豬",
                    "26": "單點-鴨",
                    "27": "單點-羊",
                    "28": "單點-咖哩",
                    "29": "單點-炒麵",
                    "30": "單點-炒飯",
                    "31": "單點-Side",
                    "32": "單點-齋頭盤",
                    "33": "單點-齋主菜",
                    "34": "特色烤魚",
                    "35": "厨師推薦",
                    "36": "滋補靚湯",
                    "37": "熏燒鹵味",
                    "38": "精美小菜",
                    "39": "煲仔菜",
                    "40": "海鮮食法",
                    "41": " 美味湯羮",
                    "42": "精美套餐",
                    "43": "新疆烤串",
                    "44": "麵食系列",
                    "45": "爽口涼菜",
                    "46": "煌庭特色烤魚",
                    "47": "煌庭乾鍋",
                    "48": "川菜系列",
                    "49": "青菜系列",
                    "50": "東北菜",
                    "51": "炒飯麵"]
        if info.keys.contains(titStr) {
            titLab.text = info[titStr]
        } else {
            titLab.text = titStr
        }
        
        
    }
    
    
}
