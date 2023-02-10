//
//  XYPhotoBrower.swift
//  CLICK
//
//  Created by 肖扬 on 2022/4/16.
//

import UIKit

class XYPhotoBrower: UIViewController {
    
   
    //删除
    var deleteCallBack: (([UIImage]) -> Void)?

    private var number: Int
    private var showView: ShowImageView
    
    init(imgs: [UIImage], idx: Int) {
        self.number = idx
        self.showView = ShowImageView(imgArr: imgs, number: number)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        self.layoutViews()

    }
    
    func layoutViews() {
        self.view.addSubview(showView)
        
        self.showView.dismissCallBack = { [unowned self] in
            self.dismiss(animated: false, completion: nil)
        }
        
        self.showView.deleteCallBack = { [unowned self] (imageArr) in
            self.deleteCallBack?(imageArr)
            if imageArr.count == 0 {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showView.transformAnimation()
    }
    

}
