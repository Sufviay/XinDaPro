//
//  ShowGiftAlertManager.swift
//  CLICK
//
//  Created by 肖扬 on 2024/9/24.
//

import UIKit
import RxSwift

class ShowGiftAlertManager: NSObject {
    
    private let bag = DisposeBag()
    
    internal static let instance = ShowGiftAlertManager()
    
    
    func showAlert(giftId: String) {
        HTTPTOOl.getGiftDetail(id: giftId).subscribe(onNext: { (json) in
            
            if json["data"]["giftStatus"].stringValue == "1" {
                //未领取
                let alert = GiftTakeAlertController()
                alert.transitioningType = .popup
                alert.giftID = giftId
                alert.jsonData = json
                PJCUtil.currentVC()?.present(alert, animated: true)
            } else {
                //已领取
                let alert = GiftBeTakenAlert()
                alert.transitioningType = .popup
                alert.jsonData = json
                PJCUtil.currentVC()?.present(alert, animated: true)
            }

        }, onError: { (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: PJCUtil.getWindowView())
        }).disposed(by: bag)

    }

}
