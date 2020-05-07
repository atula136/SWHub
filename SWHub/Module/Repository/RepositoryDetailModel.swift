//
//  RepositoryDetailModel.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import ReactorKit
import Kingfisher
import SWFrame

struct RepositoryDetailModel: ModelType {

    var key = Key.pull
    var detail: String?

    init() {
    }

    init(key: Key, detail: String? = nil) {
        self.key = key
        self.detail = detail
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
    }

    enum Key {
        case pull
        case commit
        case branch
        case release
        case contributor
        case event
        case notification
        case code
        case star
        case line

        static let allValues = [
            pull, commit, branch,
            release, contributor, event,
            notification, code, star, line
        ]

        var title: String {
            switch self {
            case .pull: return R.string.localizable.detailCellPull()
            case .commit: return R.string.localizable.detailCellCommit()
            case .branch: return R.string.localizable.detailCellBranch()
            case .release: return R.string.localizable.detailCellRelease()
            case .contributor: return R.string.localizable.detailCellContributor()
            case .event: return R.string.localizable.detailCellEvent()
            case .notification: return R.string.localizable.detailCellNotification()
            case .code: return R.string.localizable.detailCellCode()
            case .star: return R.string.localizable.detailCellStar()
            case .line: return R.string.localizable.detailCellLine()
            }
        }

        var image: UIImage? {
            switch self {
            case .pull: return R.image.detail_cell_pull()
            case .commit: return R.image.detail_cell_commit()
            case .branch: return R.image.detail_cell_branch()
            case .release: return R.image.detail_cell_release()
            case .contributor: return R.image.detail_cell_contributor()
            case .event: return R.image.detail_cell_event()
            case .notification: return R.image.detail_cell_notification()
            case .code: return R.image.detail_cell_code()
            case .star: return R.image.detail_cell_star()
            case .line: return R.image.detail_cell_line()
            }
        }
    }
}
