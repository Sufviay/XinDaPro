//
//  StoreSXToolView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/7/28.
//

import UIKit

class StoreSXToolView: UIView {
    
    var clickBlock: VoidStringBlock?
    
    private var filterSelected: Bool = false
    private var sortSelected: Bool = false


    private let sortBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Sort By", FONTCOLOR, SFONT(14), .clear)
        but.isHidden = true
        return but
    }()
    
    private let filterBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Filter", FONTCOLOR, SFONT(14), .clear)
        return but
    }()
    
    private let s_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jt_b")
        return img
    }()
    
    private let f_img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("jt_b")
        return img
    }()

        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addNotificationCenter()
        
        self.backgroundColor = HCOLOR("FEFEFE")
        
        self.addSubview(sortBut)
        sortBut.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
            $0.width.equalTo(90)
        }
        
        
        self.addSubview(filterBut)
        filterBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(80)
        }
        
        sortBut.addSubview(s_img)
        s_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 7, height: 5))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        }
        
        filterBut.addSubview(f_img)
        f_img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 7, height: 5))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-12)
        }
        
        sortBut.addTarget(self, action: #selector(clickSortAction), for: .touchUpInside)
        filterBut.addTarget(self, action: #selector(clickFilterAction), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 注册通知
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(centerAction(info:)), name: NSNotification.Name(rawValue: Keys.sxpxStatus), object: nil)
    }
    
    
    //MARK: - 通知中心Action
    @objc private func centerAction(info: Notification){
        let type = info.object as! String
        if type == "sx" {
            //隐藏筛选
            clickBlock?("sx_d")
            filterSelected = false
            self.filterBut.setTitleColor(FONTCOLOR, for: .normal)
            self.f_img.image = LOIMG("jt_b")

        }
        if type == "px" {
            //隐藏排序
            clickBlock?("px_d")
            sortSelected = false
            self.sortBut.setTitleColor(FONTCOLOR, for: .normal)
            self.s_img.image = LOIMG("jt_b")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Keys.sxpxStatus), object: nil)
    }
    
    
    @objc private func clickSortAction() {
        
        if sortSelected {
            //取消排序选中
            sortSelected = false
            self.sortBut.setTitleColor(FONTCOLOR, for: .normal)
            self.s_img.image = LOIMG("jt_b")
            clickBlock?("px_d")
        } else {
            
            //排序被选中
            sortSelected = true
            self.sortBut.setTitleColor(MAINCOLOR, for: .normal)
            self.s_img.image = LOIMG("jt_y")

        
            if filterSelected {
                //筛选消失 出现排序  px_o&sx_d
                clickBlock?("px_o&sx_d")
                filterSelected = false
                self.filterBut.setTitleColor(FONTCOLOR, for: .normal)
                self.f_img.image = LOIMG("jt_b")

            } else {
                clickBlock?("px_o")
            }
        }
    

    }
    
    @objc private func clickFilterAction() {
        
        if filterSelected {
            //取消筛选选中
            filterSelected = false
            self.filterBut.setTitleColor(FONTCOLOR, for: .normal)
            self.f_img.image = LOIMG("jt_b")
            clickBlock?("sx_d")
            
        } else {
            //筛选被选中
            filterSelected = true
            self.filterBut.setTitleColor(MAINCOLOR, for: .normal)
            self.f_img.image = LOIMG("jt_y")
            
            if sortSelected {
                clickBlock?("px_d&sx_o")
                sortSelected = false
                self.sortBut.setTitleColor(FONTCOLOR, for: .normal)
                self.s_img.image = LOIMG("jt_b")
            } else {
                clickBlock?("sx_o")
            }
            
        }
    }
    
    
    /**
    
    1、出现排序  px_o
    2、出现筛选  sx_o
    3、排序消失  px_d
    4、筛选消失  sx_d
    5、排序消失 出现筛选  px_d&sx_o
    6、筛选消失 出现排序  px_o&sx_d
     */
    

}
