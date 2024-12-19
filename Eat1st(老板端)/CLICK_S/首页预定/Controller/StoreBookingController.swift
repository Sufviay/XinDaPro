//
//  StoreBookingController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/21.
//

import UIKit

class StoreBookingController: UIViewController {
    
    
    private lazy var tagView: BookingTagView = {
        let view = BookingTagView()
        view.selectTagItemBlock = { [unowned self] (idx) in
            self.pageView.scrollToIndex(index: idx)
        }
        
        return view
    }()
    
    private var viewControllers: [UIViewController] = []
    
    
    
    //配置滑动视图
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.sliderHeight = 0
        //是否均分
        layout.isAverage = false
        layout.pageBottomLineHeight = 0
        layout.isScrollEnabled = true
        layout.showsHorizontalScrollIndicator = false
        return layout
    }()

    
    lazy var pageView: LTPageView = {
        let H: CGFloat = S_H - bottomBarH - statusBarH - 80 - 50 - 75
        let pageView = LTPageView(frame: CGRect(x: 0, y: 75, width: S_W, height: H), currentViewController: self, viewControllers: viewControllers, titles: ["", ""], layout: layout)
        pageView.backgroundColor = .white
        pageView.scrollView.isScrollEnabled = false
        
        pageView.didSelectIndexBlock = { [unowned self] (_, idx) in
            print("_____________" + String(idx))
            self.tagView.selectIdx = idx

        }
        return pageView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        
        viewControllers = [BookingListController(), BookingScheController()]
        view.addSubview(pageView)
        
        
    }
    

}
