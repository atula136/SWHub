//
//  Condition.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/5.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import Kingfisher
import ObjectMapper
import SwifterSwift
import Rswift
import SWFrame

struct Condition: ModelType, Subjective, Equatable /*, Eventable */ {

//    enum Event {
//        case update(Since, Language)
//    }

    var id: Int?
    var since = Since.daily
    var language = Language.init(name: "All languages")

    init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        since       <- map["since"]
        language    <- map["language"]
    }

    static func objectStoreKey(id: String? = nil) -> String {
        return "Condition"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.since.rawValue == rhs.since.rawValue &&
            lhs.language.urlParam == rhs.language.urlParam
    }

    enum Since: Int, Codable {
        case daily, weekly, monthly

        static let allValues = [daily, weekly, monthly]

        var title: String {
            switch self {
            case .daily: return R.string.localizable.conditionSinceDaily()
            case .weekly: return R.string.localizable.conditionSinceWeekly()
            case .monthly: return R.string.localizable.conditionSinceMonthly()
            }
        }

        var paramValue: String {
            switch self {
            case .daily: return "daily"
            case .weekly: return "weekly"
            case .monthly: return "monthly"
            }
        }

        enum CodingKeys: String, CodingKey {
            case daily      = "daily"
            case weekly     = "weekly"
            case monthly    = "monthly"
        }

    }

    struct Language: ModelType, Subjective, Eventable, Equatable {

        enum Event {
            case select(String?)
        }

        var id: Int?
        var checked = false
        var name: String?
        var urlParam: String?

        init() {
        }

        init(name: String? = nil) {
            self.name = name
        }

        init?(map: Map) {
        }

        mutating func mapping(map: Map) {
            name            <- map["name"]
            urlParam        <- map["urlParam"]
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.urlParam == rhs.urlParam
        }

        static func arrayStoreKey() -> String {
            return "languages"
        }

        class Item: CollectionItem, ReactorKit.Reactor {

            typealias Action = NoAction

            enum Mutation {
                case setSelect(String?)
            }

            struct State {
                var checked = false
                var title: String?
            }

            var initialState = State()

            required init(_ model: ModelType) {
                super.init(model)
                guard let language = model as? Language else { return }
                self.initialState = State(
                    checked: language.checked,
                    title: language.urlParam == nil ? NSLocalizedString(language.name ?? R.string.localizable.allLanguages(), comment: "") : language.name
                )
            }

            func reduce(state: State, mutation: Mutation) -> State {
                var state = state
                switch mutation {
                case let .setSelect(urlParam):
                    if let language = self.model as? Language {
                        state.checked = urlParam == language.urlParam
                    }
                }
                return state
            }

            func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
                let languageSelectEvent = Language.event.flatMap { event -> Observable<Mutation> in
                    switch event {
                    case let .select(urlParam):
                        return .just(.setSelect(urlParam))
                    }
                }
                return .merge(mutation, languageSelectEvent)
            }
        }

        class Cell: CollectionCell, ReactorKit.View {

            lazy var titleLabel: Label = {
                let label = Label()
                label.font = .normal(16)
                label.sizeToFit()
                return label
            }()

            lazy var checkImageView: UIImageView = {
                let imageView = UIImageView()
                imageView.image = UIImage.check.template
                imageView.sizeToFit()
                return imageView
            }()

            override init(frame: CGRect) {
                super.init(frame: frame)
                self.cornerRadius = 4
                self.contentView.addSubview(self.titleLabel)
                self.contentView.addSubview(self.checkImageView)

                themeService.rx
                    .bind({ $0.textColor }, to: self.titleLabel.rx.textColor)
                    .bind({ $0.foregroundColor }, to: self.checkImageView.rx.tintColor)
                    .disposed(by: self.rx.disposeBag)
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            override func layoutSubviews() {
                super.layoutSubviews()
                self.titleLabel.sizeToFit()
                self.titleLabel.left = 15
                self.titleLabel.top = self.titleLabel.topWhenCenter

                self.checkImageView.right = self.contentView.width - 15
                self.checkImageView.top = self.checkImageView.topWhenCenter
            }

            override func prepareForReuse() {
                super.prepareForReuse()
                self.titleLabel.text = nil
                self.checkImageView.isHidden = true
            }

            func bind(reactor: Item) {
                super.bind(item: reactor)
                reactor.state.map { $0.title }
                    .bind(to: self.titleLabel.rx.text)
                    .disposed(by: self.disposeBag)
                reactor.state.map { !$0.checked }
                    .bind(to: self.checkImageView.rx.isHidden)
                    .disposed(by: self.disposeBag)
                reactor.state.map { _ in }
                    .bind(to: self.rx.setNeedsLayout)
                    .disposed(by: self.disposeBag)
            }

            override class func size(width: CGFloat, item: BaseCollectionItem) -> CGSize {
                return CGSize(width: width, height: metric(50))
            }
        }

        enum Section {
            case languages([SectionItem])
        }

        enum SectionItem {
            case language(Item)
        }
    }
}

extension Condition.Language.Section: SectionModelType {
    var items: [Condition.Language.SectionItem] {
        switch self {
        case let .languages(items): return items
        }
    }

    init(original: Condition.Language.Section, items: [Condition.Language.SectionItem]) {
        switch original {
        case .languages: self = .languages(items)
        }
    }
}
