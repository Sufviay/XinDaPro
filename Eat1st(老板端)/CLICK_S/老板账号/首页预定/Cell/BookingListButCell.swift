//
//  BookingListButCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit

class BookingListButCell: BaseTableViewCell {
    
    
    var clickRejectBlock: VoidBlock?
    var clickConfirmBlock: VoidBlock?
    
    var clickCancelBlock: VoidBlock?
    var clickReconfirmBlock: VoidBlock?
    var clickCheckInBlock: VoidBlock?
    
    
    private let rejectBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Reject", HCOLOR("#465DFD"), BFONT(14), .white)
        but.layer.cornerRadius = 14
        but.layer.borderWidth = 2
        but.layer.borderColor = HCOLOR("#465DFD").cgColor
        return but
    }()
    
    private let cancelBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Cancel", HCOLOR("#465DFD"), BFONT(14), .white)
        but.layer.cornerRadius = 14
        but.layer.borderWidth = 2
        but.layer.borderColor = HCOLOR("#465DFD").cgColor
        return but
    }()
    
    private let confirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "confirm", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()
    
    
    private let reconfirmBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Reconfirm", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()
    
    private let checkInBut: UIButton = {
        let but = UIButton()
        but.setCommentStyle(.zero, "Check In", .white, BFONT(14), HCOLOR("#465DFD"))
        but.layer.cornerRadius = 14
        return but
    }()

    

    override func setViews() {
        
        contentView.addSubview(rejectBut)
        rejectBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-25)
            $0.right.equalTo(contentView.snp.centerX).offset(-5)
            $0.top.equalToSuperview()
        }
        
        
        contentView.addSubview(confirmBut)
        confirmBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-25)
            $0.left.equalTo(contentView.snp.centerX).offset(5)
            $0.top.equalToSuperview()
        }
        
        
        contentView.addSubview(cancelBut)
        cancelBut.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-25)
            $0.right.equalTo(contentView.snp.centerX).offset(-5)
            $0.top.equalToSuperview()
        }
        
        contentView.addSubview(checkInBut)
        checkInBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-25)
            $0.left.equalTo(contentView.snp.centerX).offset(5)
            $0.top.equalToSuperview()
        }

        
        
        contentView.addSubview(reconfirmBut)
        reconfirmBut.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-25)
            $0.left.equalTo(contentView.snp.centerX).offset(5)
            $0.top.equalToSuperview()
        }

        
        
        rejectBut.addTarget(self, action: #selector(clickRejectAction), for: .touchUpInside)
        cancelBut.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        confirmBut.addTarget(self, action: #selector(clickConfirmAction), for: .touchUpInside)
        reconfirmBut.addTarget(self, action: #selector(clickReconfirmAction), for: .touchUpInside)
        checkInBut.addTarget(self, action: #selector(clickCheckInAction), for: .touchUpInside)
    }
    
    
    @objc private func clickRejectAction() {
        clickRejectBlock?("")
    }
    
    @objc private func clickConfirmAction() {
        clickConfirmBlock?("")
    }
    
    @objc private func clickCancelAction() {
        clickCancelBlock?("")
    }
    
    
    @objc private func clickReconfirmAction() {
        clickReconfirmBlock?("")
    }

    
    @objc private func clickCheckInAction() {
        clickCheckInBlock?("")
    }


    
    func setCellData(model: BookingContentModel) {
        if model.reserveStatus == "1" {
            ///待确认
            cancelBut.isHidden = true
            rejectBut.isHidden = false
            confirmBut.isHidden = false
            reconfirmBut.isHidden = true
            checkInBut.isHidden = true
        }
        
        if model.reserveStatus == "2" {
            //拒绝
            cancelBut.isHidden = true
            rejectBut.isHidden = true
            confirmBut.isHidden = true
            reconfirmBut.isHidden = false
            checkInBut.isHidden = true

        }
        
        if model.reserveStatus == "3" {
            //取消
            cancelBut.isHidden = true
            rejectBut.isHidden = true
            confirmBut.isHidden = true
            reconfirmBut.isHidden = false
            checkInBut.isHidden = true
        }

        
        if model.reserveStatus == "4" {
            //预定成功
            cancelBut.isHidden = false
            rejectBut.isHidden = true
            confirmBut.isHidden = true
            reconfirmBut.isHidden = true
            checkInBut.isHidden = false
        }
        
        if model.reserveStatus == "5" {
            //checkin
            cancelBut.isHidden = true
            rejectBut.isHidden = true
            confirmBut.isHidden = true
            reconfirmBut.isHidden = true
            checkInBut.isHidden = true

        }
    }
    
}
