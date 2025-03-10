//
//  ChartTimeCollectionCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2024/11/22.
//

import UIKit

class ChartTimeCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var clickBlock: VoidBlock?
    
    
    private var line: Int = 0
    
    private var timeData = ChartBookTimeModel()
    
    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        //去掉单元格的线
        tableView.separatorStyle = .none
        //回弹效果
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator =  false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        //tableView.register(TimeHeadCell.self, forCellReuseIdentifier: "TimeHeadCell")
        tableView.register(TimeBookingInfoCell.self, forCellReuseIdentifier: "TimeBookingInfoCell")
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return line
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeHeadCell") as! TimeHeadCell
//            cell.titLab.text = timeData.reserveTime
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeBookingInfoCell") as! TimeBookingInfoCell
        
        if timeData.bookingArr.count == 0 {
            cell.setCellData(isBook: false, model: nil)
        } else {
            if indexPath.row <= timeData.bookingArr.count - 1 {
                cell.setCellData(isBook: true, model: timeData.bookingArr[indexPath.row])
            } else {
                cell.setCellData(isBook: false, model: nil)
            }
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //查看详情
        if indexPath.row <= timeData.bookingArr.count - 1 {
            //看详情
            let detailModel = timeData.bookingArr[indexPath.row]
            clickBlock?(detailModel)
        }
        
        
    }
    
    func setCellData(lineCount: Int, timeModel: ChartBookTimeModel) {
        line = lineCount
        timeData = timeModel
        table.reloadData()
    }
    
}



//class TimeHeadCell: BaseTableViewCell {
//    
//    let titLab: UILabel = {
//        let lab = UILabel()
//        lab.setCommentStyle(HCOLOR("#080808"), BFONT(11), .center)
//        return lab
//    }()
//    
//    private let line1: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#E5E5E5")
//        return view
//    }()
//    
//    private let line2: UIView = {
//        let view = UIView()
//        view.backgroundColor = HCOLOR("#E5E5E5")
//        return view
//    }()
//    
//
//    
//    override func setViews() {
//        contentView.backgroundColor = HCOLOR("#DFEFFF")
//        contentView.addSubview(titLab)
//        titLab.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        contentView.addSubview(line1)
//        line1.snp.makeConstraints {
//            $0.left.right.bottom.equalToSuperview()
//            $0.height.equalTo(0.5)
//        }
//        
//        contentView.addSubview(line2)
//        line2.snp.makeConstraints {
//            $0.top.right.bottom.equalToSuperview()
//            $0.width.equalTo(0.5)
//        }
//
//    }
//    
//}


class TimeBookingInfoCell: BaseTableViewCell {
    
    
    private let line1: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E5E5E5")
        return view
    }()
    
    private let line2: UIView = {
        let view = UIView()
        view.backgroundColor = HCOLOR("#E5E5E5")
        return view
    }()
    
    private let nameLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(10), .left)
        lab.lineBreakMode = .byTruncatingTail
        return lab
    }()

    
    private let sImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("yellow_s")
        return img
    }()
    
    
    private let countLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(HCOLOR("#080808"), BFONT(10), .left)
        return lab
    }()
    

    
    override func setViews() {
        
        contentView.addSubview(line1)
        line1.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        contentView.addSubview(line2)
        line2.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(0.5)
        }
        
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(sImg)
        sImg.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(CGSize(width: 13, height: 11))
            $0.top.equalTo(nameLab.snp.bottom).offset(5)
        }
        
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints {
            $0.centerY.equalTo(sImg)
            $0.left.equalTo(sImg.snp.right).offset(5)
        }
        

        
    }
    
    
    func setCellData(isBook: Bool, model: BookingContentModel?) {
        
        
        if isBook {
            
            if model?.reserveStatus == "5" {
                contentView.backgroundColor = HCOLOR("#EEEEEE")
                
            } else {
                contentView.backgroundColor = HCOLOR("#FFFAEE")
            }
            nameLab.isHidden = false
            sImg.isHidden = false
            countLab.isHidden = false
            nameLab.text = model!.name
            countLab.text = String(model!.reserveNum)

            
        } else {
            contentView.backgroundColor = .white
            nameLab.isHidden = true
            sImg.isHidden = true
            countLab.isHidden = true
        }
    }
    
}
