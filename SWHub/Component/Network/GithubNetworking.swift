//
//  GithubNetworking.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/27.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import Moya
import Alamofire
import Moya_ObjectMapper_Swift5
import SWFrame

struct GithubNetworking: NetworkingType {

    typealias T = GithubAPI
    let provider: NetworkProvider<GithubAPI>
    
    static func endpointsClosure<T>(_ xAccessToken: String? = nil) -> (T) -> Endpoint where T: TargetType {
        return { target in
//            if target.path == "/cn/api/message/list" {
//                return Endpoint(url: target.baseURL.appendingPathComponent(target.path).absoluteString, sampleResponseClosure: { .networkError(NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)) }, method: target.method, task: target.task, httpHeaderFields: target.headers)
//            }
            return MoyaProvider.defaultEndpointMapping(for: target)
        }
    }
    
    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
//        if true {
//            // return .immediate
//            return .delayed(seconds: TimeInterval(1.5))
//        }
        return .never
    }
    
    func request(_ token: GithubAPI) -> Observable<Moya.Response> {
        return self.provider.request(token)
    }
    
    func requestRaw(_ target: GithubAPI) -> Observable<Moya.Response> {
        return self.request(target)
            .observeOn(MainScheduler.instance)
    }
    
    func requestJSON(_ target: GithubAPI) -> Observable<Any> {
        return self.request(target)
            .mapJSON()
            .observeOn(MainScheduler.instance)
    }
    
    func requestObject<T: ModelType>(_ target: GithubAPI, type: T.Type) -> Observable<T> {
        return self.request(target)
            .mapObject(T.self)
            .observeOn(MainScheduler.instance)
    }
    
    func requestArray<T: ModelType>(_ target: GithubAPI, type: T.Type) -> Observable<[T]> {
        return self.request(target)
            .mapArray(T.self)
            .observeOn(MainScheduler.instance)
    }
    
    func requestModel<T: ModelType>(_ target: GithubAPI, type: T.Type) -> Observable<T> {
        return .create { observer -> Disposable in
            let disposable = self.request(target).mapObject(ObjectResponse<T>.self).subscribe(onNext: { response in
                if response.code == 200, response.data != nil { // YJX_TODO 容错处理
                    observer.onNext(response.data!)
                    observer.onCompleted()
                } else {
                    if response.code == 401 {
                        observer.onError(AppError.expire)
                    } else {
                        observer.onError(AppError.server)
                    }
                }
            }, onError: { error in
                observer.onError(self.convert(error: error))
            }, onCompleted: {
                observer.onCompleted()
            })
            return Disposables.create {
                disposable.dispose()
            }
        }
    }

    func requestModels<T: ModelType>(_ target: GithubAPI, type: T.Type) -> Observable<[T]> {
        return .create { observer -> Disposable in
            let disposable = self.request(target).mapObject(ArrayResponse<T>.self).subscribe(onNext: { response in
                if response.code == 200, response.data != nil { // YJX_TODO 容错处理
                    observer.onNext(response.data!)
                    observer.onCompleted()
                } else {
                    observer.onError(AppError.server)
                }
            }, onError: { error in
                observer.onError(self.convert(error: error))
            }, onCompleted: {
                observer.onCompleted()
            })
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    func requestList<T: ModelType>(_ target: GithubAPI, type: T.Type) -> Observable<List<T>> {
        return .create { observer -> Disposable in
            let disposable = self.request(target).mapObject(ObjectResponse<List<T>>.self).subscribe(onNext: { response in
                if response.code == 200, response.data != nil { // YJX_TODO 容错处理
                    if let list = response.data {
                        if let items = list.items, items.count != 0 {
                            observer.onNext(response.data!)
                            observer.onCompleted()
                        } else {
                            observer.onError(AppError.empty)
                        }
                    } else {
                        observer.onNext(response.data!)
                        observer.onCompleted()
                    }
                } else {
                    if response.code == 401 {
                        observer.onError(AppError.expire)
                    } else {
                        observer.onError(AppError.server)
                    }
                }
            }, onError: { error in
                observer.onError(self.convert(error: error))
            }, onCompleted: {
                observer.onCompleted()
            })
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
}

