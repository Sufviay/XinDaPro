//
//  DishEditeImageCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2022/6/24.
//

import UIKit

class DishEditeImageCell: BaseTableViewCell, SystemAlertProtocol, CommonToolProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SDPhotoBrowserDelegate {
    
    private var picUrl: String = ""
    private var picImg: UIImage?
    
    var selectImgBlock: VoidImgBlock?
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Food tags"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
        lab.isHidden = true
        return lab
    }()
    
    
    private let picImgView: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = BACKCOLOR_2
        img.isUserInteractionEnabled = true
        img.image = LOIMG("dish_addImg")
        return img
    }()
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(picImgView)
        picImgView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 65, height: 65))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(60)
        }
        
        picImgView.addSubview(tView)
        tView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tView.addGestureRecognizer(tap)
        
    }
    

    @objc private func tapAction() {
        //self.showImage(self.picImgView)
        
        let alertController = UIAlertController(title: "Picture".local, message: "", preferredStyle: .actionSheet)
        let actionOne = UIAlertAction(title: "Album".local, style: .default) { (alert) in
            //相册
            self.showPhotoLibrary()
        }
        let actionTwo = UIAlertAction(title: "Camera".local, style: .default) { (alert) in
            //相机
            self.showCamera()
        }
        
        let actionThree = UIAlertAction(title: "To view".local, style: .default) { (alert) in
            ///放大图片
            self.showImage(self.picImgView)
        }

        let cancel = UIAlertAction(title: "Cancel".local, style: .cancel, handler: nil)
        
        if self.picImg == nil && self.picUrl == "" {
            alertController.addAction(actionOne)
            alertController.addAction(actionTwo)
            alertController.addAction(cancel)
        } else {
            alertController.addAction(actionOne)
            alertController.addAction(actionTwo)
            alertController.addAction(actionThree)
            alertController.addAction(cancel)
        }
        PJCUtil.currentVC()?.present(alertController, animated: true)
        
    }
    
        
    
    func setCellData(titStr: String, imgUrl: String, picImage: UIImage?) {
        self.titlab.text = titStr
        
        if picImage != nil {
            self.picImgView.image = picImage
        } else {
            if imgUrl == "" {
                self.picImgView.image = LOIMG("dish_addImg")
            } else {
                self.picImgView.sd_setImage(with: URL(string: imgUrl))
            }
        }
        
        self.picImg = picImage
        self.picUrl = imgUrl
    }
    
    //MARK: - 相机代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let tempImg = info[.originalImage] as? UIImage else {
            print("错误")
            picker.dismiss(animated: true, completion: nil)
            return
        }
        let imageData: Data = tempImg.jpegData(compressionQuality: 0.1)!
        let image: UIImage = UIImage(data: imageData)!
        self.selectImgBlock?(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        
        if picImg != nil {
            return nil
        } else {
            return URL(string: picUrl)
        }
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {        
        return picImg
    }

}




class DishEditeImageDetailCell: BaseTableViewCell, SystemAlertProtocol, CommonToolProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SDPhotoBrowserDelegate {
    
    private var picUrl: String = ""
    private var picImg: UIImage?
    
    var selectImgBlock: VoidImgBlock?
    
    private let titlab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(TXTCOLOR_1, TIT_2, .left)
        lab.text = "Food tags"
        return lab
    }()
    
    private let sLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(MAINCOLOR, TIT_3, .left)
        lab.text = "*"
        lab.isHidden = true
        return lab
    }()
    
    
    private let picImgView: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = BACKCOLOR_2
        img.isUserInteractionEnabled = true
        img.image = LOIMG("dish_addImg_d")
        return img
    }()
    
    private let tView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    override func setViews() {
        
        contentView.addSubview(titlab)
        titlab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(sLab)
        sLab.snp.makeConstraints {
            $0.centerY.equalTo(titlab)
            $0.left.equalTo(titlab.snp.right).offset(3)
        }
        
        contentView.addSubview(picImgView)
        picImgView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 96, height: 64))
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(60)
        }
        
        picImgView.addSubview(tView)
        tView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tView.addGestureRecognizer(tap)
        
    }
    

    @objc private func tapAction() {
        //self.showImage(self.picImgView)
        
        let alertController = UIAlertController(title: "Picture".local, message: "", preferredStyle: .actionSheet)
        let actionOne = UIAlertAction(title: "Album".local, style: .default) { (alert) in
            //相册
            self.showPhotoLibrary()
        }
        let actionTwo = UIAlertAction(title: "Camera".local, style: .default) { (alert) in
            //相机
            self.showCamera()
        }
        
        let actionThree = UIAlertAction(title: "To view".local, style: .default) { (alert) in
            ///放大图片
            self.showImage(self.picImgView)
        }

        let cancel = UIAlertAction(title: "Cancel".local, style: .cancel, handler: nil)
        
        if self.picImg == nil && self.picUrl == "" {
            alertController.addAction(actionOne)
            alertController.addAction(actionTwo)
            alertController.addAction(cancel)
        } else {
            alertController.addAction(actionOne)
            alertController.addAction(actionTwo)
            alertController.addAction(actionThree)
            alertController.addAction(cancel)
        }
        PJCUtil.currentVC()?.present(alertController, animated: true)
        
    }
    
        
    
    func setCellData(titStr: String, imgUrl: String, picImage: UIImage?) {
        self.titlab.text = titStr
        
        if picImage != nil {
            self.picImgView.image = picImage
        } else {
            if imgUrl == "" {
                self.picImgView.image = LOIMG("dish_addImg_d")
            } else {
                self.picImgView.sd_setImage(with: URL(string: imgUrl))
            }
        }
        
        self.picImg = picImage
        self.picUrl = imgUrl
    }
    
    //MARK: - 相机代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let tempImg = info[.originalImage] as? UIImage else {
            print("错误")
            picker.dismiss(animated: true, completion: nil)
            return
        }
        let imageData: Data = tempImg.jpegData(compressionQuality: 0.1)!
        let image: UIImage = UIImage(data: imageData)!
        self.selectImgBlock?(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        
        if picImg != nil {
            return nil
        } else {
            return URL(string: picUrl)
        }
    }
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return picImg
    }

}


