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
    
    private var pageViewControllers: [UIViewController] = []
        
    //private let H: CGFloat = S_H - bottomBarH - statusBarH - 80
    
    ///侧滑栏
    private lazy var sideBar: FirstSideToolView = {
        let view = FirstSideToolView()
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
        layout.titleSelectColor = TXTCOLOR_1
//        //设置标题的字体大小
        layout.titleFont = TIT_3
        //设置选中时放大的倍数
        layout.scale = 1
//        //设置未被选中时的字体颜色
        layout.titleColor = HCOLOR("#6F7FAF")
//        //设置滑动指示器的颜色
        layout.bottomLineColor = HCOLOR("#05CBE7")
//        //标题栏的背景色
        layout.titleViewBgColor = BACKCOLOR_1
        layout.bottomLineCornerRadius = 2
        layout.lrMargin = 30
        return layout
    }()
    
    private var pageView: LTPageView!
    

    
    private let msgBut: UIButton = {
        let but = UIButton()
        but.setImage(LOIMG("sy_msg"), for: .normal)
        but.isHidden = false
        return but
    }()
    
    
    private let titlab1: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_1, .center)
        lab.text = UserDefaults.standard.storeName ?? "Eat1st"
        return lab
    }()
    
    private let titlab2: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.white, TIT_2, .center)
        lab.text = UserDefaults.standard.accountNum
        return lab
    }()
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_leftbut"), for: .normal)
        biaoTiLab.text = ""
        loadTagList_Net()
    }
    

    override func setViews() {
        
        addNotificationCenter()
        loadPageView()
        
        view.addSubview(titlab1)
        titlab1.snp.makeConstraints {
            $0.left.equalToSuperview().offset(60)
            $0.right.equalToSuperview().offset(-60)
            $0.top.equalToSuperview().offset(statusBarH + 10)
        }
        
        view.addSubview(titlab2)
        titlab2.snp.makeConstraints {
            $0.left.right.equalTo(titlab1)
            $0.top.equalTo(titlab1.snp.bottom)
        }
        
        view.addSubview(msgBut)
        msgBut.snp.makeConstraints {
            $0.size.equalTo(leftBut)
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(leftBut)
        }
        
        
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
    
    
    //添加通知中心
    
    
    deinit {
        print("\(self.classForCoder)销毁")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("fistPageDataChange"), object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }

    
    
    //更新首頁數據變化
    @objc private func loadPageView() {
        
        if pageView != nil {
            pageView.removeFromSuperview()
            pageView = nil
        }
        
        if FirstPageManager.shared.pageDataTitle.count == 0 {
            return
        }
        
        var tempControllers: [UIViewController] = []
        var titleArr: [String] = []
        
        for str in FirstPageManager.shared.pageDataTitle {
            titleArr.append(str)
            switch str {
            case "Live":
                let vc = StoreDataOverviewController()
                tempControllers.append(vc)
            case "Sale Summary":
                let vc = StoreRevenueController()
                tempControllers.append(vc)
            case "Booking":
                let vc = BookingScheController()
                tempControllers.append(vc)
            case "Sale Chart":
                let vc = MenuItemsController()
                tempControllers.append(vc)
            case "Uber Eats":
                let vc = OtherPlatformController()
                vc.platformType = "2"
                tempControllers.append(vc)
            case "Deliveroo":
                let vc = OtherPlatformController()
                vc.platformType = "1"
                tempControllers.append(vc)
            case "Record":
                let vc = FirstPageOrderController()
                tempControllers.append(vc)
            default:
                break
            }
        }
        
        let pageTitArr = titleArr.map { $0.local }
        
        pageViewControllers = tempControllers
        
        let H =  UIScreen.main.bounds.height - bottomBarH - statusBarH - 80
    
        pageView = LTPageView(frame: CGRect(x: 0, y: statusBarH + 80, width: UIScreen.main.bounds.width, height: H), currentViewController: self, viewControllers: pageViewControllers, titles: pageTitArr, layout: layout)
        //pageView.cornerWithRect(rect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: H), byRoundingCorners: [.topLeft, .topRight], radii: 10)
        pageView.backgroundColor = .white

        view.addSubview(pageView)
        
    }
    
    
    private func loadTagList_Net() {
        //每次进入首页 请求tag列表 要与本地存储的作比较，有变化就更新，没有变化就忽略
        HTTPTOOl.getStoreInfo().subscribe(onNext: { [unowned self] (json) in
            //获取tablist
            let listIdArr = json["data"]["tabPageList"].arrayObject as? [Int]
            if let tarr = listIdArr {
                if !FirstPageManager.matchLocally(idArr: tarr) {
                    loadPageView()
                }
            }

        }, onError: { [unowned self] (error) in
            HUD_MB.showError(ErrorTool.errorMessage(error), onView: view)
        }).disposed(by: bag)

    }
    
    

}


extension BossFirstController {
    
    private func addNotificationCenter() {
        //监测消息的变化
        NotificationCenter.default.addObserver(self, selector: #selector(loadPageView), name: NSNotification.Name(rawValue: "fistPageDataChange"), object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }


    @objc private func orientationDidChange() {
        
        switch UIDevice.current.orientation {
        case .unknown:
            print("未知")
        case .portrait:
            print("竖屏")
            updateFrame()
        case .portraitUpsideDown:
            print("颠倒竖屏")
            updateFrame()
        case .landscapeLeft:
            print("左旋转 横屏")
            updateFrame()
        case .landscapeRight:
            print("右旋转 横屏")
            updateFrame()
        case .faceUp:
            print("屏幕朝上")
        case .faceDown:
            print("屏幕朝下")
        default:
            break
        }
        
    }
    
    
    private func updateFrame() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            DispatchQueue.main.async {
                print(R_W(338))
                
                let H =  UIScreen.main.bounds.height - bottomBarH - statusBarH - 80
                
                self.pageView.snp.remakeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.top.equalToSuperview().offset(statusBarH + 80)
                    $0.height.equalTo(H)
                }
                
            }
        }
    }
}
