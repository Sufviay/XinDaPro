//
//  OrderDetailStatusCell.swift
//  CLICK
//
//  Created by 肖扬 on 2022/5/11.
//

import UIKit

class OrderDetailStatusCell: BaseTableViewCell {

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let numberLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(17), .left)
        lab.text = "#1550515678022548934"
        return lab
    }()

    private let statusLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, BFONT(17), .left)
        lab.text = "Delivery in progress"
        return lab
    }()

    private let point1: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("progress_y")
        return img
    }()

    private let point2: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("progress_g")
        return img
    }()

    private let point3: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("progress_g")
        return img
    }()

    private let point4: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("progress_g")
        return img
    }()

    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()

    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()

    private let line3: UIView = {
        let view = UIView()
        view.backgroundColor = MAINCOLOR
        return view
    }()

    private let gitImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFit
        return img
    }()

//    private let timeLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
//        lab.text = "18:00"
//        return lab
//    }()

    private let desLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, SFONT(14), .left)
        //lab.text = ""
        return lab
    }()

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E4E4E4")
        return view
    }()

    private let sdTimeLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
        lab.text = "11:03-12:05"
        return lab
    }()

    private let tlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#999999"), SFONT(10), .left)
        //lab.text = "Estimated time"
        return lab
    }()




    override func setViews() {

        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear


        contentView.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
        }
        
        
        backView.addSubview(numberLab)
        numberLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(5)
        }
        
        

        backView.addSubview(statusLab)
        statusLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(numberLab.snp.bottom).offset(15)
        }


        backView.addSubview(point1)
        point1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 12, height: 12))
            $0.top.equalToSuperview().offset(80)
        }

        backView.addSubview(point4)
        point4.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.size.equalTo(point1)
        }

        backView.addSubview(point2)
        point2.snp.makeConstraints {
            $0.left.equalTo(point1.snp.right).offset(R_W(90))
            $0.centerY.size.equalTo(point1)
        }

        backView.addSubview(point3)
        point3.snp.makeConstraints {
            $0.centerY.size.equalTo(point1)
            $0.left.equalTo(point2.snp.right).offset(R_W(40))
        }

        backView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.centerY.equalTo(point1)
            $0.height.equalTo(1)
            $0.left.equalTo(point1.snp.right).offset(5)
            $0.right.equalTo(point2.snp.left).offset(-5)
        }

        backView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.centerY.equalTo(point1)
            $0.height.equalTo(1)
            $0.left.equalTo(point2.snp.right).offset(5)
            $0.right.equalTo(point3.snp.left).offset(-5)
        }


        backView.addSubview(line3)
        line3.snp.makeConstraints {
            $0.centerY.equalTo(point1)
            $0.height.equalTo(1)
            $0.left.equalTo(point3.snp.right).offset(5)
            $0.right.equalTo(point4.snp.left).offset(-5)
        }

        backView.addSubview(gitImg)
        gitImg.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 40))
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalToSuperview().offset(0)
        }

        backView.addSubview(desLab)
        desLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(point1.snp.bottom).offset(10)
        }

//        backView.addSubview(timeLab)
//        timeLab.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.top.equalTo(desLab.snp.bottom).offset(10)
//        }
//
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(0.5)
            $0.top.equalTo(desLab.snp.bottom).offset(10)
        }

        backView.addSubview(sdTimeLab)
        sdTimeLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(line.snp.bottom).offset(10)
        }

        backView.addSubview(tlab)
        tlab.snp.makeConstraints {
            $0.left.equalTo(sdTimeLab.snp.right).offset(15)
            $0.bottom.equalTo(sdTimeLab.snp.bottom).offset(-4)
        }


    }


    func setCellData(model: OrderDetailModel) {

        self.statusLab.text = model.statusStr
        self.numberLab.text = "#" + model.orderNum
        //self.timeLab.text = model.createTime

        
        if model.storeInfo.storeKind != "2" {
            
            self.sdTimeLab.text = "\(model.startTime)-\(model.endTime)"
            if model.timeOut {
                self.tlab.textColor = MAINCOLOR
                self.tlab.text = "Updated time"
            } else {
                self.tlab.textColor = HCOLOR("#999999")
                self.tlab.text = "Estimated time"
            }


            if model.startTime == "" {
                self.sdTimeLab.isHidden = true
                self.line.isHidden = true
                self.tlab.isHidden = true
            } else {
                self.sdTimeLab.isHidden = false
                self.line.isHidden = false
                self.tlab.isHidden = false
            }

        } else {
            self.sdTimeLab.text = model.marketDate
            self.tlab.text = ""
        }


        switch model.status {

        case .pay_wait:
            self.desLab.text = "Your order is waiting for payment"
        case .pay_ing:
            self.desLab.text = "Your order payment confirmation is in progress"
        case .pay_fail:
            self.desLab.text = "Your order payment failed"
        case .pay_success:
            self.desLab.text = "Awaiting confirmation"
        case .user_cancel:
            self.desLab.text = "Your order has been cancelled"
        case .system_cancel:
            self.desLab.text = "Your order has been cancelled"
        case .shops_cancel:
            self.desLab.text = "Your order has been cancelled"
        case .reject:
            self.desLab.text = "Your order was rejected"
        case .takeOrder:
            self.desLab.text = "Preparing your order"
        case .cooked:
            if model.type == "1" {
                //外卖
                self.desLab.text = "Preparing your order"
            } else {
                self.desLab.text = "Please come to pick up"
            }
        case .delivery_ing:
            self.desLab.text = " Your order is on the way"
        case .finished:
            self.desLab.text = "Enjoy your food!"
        case .paiDan:
            self.desLab.text = "Preparing your order"
        case .unKnown:
            break
        }


        ///1待支付,2支付中,3支付失败,4用户取消,5系统取消,6商家拒单,7支付成功,8已接单,9已出餐,10配送中,11已完成
        if model.status == .takeOrder {
            ///接单后是烹饪中
            self.point1.image = LOIMG("progress_y")
            self.point2.image = LOIMG("progress_g")
            self.point3.image = LOIMG("progress_g")
            self.point4.image = LOIMG("progress_g")

            line1.backgroundColor = HCOLOR("#C6C6C6")
            line2.backgroundColor = HCOLOR("#C6C6C6")
            line3.backgroundColor = HCOLOR("#C6C6C6")
            gitImg.image = PJCUtil.getGifImg(name: "烹饪中")
        }

        else if model.status == .cooked  {
            ///已出餐

            self.point1.image = LOIMG("progress_y")
            self.point2.image = LOIMG("progress_y")

            self.point4.image = LOIMG("progress_g")

            line1.backgroundColor = MAINCOLOR

            line3.backgroundColor = HCOLOR("#C6C6C6")
            gitImg.image = PJCUtil.getGifImg(name: "出餐")

            if model.type == "1" {
                self.point3.image = LOIMG("progress_g")
                line2.backgroundColor = HCOLOR("#C6C6C6")
            } else {
                self.point3.image = LOIMG("progress_y")
                line2.backgroundColor = MAINCOLOR
            }
        }

        else if model.status == .paiDan {
            self.point1.image = LOIMG("progress_y")
            self.point2.image = LOIMG("progress_y")

            self.point4.image = LOIMG("progress_g")

            line1.backgroundColor = MAINCOLOR

            line3.backgroundColor = HCOLOR("#C6C6C6")
            gitImg.image = PJCUtil.getGifImg(name: "出餐")

            self.point3.image = LOIMG("progress_g")
            line2.backgroundColor = HCOLOR("#C6C6C6")


        }

        else if model.status == .delivery_ing {
            ///配送中
            self.point1.image = LOIMG("progress_y")
            self.point2.image = LOIMG("progress_y")
            self.point3.image = LOIMG("progress_y")
            self.point4.image = LOIMG("progress_g")

            line1.backgroundColor = MAINCOLOR
            line2.backgroundColor = MAINCOLOR
            line3.backgroundColor = HCOLOR("#C6C6C6")

            gitImg.image = PJCUtil.getGifImg(name: "外送中")

        }

        else if model.status == .finished {
            ///已完成

            self.point1.image = LOIMG("progress_l")
            self.point2.image = LOIMG("progress_l")
            self.point3.image = LOIMG("progress_l")
            self.point4.image = LOIMG("progress_l")

            line1.backgroundColor = HCOLOR("#2ADA53")
            line2.backgroundColor = HCOLOR("#2ADA53")
            line3.backgroundColor = HCOLOR("#2ADA53")

            self.gitImg.image = PJCUtil.getGifImg(name: "已完成")

        } else {

            self.point1.image = LOIMG("progress_g")
            self.point2.image = LOIMG("progress_g")
            self.point3.image = LOIMG("progress_g")
            self.point4.image = LOIMG("progress_g")

            line1.backgroundColor = HCOLOR("#C6C6C6")
            line2.backgroundColor = HCOLOR("#C6C6C6")
            line3.backgroundColor = HCOLOR("#C6C6C6")

            gitImg.image = nil
        }
    }
}
