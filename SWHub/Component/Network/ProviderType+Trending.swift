//
//  ProviderType+Trending.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/4.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import SWFrame

extension ProviderType {

    private var trendingNetworking: TrendingNetworking {
        return TrendingNetworking(provider: NetworkProvider<TrendingAPI>(endpointClosure: TrendingNetworking.endpointsClosure(), requestClosure: TrendingNetworking.endpointResolver(), stubClosure: TrendingNetworking.APIKeysBasedStubBehaviour, plugins: TrendingNetworking.plugins))
    }

    func languages() -> Observable<[Condition.Language]> {
        return self.trendingNetworking.requestArray(.languages, type: Condition.Language.self)
    }

    func repositories(language: String?, since: String?) -> Observable<[TrendingRepo]> {
        return self.trendingNetworking.requestArray(.repositories(language: language, since: since), type: TrendingRepo.self)
    }

    func developers(language: String?, since: String?) -> Observable<[TrendingDeveloper]> {
        return self.trendingNetworking.requestArray(.developers(language: language, since: since), type: TrendingDeveloper.self)
    }
}
