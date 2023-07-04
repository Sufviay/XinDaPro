//
//  HttpTool.swift
//  SheepStoreMer
//
//  Created by 岁变 on 10/25/19.
//  Copyright © 2019 岁变. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import Alamofire
import MBProgressHUD
import Moya


let requestTimeOut = { (endpoint: Endpoint, done: @escaping MoyaProvider<ApiManager>.RequestResultClosure) in
    
    do {
        var request: URLRequest = try endpoint.urlRequest()
        request.timeoutInterval = 15
        done(.success(request))
    } catch {
        print("超时了")
    }
    
}

class HttpTool {
    
    static let shared = HttpTool()
    private init() {}
    
    private let bag = DisposeBag()
    
    
    private let provider = MoyaProvider<ApiManager>(requestClosure: requestTimeOut, plugins: [NetWorkPlugin()])
    
    typealias apiToObserver = (AnyObserver<JSON>) -> Disposable
    
    func rxApiManager(api: ApiManager) -> apiToObserver {
        return { (observer: AnyObserver<JSON>) -> Disposable in
            return self.provider.rx.request(api).subscribe { event in
                switch event {
                case .success(let response):
                    if response.statusCode == 200 {
                        let json = JSON(response.data)
                        print(json)
                        if json["code"].stringValue == "1"  {
                            observer.onNext(json)
                            observer.onCompleted()
                        } else if (json["code"].stringValue == "-1" || json["code"].stringValue == "-3" || json["code"].stringValue == "-4" || json["code"].stringValue == "-5" || json["code"].stringValue == "-6") || json["code"].stringValue == "-2" {
                            observer.onNext(json)
                            observer.onCompleted()
                            HUD_MB.showWarnig("Login is invalid. Please log in again!", onView: PJCUtil.getWindowView())
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                PJCUtil.logOut()
                            }
                        } else {
                            ERROR_Message = json["msg"].stringValue
                            observer.onError(NetworkError.unkonw)
                        }
                    } else {
                        observer.onError(NetworkError.serverError)
                    }

                case .error(let error):
                    print(error.localizedDescription)
                    observer.onError(NetworkError.netError)
                }
            }
        }
    }
    

    
    //MARK: - 登录
    func userLogIn(user: String, pw: String) -> Observable<JSON> {
        let response = rxApiManager(api: .loginAction(user: user, pw: pw))
        return Observable<JSON>.create(response)
    }
    
    //MARK: - 登出
    func userLogOut() -> Observable<JSON> {
        let response = rxApiManager(api: .logOutAction)
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 获取输入数据的状态
    func getInputDataStatus(date: String) -> Observable<JSON> {
        let response = rxApiManager(api: .getInputDataStatus(date: date))
        return Observable<JSON>.create(response)
    }
    
    
    //MARK: - 上传数据
    func doSaveAction(model: DayDataModel) -> Observable<JSON> {
        let response = rxApiManager(api: .doSaveData(model: model))
        return Observable<JSON>.create(response)
    }
    
    
    
    
    
    //MARK: - 上传菜品图片
    func uploadDishImages(images: [UIImage], success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->()) {
        
        let url = BASEURL + "api/boss/upload/dishes"
        AF.upload(multipartFormData: { (multipartFormData) in
            // 参数：
            // 压缩
            for image in images {
                let data = image.jpegData(compressionQuality: 0.1)
                let fileName = String.init(describing: NSDate()) + ".png"
                // withName:：是根据文档决定传入的字符串
                multipartFormData.append(data!, withName: "file", fileName: fileName, mimeType: "image/png")
            }
            // 遍历添加参数
//            for (key, value) in params{
//                // string 转 data
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }

        }, to: url, method: .post, headers: HTTPHeaders(["token": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let json):
                let jsonData = JSON(json)
                ERROR_Message = jsonData["msg"].stringValue
                print(jsonData)
                if jsonData["code"].stringValue == "1" {
                    success(jsonData)
                } else {
                    failure(NetworkError.unkonw)
                }
            case .failure(let error):
                ERROR_Message = error.localizedDescription
                failure(NetworkError.unkonw)
            }
        }
    }
    
    
    //MARK: - 上传赠品图片
    func uploadGiftImages(images: [UIImage], success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->()) {
        
        let url = BASEURL + "api/boss/upload/gift"
        AF.upload(multipartFormData: { (multipartFormData) in
            // 参数：
            // 压缩
            for image in images {
                let data = image.jpegData(compressionQuality: 0.1)
                let fileName = String.init(describing: NSDate()) + ".png"
                // withName:：是根据文档决定传入的字符串
                multipartFormData.append(data!, withName: "file", fileName: fileName, mimeType: "image/png")
            }
            // 遍历添加参数
//            for (key, value) in params{
//                // string 转 data
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }

        }, to: url, method: .post, headers: HTTPHeaders(["token": UserDefaults.standard.token ?? "", "token-boss": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let json):
                let jsonData = JSON(json)
                ERROR_Message = jsonData["msg"].stringValue
                print(jsonData)
                if jsonData["code"].stringValue == "1" {
                    success(jsonData)
                } else {
                    failure(NetworkError.unkonw)
                }
            case .failure(let error):
                ERROR_Message = error.localizedDescription
                failure(NetworkError.unkonw)
            }
        }
    }
    
    
    
//
//
//    func testAF() {
//        let par = [["id": "1", "name": "xy"], ["id": "2", "name": "ss"]]
//        let header = ["Authorization": "BasicQWdeaasdexXAREdaxadaexa==", "Accept": "application/json"]
//        AF.request("url", method: .post, parameters: par, encoder: JSONParameterEncoder.default, headers: HTTPHeaders(header)).responseJSON { (dataresponse) in
//
//            switch dataresponse.result {
//
//            }
//
//        }
//
//
//    }
    

    
    
    //MARK: - 上传多张图片
    func uploadImages(images: [UIImage], success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->()) {
    
    
        let url = BASEURL + "api/boss/upload/data"
        AF.upload(multipartFormData: { (multipartFormData) in
            // 参数：
            // 压缩
            for image in images {
                let data = image.jpegData(compressionQuality: 0.1)
                let fileName = String.init(describing: NSDate()) + ".png"
                // withName:：是根据文档决定传入的字符串
                multipartFormData.append(data!, withName: "file", fileName: fileName, mimeType: "image/png")
            }
            // 遍历添加参数
//            for (key, value) in params{
//                // string 转 data
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }

        }, to: url, method: .post, headers: HTTPHeaders(["token-boss": UserDefaults.standard.token ?? "", "token": UserDefaults.standard.token ?? ""])).responseJSON { (dataResponse) in
            switch dataResponse.result {
                
            case .success(let json):
            
                let jsonData = JSON(json)
                ERROR_Message = jsonData["msg"].stringValue
                print(jsonData)
                if jsonData["code"].stringValue == "1" {
                    success(jsonData)
                } else {
                    failure(NetworkError.unkonw)
                }
            case .failure(let error):
                ERROR_Message = error.localizedDescription
                failure(NetworkError.unkonw)
            }
        }
    }


    
    
    
    
//    //MARK: - 上传图片
//    func uploadImage(image: UIImage, success:@escaping (_ result: JSON)->(), failure:@escaping (_ error: NetworkError)->())  {
//
//        let url = BASEURL + "/index/index/upload"
//        let params = ["Authorization": UserDefaults.standard.token ?? ""]
//        AF.upload(multipartFormData: { (multipartFormData) in
//            // 压缩
//            let data = image.jpegData(compressionQuality: 0.1)
//            let fileName = String.init(describing: NSDate()) + ".png"
//            // withName:：是根据文档决定传入的字符串
//            multipartFormData.append(data!, withName: "file", fileName: fileName, mimeType: "image/png")
//
//            // 遍历添加参数
//            for (key, value) in params{
//                // string 转 data
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//
//        }, to: url, method: .post, headers: HTTPHeaders([:])).responseJSON { (dataResponse) in
//            switch dataResponse.result {
//            case .success(let json):
//                let jsonData = JSON(json)
//                ERROR_Message = jsonData["msg"].stringValue
//                print(jsonData)
//                if jsonData["code"].stringValue == "0" || jsonData["code"].stringValue == "200" {
//                    success(jsonData)
//                } else {
//                    failure(NetworkError.unkonw)
//                }
//            case .failure(let error):
//                ERROR_Message = error.localizedDescription
//                failure(NetworkError.unkonw)
//            }
//        }
//    }

}



