//
//  Library.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import Iconic
import RealmSwift
import IQKeyboardManagerSwift
import SWFrame

class Library: SWFrame.Library {

    override class func setup() {
        super.setup()
        self.setupRealm()
        self.setupIconic()
        self.setupKeyboardManager()
    }

    class func setupRealm() {
        if let defaultURL = Realm.Configuration.defaultConfiguration.fileURL,
            !FileManager.default.fileExists(atPath: defaultURL.path) {
            do {
                try FileManager.default.copyItem(at: R.file.defaultV0Realm()!, to: defaultURL)
            } catch let error {
                log.error("预置数据失败：\(error.localizedDescription)")
            }
        }
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1, migrationBlock: { _, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                // 版本1
            }
            log.info("迁移数据完成")
        })
    }

    class func setupIconic() {
        FontAwesomeIcon.register()
    }

    class func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }

}
