//
//  ProviderType+Github.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/27.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import SWFrame

extension ProviderType {

    private var githubNetworking: GithubNetworking {
        return GithubNetworking(provider: NetworkProvider<GithubAPI>(endpointClosure: GithubNetworking.endpointsClosure(), requestClosure: GithubNetworking.endpointResolver(), stubClosure: GithubNetworking.APIKeysBasedStubBehaviour, plugins: GithubNetworking.plugins))
    }

    func profile() -> Observable<User> {
        return self.githubNetworking.requestObject(.profile, type: User.self)
    }

    func repository(fullname: String) -> Observable<Repository> {
        return self.githubNetworking.requestObject(.repository(fullname: fullname), type: Repository.self)
    }

    func checkStarring(fullname: String) -> Observable<Bool> {
        return self.githubNetworking.requestRaw(.checkStarring(fullname: fullname)).map { emptyDataStatusCodes.contains($0.statusCode) }
    }

    func starRepository(fullname: String) -> Observable<Void> {
        return self.githubNetworking.requestRaw(.starRepository(fullname: fullname)).map { _ in }
    }

    func unstarRepository(fullname: String) -> Observable<Void> {
        return self.githubNetworking.requestRaw(.unstarRepository(fullname: fullname)).map { _ in }
    }

}

private let emptyDataStatusCodes: Set<Int> = [204, 205]
