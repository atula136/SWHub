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

    func repo(fullname: String) -> Observable<Repo> {
        return self.githubNetworking.requestObject(.repo(fullname: fullname), type: Repo.self)
    }

    func checkStarring(fullname: String) -> Observable<Bool> {
        return self.githubNetworking.requestRaw(.checkStarring(fullname: fullname)).map { emptyDataStatusCodes.contains($0.statusCode) }
    }

    func starRepo(fullname: String) -> Observable<Void> {
        return self.githubNetworking.requestRaw(.starRepo(fullname: fullname)).map { _ in }
    }

    func unstarRepo(fullname: String) -> Observable<Void> {
        return self.githubNetworking.requestRaw(.unstarRepo(fullname: fullname)).map { _ in }
    }

    func watchers(fullname: String, page: Int) -> Observable<[User]> {
        return self.githubNetworking.requestArray(.watchers(fullname: fullname, page: page), type: User.self)
    }

}

private let emptyDataStatusCodes: Set<Int> = [204, 205]
