//
//  Library.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/26.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import Iconic
import RxRealm
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
//        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
//            if oldSchemaVersion < 1 {
//                // 版本1
//            }
//        })
    }

    class func setupIconic() {
        FontAwesomeIcon.register()
    }

    class func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }

}
