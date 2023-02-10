//
//  GestureTableView.swift
//  CLICK
//
//  Created by 肖扬 on 2021/8/2.
//

import UIKit

class GestureTableView: UITableView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }


}
