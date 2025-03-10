//
//  StoreAmountChartCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/8/7.
//

import UIKit
import Charts


class StoreAmountChartCell: BaseTableViewCell, IValueFormatter {


    
    private let titles = ["Dine-in Sales", "Takeaway Sales", "Tips", "Top Up"]

    private let colors = [HCOLOR("#5F79F6"), HCOLOR("#F4B33F"), HCOLOR("#64DDE8"), HCOLOR("#9C9FFF")]

    
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
            $0.size.equalTo(CGSize(width: 230, height: 230))
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
        
        let centerStr = "Total amount\n\(D_2_STR(model.salesPrice))"
        
        var myMutableString = NSMutableAttributedString()

        myMutableString = NSMutableAttributedString(string: centerStr, attributes: [NSAttributedString.Key.font: UIFont(name:"Helvetica-Bold", size:12)!, NSAttributedString.Key.foregroundColor: HCOLOR("000000")])


        let range = centerStr.hw_exMatchStrRange("Total amount")

        //添加不同字体颜色
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:HCOLOR("#666666"), range:range.first!)

        //添加不同字体大小
        myMutableString.addAttribute(NSAttributedString.Key.font, value:BFONT(10), range:range.first!)

        chartView.centerAttributedText =  myMutableString
        
        
        
        var ydata: [Double] = [model.dinePrice, model.deliPrice, model.tipsPrice, model.topUp]
        
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


        chartDateSet.xValuePosition = .insideSlice
        chartDateSet.yValuePosition = .insideSlice
        chartDateSet.sliceSpace = 2 //相邻块的距离
        chartDateSet.selectionShift = 6  //选中放大半径


        let data = PieChartData.init(dataSets: [chartDateSet])
        data.setValueFormatter(self)

        data.setValueFont(BFONT(15))
        data.setValueTextColor(HCOLOR("#FFFFFF"))
        chartView.data = data
        
        

    }
    
    
    
}
