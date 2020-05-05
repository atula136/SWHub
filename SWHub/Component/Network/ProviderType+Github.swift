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
    
    func repository(user: String, project: String) -> Observable<Repository> {
        return self.githubNetworking.requestObject(.repository(fullname: "\(user)/\(project)"), type: Repository.self)
    }
    
}
