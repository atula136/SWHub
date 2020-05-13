//
//  RepoDetailViewReactor.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/13.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import SwifterSwift
import Highlightr
import MarkdownView
import ReactorKit
import SWFrame

class RepoDetailViewReactor: CollectionViewReactor, ReactorKit.Reactor {

    enum Action {
        case load
    }

    enum Mutation {
        case setLoading(Bool)
        case setError(Error?)
        case setReadme(Repo.Readme)
    }

    struct State {
        var isLoading = false
        var title: String?
        var error: Error?
        var readme: Repo.Readme!
        var sections: [RepoSection] = []
    }

    var fullname: String?
    var initialState = State()

    required init(_ provider: ProviderType, _ parameters: [String: Any]?) {
        super.init(provider, parameters)
        self.fullname = stringMember(self.parameters, Parameter.fullname, nil)
        self.initialState = State(
            title: stringDefault(self.title, self.fullname ?? "")
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            guard self.currentState.isLoading == false else { return .empty() }
            guard let fullname = self.fullname else { return .empty() }
            return .concat([
                .just(.setError(nil)),
                .just(.setLoading(true)),
                self.requestReadme(fullname).map { Mutation.setReadme($0) },
                .just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setError(error):
            state.error = error
        case let .setReadme(readme):
            state.readme = readme
            state.sections = [.list([.readme(RepoReadmeItem(readme))])]
        }
        return state
    }

    func markdownHeight(_ markdown: String) -> Observable<CGFloat> {
        let mdView = MarkdownView()
        mdView.isHidden = true
        mdView.isScrollEnabled = false
        mdView.width = screenWidth
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(mdView)
        }
        return Observable.create { observer -> Disposable in
            mdView.onRendered = { height in
                observer.onNext(height)
                observer.onCompleted()
            }
            mdView.load(markdown: markdown)
            return Disposables.create {
                mdView.removeFromSuperview()
            }
        }
    }

    func requestReadme(_ fullname: String) -> Observable<Repo.Readme> {
        return self.provider.readme(fullname: fullname).flatMap { [weak self] readme -> Observable<Repo.Readme> in
            guard let `self` = self, let url = readme.downloadUrl else { return .empty() }
            return self.provider.download(url: url).map { markdown -> Repo.Readme in
                var readme = readme
                readme.markdown = markdown
                return readme
            }
        }.flatMap { [weak self] readme -> Observable<Repo.Readme> in
            guard let `self` = self, let markdown = readme.markdown else { return .empty() }
            return self.markdownHeight(markdown).map { height -> Repo.Readme in
                var readme = readme
                readme.height = height
                return readme
            }
        }
    }

}
