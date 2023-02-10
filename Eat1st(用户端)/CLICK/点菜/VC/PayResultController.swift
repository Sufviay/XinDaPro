//
//  PayResultController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/12/20.
//

import UIKit

class PayResultController: BaseViewController {

    
    var isList: Bool = false
    
    var orderID: String = ""

    private let img: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("success-1")
        return img
    }()
    
    private let t_lab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#666666"), BFONT(17), .center)
        lab.text = "Order success"
        return lab
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "confirm", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()
    
    override func setNavi() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    

    override func setViews() {
        
        self.naviBar.isHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(img)
        img.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 156, height: 150))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(R_H(150))
        }
        
        view.addSubview(t_lab)
        t_lab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(img.snp.bottom).offset(15)
        }

        
        view.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-R_H(120))
            $0.size.equalTo(CGSize(width: 205, height: 45))
        }
        
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        
        
    }
    
    @objc private func clickConfirmAction() {
        //跳转到订单详情页面
        var vcs: [UIViewController] = self.navigationController!.viewControllers
        let count = vcs.count
        vcs.remove(at: count - 1)
        
        let t_count = vcs.count
        vcs.remove(at: t_count - 1)
        
        if !isList {
            let orderVC = OrderListController()
            vcs += [orderVC]
        }
        
        let orderDetailVC = OrderDetailController()
        orderDetailVC.orderID = self.orderID
        vcs += [orderDetailVC]
        
        self.navigationController?.setViewControllers(vcs, animated: true)

    }

}
