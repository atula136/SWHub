//
//  ProviderType+Network.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SWFrame

extension ProviderType {

    func download(url: URL) -> Observable<String> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.global().async {
                do {
                    observer.onNext(try String(contentsOf: url))
                    observer.onCompleted()
                } catch {
                    observer.onError(AppError.network)
                }
            }
            return Disposables.create { }
        }.observeOn(MainScheduler.instance)
    }

}
