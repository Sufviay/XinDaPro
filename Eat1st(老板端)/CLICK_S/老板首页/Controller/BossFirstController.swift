//
//  BossFirstController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/29.
//

import UIKit
import RxSwift

class BossFirstController: HeadBaseViewController {
    
    private let bag = DisposeBag()
    
    private var viewControllers: [UIViewController] = []
    
    ///侧滑栏
    private lazy var sideBar: FirstSideToolView = {
        let view = FirstSideToolView()
        return view
    }()
    
    
    ///顶部tag
    private lazy var tagView: FirstTagView = {
        let view = FirstTagView()
        
        view.selectTagItemBlock = { [unowned self] (idx) in
            self.pageView.scrollToIndex(index: idx)
        }
        
        return view
    }()
    
    
    
    //配置滑动视图
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        
        layout.sliderHeight = 50
        //是否均分
        layout.isAverage = false
        layout.pageBottomLineHeight = 0
        layout.isScrollEnabled = true

//        //标题栏每个标题的宽度
        layout.sliderWidth = 20
//        //标题看下方滑块指示器的高度
        layout.bottomLineHeight = 4
//
        layout.showsHorizontalScrollIndicator = false
//        //被选中时标题的字体颜色
        layout.titleSelectColor = FONTCOLOR
//        //设置标题的字体大小
        layout.titleFont = BFONT(14)
        //设置选中时放大的倍数
        layout.scale = 1
//        //设置未被选中时的字体颜色
        layout.titleColor = HCOLOR("#6F7FAF")
//        //设置滑动指示器的颜色
        layout.bottomLineColor = HCOLOR("#05CBE7")
//        //标题栏的背景色
        layout.titleViewBgColor = .white
        layout.bottomLineCornerRadius = 2
        layout.lrMargin = 30
        return layout
    }()
    
    lazy var pageView: LTPageView = {
        let H: CGFloat = S_H - bottomBarH - statusBarH - 80
        let pageView = LTPageView(frame: CGRect(x: 0, y: statusBarH + 80, width: S_W, height: H), currentViewController: self, viewControllers: viewControllers, titles: ["Booking", "Store revenue", "Live Reporting", "Menu items"], layout: layout)
        pageView.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: H), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        pageView.backgroundColor = .white
        
        pageView.didSelectIndexBlock = { [unowned self] (_, idx) in
            print("_____________" + String(idx))
            self.tagView.selectIdx = idx

        }
        return pageView
    }()
    
    private let msgBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("sy_msg"), for: .normal)
        return but
    }()
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_leftbut"), for: .normal)
        self.biaoTiLab.text = "Eat1st\nPartner Centre"
        
    }
    

    override func setViews() {
        
        self.view.backgroundColor = .white
        
        view.addSubview(msgBut)
        msgBut.snp.makeConstraints {
            $0.size.equalTo(leftBut)
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(leftBut)
        }
        
//        view.addSubview(tagView)
//        tagView.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.height.equalTo(50)
//            $0.top.equalToSuperview().offset(statusBarH + 80)
//        }
//        
//        let tView = UIView()
//        tView.backgroundColor = .white
//        view.addSubview(tView)
//        tView.snp.makeConstraints {
//            $0.left.bottom.right.equalToSuperview()
//            $0.top.equalTo(tagView.snp.bottom)
//        }
        
        viewControllers = [StoreBookingController(), StoreRevenueController(), LiveReportingController(), MenuItemsController()]
        view.addSubview(pageView)

        
        
        leftBut.addTarget(self, action: #selector(clickSideBarAction), for: .touchUpInside)
        msgBut.addTarget(self, action: #selector(clickMsgAction), for: .touchUpInside)
        
    }
    
    
    @objc private func clickSideBarAction() {
        sideBar.appearAction()
        
    }
    
    
    @objc private func clickMsgAction() {
        let msgVC = MessageController()
        self.navigationController?.pushViewController(msgVC, animated: true)
    }
    
    

}
