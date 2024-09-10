//
//  StoreOutChartCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/8/7.
//

import UIKit
import Charts

class StoreOutChartCell: BaseTableViewCell, IValueFormatter {


    private let titles = ["Food Cost", "Staff Wages", "Water Bill", "Electricity Bill", "Gas Bill", "Licenses Fee", "Rent", "Tax", "Misc"]

    private let colors = [HCOLOR("#5F79F6"), HCOLOR("#EC5B59"), HCOLOR("#C766F9"), HCOLOR("#FD7936"), HCOLOR("#50B8EA"), HCOLOR("#1ACA90"), HCOLOR("#F5B148"), HCOLOR("#FF487F"), HCOLOR("#C5C5C5")]
    
    private lazy var chartView: PieChartView = {
        let pie = PieChartView()

        //关闭拖拽
        pie.dragDecelerationEnabled = false

        //显示数据转为百分比
        pie.usePercentValuesEnabled = true
        
        //显示区块文字
        pie.drawEntryLabelsEnabled = false

        //半径空心的比例
        pie.holeRadiusPercent = 0.5

        //显示中心文字
        pie.drawCenterTextEnabled = true

        //是否显示图例
        pie.legend.enabled = true
        
        return pie
    }()
    
    
    
    override func setViews() {
        
        
        contentView.addSubview(chartView)
        chartView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 300, height: 260))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
    }
    
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {

        if value <= 0 {
            return ""
        }
        return String(format: "%.1f", value) + "%"
    }


    func setCellData(model: StoreInOrOutCostModel) {
        
        let centerStr = "Total expenditure\n\(D_2_STR(model.totalOut))"
        
        var myMutableString = NSMutableAttributedString()

        myMutableString = NSMutableAttributedString(string: centerStr, attributes: [NSAttributedString.Key.font: UIFont(name:"Helvetica-Bold", size:12)!, NSAttributedString.Key.foregroundColor: HCOLOR("000000")])


        let range = centerStr.hw_exMatchStrRange("Total expenditure")

        //添加不同字体颜色
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:HCOLOR("#666666"), range:range.first!)

        //添加不同字体大小
        myMutableString.addAttribute(NSAttributedString.Key.font, value:BFONT(10), range:range.first!)

        chartView.centerAttributedText =  myMutableString
        
        
        var ydata: [Double] = [model.foodPrice, model.wagesPrice, model.waterPrice, model.electricPrice, model.gasPrice, model.licensePrice, model.rentPrice, model.taxPrice, model.otherPrice]
            
        if (ydata.filter { $0 != 0 }).count == 0 {
            ydata = []
            chartView.data = .none
            return
        }

        var yValus: [PieChartDataEntry] = []

        for (i, num) in ydata.enumerated() {
            let entry = PieChartDataEntry(value: num, label: titles[i])
            yValus.append(entry)
        }

        let chartDateSet = PieChartDataSet(entries: yValus, label: "")
        chartDateSet.colors = colors


        chartDateSet.xValuePosition = .outsideSlice
        chartDateSet.yValuePosition = .outsideSlice
        chartDateSet.sliceSpace = 1 //相邻块的距离
        chartDateSet.selectionShift = 6  //选中放大半径


        let data = PieChartData.init(dataSets: [chartDateSet])
        data.setValueFormatter(self)

        data.setValueFont(BFONT(12))
        data.setValueTextColor(FONTCOLOR)
        chartView.data = data

    }
    
    
}
