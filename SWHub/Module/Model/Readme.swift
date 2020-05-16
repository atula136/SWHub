//
//  Repo.Readme.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/16.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import BonMot
import Iconic
import RealmSwift
import ObjectMapper
import SWFrame

class Readme: Object, ModelType, Identifiable {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var size = 0
    @objc dynamic var name: String?
    @objc dynamic var path: String?
    @objc dynamic var sha: String?
    @objc dynamic var type: String?
    @objc dynamic var encoding: String?
    @objc dynamic var content: String?
    @objc dynamic var url: String?
    @objc dynamic var htmlUrl: String?
    @objc dynamic var gitUrl: String?
    @objc dynamic var downloadUrl: String?
    @objc dynamic var links: Links?
    var highlightedCode: NSAttributedString?
    var markdown: String?
    var height: CGFloat?

    required init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id                      <- (map["id"], StringTransform())
        size                    <- map["size"]
        name                    <- map["name"]
        path                    <- map["path"]
        sha                     <- map["sha"]
        type                    <- map["type"]
        encoding                <- map["encoding"]
        content                 <- map["content"]
        url                     <- map["url"]
        htmlUrl                 <- map["html_url"]
        gitUrl                  <- map["git_url"]
        downloadUrl             <- map["download_url"]
        links                   <- map["_links"]
    }

    override static func ignoredProperties() -> [String] {
        return ["highlightedCode", "markdown", "height"]
    }

}
