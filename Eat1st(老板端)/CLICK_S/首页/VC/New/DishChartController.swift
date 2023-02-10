//
//  DishChartController.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/8/31.
//

import UIKit
import RxSwift
import Charts


class DishChartController: HeadBaseViewController, IAxisValueFormatter {
    

    
    private var weekDatas: [WeekSalesModel] = []
    private var monthDatas: [MonthSalesModel] = []
    
    
    private let bag = DisposeBag()
    
    /// 2周 3月
    var type: String = ""
    
    var dateStr: String = ""
    
    var endDateStr: String = ""
    
    var dishModel = DishModel()
    

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerWithRect(rect: CGRect(x: 0, y: 0, width: S_W, height: S_H - statusBarH - 80), byRoundingCorners: [.topLeft, .topRight], radii: 20)
        return view
    }()

    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(FONTCOLOR, BFONT(21), .left)
        lab.text = "Your delivery area"
        lab.numberOfLines = 0
        return lab
    }()
    
    
    private let line: UIImageView = {
        let img = UIImageView()
        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        return img
    }()

    
    
    private let barChartView: BarChartView = {
        let view = BarChartView()
        view.noDataText = "" //没有数据时的文字提示
        view.chartDescription?.enabled = false
        
        
        //交互
        view.scaleXEnabled = true  //取消x轴的缩放
        view.scaleYEnabled = false //取消y轴的缩放
        view.doubleTapToZoomEnabled = false  //取消双击放大
        view.dragDecelerationEnabled = true  //开启拖拽惯性效果
        
        //x轴
        
        let xAxis = view.xAxis
        xAxis.axisLineWidth = 1   //线宽
        xAxis.axisLineColor = HCOLOR("#F4F4FE") //线的颜色
        xAxis.labelPosition = .bottom  //字体位置
        xAxis.labelTextColor = HCOLOR("666666") //字体颜色
        xAxis.labelFont = BFONT(10) //字体大小
        xAxis.drawGridLinesEnabled = false //不绘制网格线
        xAxis.granularity = 1.0

        
        
        //y轴
        view.rightAxis.enabled = false //关闭y轴的右边轴
        
        
        let yAxis = view.leftAxis
        yAxis.axisMinimum = 0 //最小值
        // yAxis.drawZeroLineEnabled = true //从0开始绘制
        yAxis.forceLabelsEnabled = false //不强制绘制指定数量的label
        yAxis.axisLineWidth = 1
        yAxis.axisLineColor = HCOLOR("#F4F4FE")
        yAxis.labelFont = BFONT(10)
        yAxis.labelTextColor = HCOLOR("#3A4247")
        
        yAxis.drawGridLinesEnabled = true //不绘制网格线
        yAxis.gridLineWidth = 1
        yAxis.gridColor = HCOLOR("F4F4FE")
        
        yAxis.gridAntialiasEnabled = true
        
                
        view.legend.enabled = false
        return view
    }()
    
    
    
    override func setNavi() {
        self.leftBut.setImage(LOIMG("sy_back"), for: .normal)
        self.biaoTiLab.text = "Menu items"
    }
    
    override func setViews() {
        setUpUI()
        loadData_Net()
    }

    
    private func setUpUI() {
        
        self.leftBut.addTarget(self, action: #selector(clickBackAction), for: .touchUpInside)
        
        view.addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(statusBarH + 80)
        }
        
        
        titlab.text = dishModel.name1
        
        backView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-20)
        }
        
        backView.addSubview(line)
        line.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 70, height: 3))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(titlab.snp.bottom).offset(7)
        }
        
        
        
        backView.addSubview(barChartView)
        barChartView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(line.snp.bottom).offset(80)
            $0.height.equalTo(240)
        }

        
    }
    
    @objc private func clickBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    private func loadData_Net() {
        
        HUD_MB.loading("", onView: view)
        
        if type == "3" {
            ///月
            HTTPTOOl.getDishSales_Month(dishID: dishModel.id, date: dateStr, type: dishModel.type).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var mArr: [MonthSalesModel] = []
                for jsonData in json["data"].arrayValue {
                    let model = MonthSalesModel()
                    model.updateModel(json: jsonData)
                    mArr.append(model)
                }
                self.monthDatas = mArr
                self.barChartViewSetValue()
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
        }
        if type == "2" {
            //周
            HTTPTOOl.getDishSales_Week(dishID: dishModel.id, startDate: dateStr, endDate: endDateStr, type: dishModel.type).subscribe(onNext: { (json) in
                HUD_MB.dissmiss(onView: self.view)
                
                var wArr: [WeekSalesModel] = []
                for jsonData in json["data"].arrayValue {
                    let model = WeekSalesModel()
                    model.updateModel(json: jsonData)
                    wArr.append(model)
                }
                self.weekDatas = wArr
                self.barChartViewSetValue()
                
            }, onError: { (error) in
                HUD_MB.showError(ErrorTool.errorMessage(error), onView: self.view)
            }).disposed(by: self.bag)
            
        }
    
    }
    
    
    ///柱状图赋值
    private func barChartViewSetValue() {
        
        
        //设置X轴样式
        let xAxis = barChartView.xAxis
        
        xAxis.valueFormatter = self
        let xformatter = IndexAxisValueFormatter()
        
        var xValueArr: [String] = []
        if type == "2" {
            //周
            for model in weekDatas {
                xValueArr.append(model.day)
            }
        }
        if type == "3" {
            //月
            for model in monthDatas {
                xValueArr.append(model.week)
            }
        }
        
        xformatter.values = xValueArr
        
        
        
        
        var dataEntris: [BarChartDataEntry] = []
        
        if type == "3" {
            //月
            
            for (idx, model) in monthDatas.enumerated() {
                let dateEntry = BarChartDataEntry(x: Double(idx), y: Double(model.salesNum))
                dataEntris.append(dateEntry)
            }
        }
        if type == "2" {
            //周
            for (idx, model) in weekDatas.enumerated() {
                let dateEntry = BarChartDataEntry(x: Double(idx), y: Double(model.salesNum))
                dataEntris.append(dateEntry)
            }
        }
        let chartDataSet =  BarChartDataSet(entries: dataEntris, label: "")
        //设置柱形样式
        
        chartDataSet.highlightEnabled = false //选中高亮
        
        chartDataSet.colors = [HCOLOR("#8B88FF")]
            
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartData.setValueTextColor(HCOLOR("#666666"))  //柱子上的数据颜色
        chartData.setValueFont(BFONT(10))  //字体
        
        if type == "2" {
            chartData.barWidth = 0.4  //每个柱子之间的间隔占比
        }
        if type == "3" {
            chartData.barWidth = 0.5  //每个柱子之间的间隔占比
        }
        
        
        
        self.barChartView.data = chartData
        self.barChartView.animate(yAxisDuration: 0.4)
        
    }
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        if type == "2" {
            return weekDatas[Int(value) % weekDatas.count].day
        } else {
            return monthDatas[Int(value) % monthDatas.count].week
        }
        
    }

    
    
}






