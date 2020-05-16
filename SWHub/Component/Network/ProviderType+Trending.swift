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

    func languages() -> Observable<[Language]> {
        return self.trendingNetworking.requestArray(.languages, type: Language.self)
    }

    /// 仓库趋势：https://github-trending-api.now.sh/repositories?language=Swift&since=monthly
    /// - Parameters:
    ///   - language: 语言
    ///   - since: 时间
    func repositories(language: String?, since: String?) -> Observable<[Repo]> {
        return self.trendingNetworking.requestArray(.repositories(language: language, since: since), type: Repo.self)
    }

    /// 用户趋势：https://github-trending-api.now.sh/developers?language=Swift&since=monthly
    /// - Parameters:
    ///   - language: 语言
    ///   - since: 时间
    func developers(language: String?, since: String?) -> Observable<[User]> {
        return self.trendingNetworking.requestArray(.developers(language: language, since: since), type: User.self)
    }
}
