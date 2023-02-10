//
//  EvaluateController.swift
//  CLICK
//
//  Created by 肖扬 on 2021/9/3.
//

import UIKit
import RxSwift

class EvaluateController: BaseViewController, UITextViewDelegate {

    
    ///是否从列表页进来的
    var islist: Bool = true
    
    private let bag = DisposeBag()
    
    ///订单ID
    var orderID: String = ""
    
    ///订单类型  1：外卖 2：自取)
    var orderType: String = ""

    ///菜品评星
    private var cpCount: Int = 0
    ///服务评星
    private var fwCount: Int = 0
    ///配送评星
    private var psCount: Int = 0
    ///评价内容
    private var reviewContent: String = ""
    
    
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
        // 阴影偏移，默认(0, -3)
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        // 阴影透明度，默认0
        view.layer.shadowOpacity = 1
        // 阴影半径，默认3
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let disNameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#333333"), BFONT(14), .left)
        lab.text = "Display name:"
        return lab
    }()
    
    private let tfBackView: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#F7F7F7")
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let nameTF: UITextField = {
        let tf = UITextField()
        tf.textColor = FONTCOLOR
        tf.font = SFONT(14)
        tf.placeholder = "Name"
        tf.text = UserDefaults.standard.userName
        return tf
    }()
    
    private let submitBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Submit", .white, SFONT(14), MAINCOLOR)
        but.layer.cornerRadius = 10
        return but
    }()


    private lazy var cpView: ReviewStarView = {
        let view = ReviewStarView()
        view.setData(titStr: "Are you satisfied with our food?")
        view.clickStarBlock = { [unowned self] (star) in
            self.cpCount = star as! Int
        }
        return view
    }()
    
    private lazy var fwView: ReviewStarView = {
        let view = ReviewStarView()
        view.setData(titStr: "Are you satisfied with our service?")
        view.clickStarBlock = { [unowned self] (star) in
            self.fwCount = star as! Int
        }

        return view
    }()
    
    private lazy var psView: ReviewStarTFView = {
        let view = ReviewStarTFView()
        view.type = self.orderType
        
        view.clickStarBlock = { [unowned self] (star) in
            self.psCount = star as! Int
        }

        view.inputBlock = { [unowned self] (content) in
            self.reviewContent = content as! String
        }
        
        return view
    }()
    
    
    
    override func setViews() {
        setUpUI()
    }
    
    override func setNavi() {
        self.naviBar.headerTitle = "Review"
        self.naviBar.leftImg = LOIMG("nav_back")
        self.naviBar.rightBut.isHidden = true
    }

    override func clickLeftButAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func setUpUI() {
        
        view.backgroundColor = .white
        
        let line = UIView()
        line.backgroundColor = HCOLOR("#F7F7F7")
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(10)
            $0.top.equalTo(naviBar.snp.bottom)
        }
        
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(line.snp.bottom).offset(20)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(350)
        }
        
        backView.addSubview(disNameLab)
        disNameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(25)
        }
        
        backView.addSubview(tfBackView)
        tfBackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(130)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(30)
            $0.centerY.equalTo(disNameLab)
        }
        
        tfBackView.addSubview(nameTF)
        nameTF.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        
        backView.addSubview(cpView)
        cpView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(60)
            $0.height.equalTo(50)
        }
        

        backView.addSubview(fwView)
        fwView.snp.makeConstraints {
            $0.left.right.height.equalTo(cpView)
            $0.top.equalTo(cpView.snp.bottom).offset(0)
        }
        
        
    
        backView.addSubview(psView)
        psView.snp.makeConstraints {
            $0.left.right.equalTo(cpView)
            $0.top.equalTo(fwView.snp.bottom).offset(0)
            $0.height.equalTo(170)
        }
        
        
        view.addSubview(submitBut)
        submitBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(45)
        }
        
        submitBut.addTarget(self, action: #selector(clickSubmitAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickSubmitAction() {
        
        if nameTF.text ?? "" == "" {
            HUD_MB.showWarnig("Please fill in name!", onView: view)
            return
        }
        
        if cpCount == 0 {
            HUD_MB.showWarnig("Please rate our food!", onView: view)
            return
        }
        
        if fwCount == 0 {
            HUD_MB.showWarnig("Please rate our service!", onView: view)
            return
        }
        
        if psCount == 0 {
            HUD_MB.showWarnig("Please rate our delivery/pickup!", onView: view)
            return
        }
        
//        if reviewContent == "" {
//            HUD_MB.showWarnig("Please fill in the content!", onView: view)
//            return
//        }

        self.evaluateAction_Net()
    }
    
    
    //MARK: - 网络请求
    private func evaluateAction_Net() {
        HUD_MB.loading("", onView: view)
        HTTPTOOl.orderEvalutate(content: reviewContent, orderID: orderID, psStar: psCount, cpStar: cpCount, fwStar: fwCount, nickName: nameTF.text ?? "").subscribe(onNext: { (json) in
            HUD_MB.showSuccess("Success!", onView: self.view)
            DispatchQueue.main.after(time: .now() + 1) {

//                if self.islist {
                    self.navigationController?.popViewController(animated: true)
//                } else {
//                    let vcs = self.navigationController!.viewControllers
//                    let count = vcs.count
//                    self.navigationController?.viewControllers.remove(at: count - 2)
//                    self.navigationController?.popViewController(animated: true)
//                }
            }

        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
        }).disposed(by: self.bag)
    }
    
}
