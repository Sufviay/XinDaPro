//
//  StatisticalChartsCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/5/31.
//

import UIKit
import Charts

//class StatisticalChartsCell: BaseTableViewCell, IValueFormatter, UITableViewDelegate, UITableViewDataSource {
//
//
//    private var dataModel = ReportModel()
//
//
//    private let titles = ["Card delivery", "Card collection", "Cash delivery", "Cash collection", "POS delivery", "POS collection"]
//
//    private let colors = [HCOLOR("#F67165"), HCOLOR("#5B1DD4"), HCOLOR("#3AD491"), HCOLOR("#1F63FD"), HCOLOR("#FED701"), HCOLOR("#2BE0FC")]
//
//
//    private let backView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//
//        view.layer.cornerRadius = 15
//
//        view.layer.shadowColor = RCOLORA(0, 0, 0, 0.08).cgColor
//        // 阴影偏移，默认(0, -3)
//        view.layer.shadowOffset = CGSize(width: 0, height: 5)
//        // 阴影透明度，默认0
//        view.layer.shadowOpacity = 1
//        // 阴影半径，默认3
//        view.layer.shadowRadius = 5
//
//        return view
//    }()
//
//
//    private let titlab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("333333"), BFONT(18), .left)
//        lab.text = "Income Type"
//        return lab
//    }()
//
//    private let line: UIImageView = {
//        let img = UIImageView()
//        img.image = GRADIENTCOLOR(HCOLOR("#2B8AFF"), HCOLOR("#28B1FF"), CGSize(width: 70, height: 3))
//        img.clipsToBounds = true
//        img.layer.cornerRadius = 1
//        return img
//    }()
//
//
//
//    private lazy var chartView: PieChartView = {
//        let pie = PieChartView()
//
//        //关闭拖拽
//        pie.dragDecelerationEnabled = false
//
//        //显示数据转为百分比
//        pie.usePercentValuesEnabled = true
//        //显示区块文字
//        pie.drawEntryLabelsEnabled = false
//
//        //半径空心的比例
//        pie.holeRadiusPercent = 0.7
//
//        //显示中心文字
//        pie.drawCenterTextEnabled = true
//
//        //是否显示图例
//        pie.legend.enabled = false
//
//        return pie
//    }()
//
//
//    private lazy var table: UITableView = {
//        let tableView = UITableView()
//        tableView.backgroundColor = .clear
//        //去掉单元格的线
//        tableView.separatorStyle = .none
//        //回弹效果
//        tableView.bounces = true
//        tableView.showsVerticalScrollIndicator =  false
//        tableView.estimatedRowHeight = 0
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.register(ChartLegendCell.self, forCellReuseIdentifier: "ChartLegendCell")
//        return tableView
//    }()
//
//
//
//    override func setViews() {
//
//        contentView.addSubview(backView)
//        backView.snp.makeConstraints {
//
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(-20)
//            $0.top.equalToSuperview().offset(20)
//            $0.bottom.equalToSuperview().offset(-20)
//        }
//
//        backView.addSubview(titlab)
//        titlab.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(20)
//            $0.left.equalToSuperview().offset(20)
//        }
//
//        backView.addSubview(line)
//        line.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(20)
//            $0.top.equalTo(titlab.snp.bottom).offset(5)
//            $0.size.equalTo(CGSize(width: 70, height: 3))
//        }
//
//
//
//        backView.addSubview(chartView)
//        chartView.snp.makeConstraints {
//            $0.size.equalTo(CGSize(width: 250, height: 250))
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().offset(60)
////            $0.height.equalTo(S_W - 100)
////            $0.left.equalToSuperview().offset(30)
////            $0.right.equalToSuperview().offset(-30)
//
//        }
//
//        backView.addSubview(table)
//        table.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.top.equalToSuperview().offset(330)
//            $0.bottom.equalToSuperview().offset(-20)
//        }
//    }
//
//
//    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//
//        if value <= 0 {
//            return ""
//        }
//        return String(format: "%.1f", value) + "%"
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 6
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 30
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartLegendCell") as! ChartLegendCell
//
//
//        var per: Double = 0
//        var money: Double = 0
//
//
//        if indexPath.row == 0 {
//            per = Double(dataModel.cardOrderSum_De / dataModel.orderSum_All) * 100
//            money = dataModel.cardOrderSum_De
//        }
//
//        if indexPath.row == 1 {
//            per = Double(dataModel.cardOrderSum_Co / dataModel.orderSum_All) * 100
//            money = dataModel.cardOrderSum_Co
//        }
//
//        if indexPath.row == 2 {
//            per = Double(dataModel.cashOrderSum_De / dataModel.orderSum_All) * 100
//            money = dataModel.cashOrderSum_De
//        }
//
//        if indexPath.row == 3 {
//            per = Double(dataModel.cashOrderSum_Co / dataModel.orderSum_All) * 100
//            money = dataModel.cashOrderSum_Co
//        }
//
//        if indexPath.row == 4 {
//            per = Double(dataModel.posOrderSum_De / dataModel.orderSum_All) * 100
//            money = dataModel.posOrderSum_De
//        }
//
//        if indexPath.row == 5 {
//            per = Double(dataModel.posOrderSum_Co / dataModel.orderSum_All) * 100
//            money = dataModel.posOrderSum_Co
//        }
//
//        let perStr = String(format: "%.1f", per) == "nan" ? "0" : String(format: "%.1f", per)
//
//        cell.setCellData(lineColor: colors[indexPath.row], name: titles[indexPath.row], preNum: perStr + "%", moneyNum: "£\(D_2_STR(money))")
//
//        return  cell
//    }
//
//
//
////    func setCellData(model: ReportModel) {
////
////        self.dataModel = model
////
////        //设置饼状图的数据
////
////        let centerStr = "£\(D_2_STR(model.orderSum_All))\nTotal revenue"
////
////        var myMutableString = NSMutableAttributedString()
////
////        myMutableString = NSMutableAttributedString(string: centerStr, attributes: [NSAttributedString.Key.font: UIFont(name:"Helvetica-Bold", size:20)!, NSAttributedString.Key.foregroundColor: HCOLOR("333333")])
////
////
////        let range = centerStr.hw_exMatchStrRange("Total revenue")
////
////        //添加不同字体颜色
////        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:HCOLOR("#666666"), range:range.first!)
////
////        //添加不同字体大小
////        myMutableString.addAttribute(NSAttributedString.Key.font, value:SFONT(13), range:range.first!)
////
////
////        self.chartView.centerAttributedText =  myMutableString
////
////        //["Card delivery", "Card collection", "Cash delivery", "Cash collection", "POS delivary", "POS collection"]
////
////        let ydata: [Double] = [model.cardOrderSum_De, model.cardOrderSum_Co, model.cashOrderSum_De, model.cashOrderSum_Co, model.posOrderSum_De, model.posOrderSum_Co]
////
////        var yValus: [PieChartDataEntry] = []
////
////        for (i, num) in ydata.enumerated() {
////            let entry = PieChartDataEntry(value: num, label: titles[i])
////            yValus.append(entry)
////        }
////
////        let chartDateSet = PieChartDataSet(entries: yValus, label: "")
////        chartDateSet.colors = colors
////
////
////        chartDateSet.xValuePosition = .insideSlice
////        chartDateSet.yValuePosition = .insideSlice
////        chartDateSet.sliceSpace = 2 //相邻块的距离
////        chartDateSet.selectionShift = 6  //选中放大半径
////
////
////        let data = PieChartData.init(dataSets: [chartDateSet])
////        data.setValueFormatter(self)
////
////        data.setValueFont(BFONT(10))
////        data.setValueTextColor(HCOLOR("#333333"))
////        chartView.data = data
////
////        self.table.reloadData()
////
////    }
////
//
//
//}
//
//
//
//
//class ChartLegendCell: BaseTableViewCell {
//
//
//    private let colorLine: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 2
//        return view
//    }()
//
//    private let titLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#666666"), BFONT(14), .left)
//        lab.text = "name"
//        return lab
//    }()
//
//    private let percentNum: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("333333"), BFONT(14), .left)
//        lab.text = "15%"
//        return lab
//    }()
//
//    private let moneyNum: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("333333"), BFONT(14), .left)
//        lab.text = "£ 3980.40"
//        return lab
//    }()
//
//    override func setViews() {
//
//        contentView.addSubview(colorLine)
//        colorLine.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.left.equalToSuperview().offset(20)
//            $0.size.equalTo(CGSize(width: 6, height: 15))
//        }
//
//        contentView.addSubview(titLab)
//        titLab.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.left.equalTo(colorLine.snp.right).offset(10)
//        }
//
//        contentView.addSubview(percentNum)
//        percentNum.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.left.equalTo(contentView.snp.centerX)
//        }
//
//        contentView.addSubview(moneyNum)
//        moneyNum.snp.makeConstraints {
//            $0.left.equalToSuperview().offset(R_W(230))
//            $0.centerY.equalToSuperview()
//        }
//
//    }
//
//
//    func setCellData(lineColor: UIColor, name: String, preNum: String, moneyNum: String) {
//        self.colorLine.backgroundColor = lineColor
//        self.titLab.text = name
//        self.percentNum.text = preNum
//        self.moneyNum.text = moneyNum
//    }
//
//}
