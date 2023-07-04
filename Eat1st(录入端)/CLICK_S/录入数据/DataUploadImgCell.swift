//
//  DataUploadImgCell.swift
//  CLICK_S
//
//  Created by 肖扬 on 2023/5/23.
//

import UIKit

class DataUploadImgCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, SystemAlertProtocol, CommonToolProtocol, HXCustomNavigationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var editeImgblock: (([UIImage]) -> Void)?
    
    private var picImgArr: [UIImage] = []
    
    private let titLab: UILabel = {
        let lab = UILabel()
        lab.setCommentStyle(.black, BFONT(14), .left)
        lab.text = "Upload Pictures"
        return lab
    }()
    
    private lazy var picColleciton: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let W = (S_W - 80) / 5
        layout.itemSize = CGSize(width: W , height: W)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.bounces = false
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = .white
        coll.showsVerticalScrollIndicator = false
        coll.register(AddImgCell.self, forCellWithReuseIdentifier: "AddImgCell")
        coll.register(PicImgCell.self, forCellWithReuseIdentifier: "PicImgCell")
        return coll
    }()

    
    
    
    override func setViews() {
        
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(picColleciton)
        picColleciton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(35)
            $0.bottom.equalToSuperview().offset(-10)
        }

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picImgArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == picImgArr.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImgCell", for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicImgCell", for: indexPath) as! PicImgCell
        cell.picImg.image = picImgArr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == picImgArr.count {
            //添加图片
            if picImgArr.count == 9 {
                HUD_MB.showWarnig("Maximum 9 images！", onView: PJCUtil.getWindowView())
                return
            }
            showSelectImgSheetAlert(titStr: "Choose picture", xcAction: { [unowned self] in
                print("album")
                self.showAblum((9 - self.picImgArr.count), 0)
            }) { [unowned self] in
                print("camera")
                self.showCamera()
            }

        } else {
            //放大查看图片
            
            let brower =  XYPhotoBrower(imgs: picImgArr, idx: indexPath.item)
            brower.modalPresentationStyle = .overFullScreen
            brower.deleteCallBack = { [unowned self] (imgArr) in
                self.picImgArr = imgArr
                self.editeImgblock?(self.picImgArr)
            }
            PJCUtil.currentVC()?.present(brower, animated: false)
                        
        }
    }
    
    
    
    //MARK: - 相册代理
    //点击完成
    
    func photoNavigationViewController(_ photoNavigationViewController: HXCustomNavigationController!, didDoneAllList allList: [HXPhotoModel]!, photos photoList: [HXPhotoModel]!, videos videoList: [HXPhotoModel]!, original: Bool) {
        var imageList: [UIImage] = []
        imageList = photoList.map { $0.previewPhoto ?? UIImage() }
        self.picImgArr += imageList
        self.editeImgblock?(self.picImgArr)
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
        self.picImgArr.append(image)
        picker.dismiss(animated: true, completion: nil)
        self.editeImgblock?(self.picImgArr)
    }

    
    func setCellData(picArr: [UIImage]) {
        self.picImgArr = picArr
        self.picColleciton.reloadData()
    }

    
    
}


class PicImgCell: UICollectionViewCell {
    
    var deleteBlock: VoidBlock?
    
    let picImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = HOLDCOLOR
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(picImg)
        picImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickCloseAciton() {
        deleteBlock?("")
    }
}



class AddImgCell: UICollectionViewCell {
    
    
    private let addImg: UIImageView = {
        let img = UIImageView()
        img.image = LOIMG("dish_addImg")
        return img
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(addImg)
        addImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

