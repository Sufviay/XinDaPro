//
//  OtherPlatformController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2025/9/27.
//

import UIKit

class OtherPlatformController: UIViewController {
    
    var platformType: String = ""

    private var dataType: String = "3"
    
    
    private var orderVC: OtherPlatformOrdersController = {
        let vc = OtherPlatformOrdersController()
        return vc
    }()
    
    private var dishVC: OtherPlatformDataController = {
        let vc = OtherPlatformDataController()
        return vc
    }()

    
    
    private lazy var filtrateView: SalesFiltrateView = {
        let view = SalesFiltrateView()
        view.initFiltrateViewDateType(dateType: dataType)
        //选择时间类型
        view.selectTypeBlock = { [unowned self] (str) in
            
            if str == "Week".local {
                self.dataType = "2"
            }
            if str == "Day".local {
                self.dataType = "1"
            }
            if str == "Month".local {
                self.dataType = "3"
            }
        }
        
        //选择的时间
        view.selectTimeBlock = { [unowned self] (arr) in
            let dateArr = arr as! [String]
            
            dishVC.dataType = dataType
            dishVC.dateStr = dateArr[0]
            dishVC.endDateStr = dateArr[1]
            
            
            if dataType == "3" {
                //月
                orderVC.startDate = dateArr[0] + "-01"
                orderVC.endDate = DateTool.getMonthLastDate(monthStr: dateArr[0])
            } else if dataType == "1" {
                orderVC.startDate = dateArr[0]
                orderVC.endDate = dateArr[0]

            } else {
                orderVC.startDate = dateArr[0]
                orderVC.endDate = dateArr[1]
            }

            
            let notification = Notification(name: NSNotification.Name("TimeChange"), object: nil)
            NotificationCenter.default.post(notification)
            
        }
        
        return view
    }()

    
    //配置滑动视图
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        
        layout.sliderHeight = 40
        //是否均分
        layout.isAverage = false
        layout.pageBottomLineHeight = 0
        layout.isScrollEnabled = true

//        //标题栏每个标题的宽度
        layout.sliderWidth = 50
//        //标题看下方滑块指示器的高度
        layout.bottomLineHeight = 3
//
        layout.showsHorizontalScrollIndicator = false
//        //被选中时标题的字体颜色
        layout.titleSelectColor = MAINCOLOR
//        //设置标题的字体大小
        layout.titleFont = TIT_3
        //设置选中时放大的倍数
        layout.scale = 1
//        //设置未被选中时的字体颜色
        layout.titleColor = TXTCOLOR_1
//        //设置滑动指示器的颜色
        layout.bottomLineColor = MAINCOLOR
//        //标题栏的背景色
        layout.titleViewBgColor = BACKCOLOR_1
        layout.bottomLineCornerRadius = 1.5
        layout.lrMargin = 30
        return layout
    }()
    
    private var pageView: LTPageView!
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(filtrateView)
        filtrateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        
//        let orderVC = OtherPlatformOrdersController()
        orderVC.platformType = platformType
//        let dishVC = OtherPlatformDataController()
        dishVC.platformType = platformType
        let pageViewControllers = [orderVC, dishVC]
    
        let pageTitleArr = ["Orders".local, "Top menu items".local]
        
        pageView = LTPageView(frame: CGRect(x: 0, y: 70, width: S_W, height:S_H - bottomBarH - statusBarH - 200), currentViewController: self, viewControllers: pageViewControllers, titles: pageTitleArr, layout: layout)
        pageView.backgroundColor = .white

        view.addSubview(pageView)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
