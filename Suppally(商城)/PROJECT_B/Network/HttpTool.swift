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
                        if json["code"].stringValue == "200"  {
                            observer.onNext(json)
                            observer.onCompleted()
                        } else {
                            ERROR_Message = json["msg"].stringValue
                            observer.onError(NetworkError.unkonw)
                        }
                    } else {
                        observer.onError(NetworkError.serverError)
                    }
                    
                case .failure(let error):
                    
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
    

}



