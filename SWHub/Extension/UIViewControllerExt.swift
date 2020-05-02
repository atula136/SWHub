//
//  UIViewControllerExt.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/2.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SWFrame

extension UIViewController {
    
//    struct RuntimeKey {
//        static let automaticallySetModalPresentationStyleKey = UnsafeRawPointer.init(bitPattern: "automaticallySetModalPresentationStyleKey".hashValue)
//    }
//    
//    var automaticallySetModalPresentationStyle: Bool? {
//        get {
//            objc_getAssociatedObject(self, RuntimeKey.automaticallySetModalPresentationStyleKey!) as? Bool
//        }
//        set {
//            objc_setAssociatedObject(self, RuntimeKey.automaticallySetModalPresentationStyleKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//    }
//    
//    @objc func sf_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//        if #available(iOS 13.0, *) {
//            var need = true
//            if let _ = self as? UIImagePickerController {
//                need = false
//            } else if let _ = self as? UIAlertController {
//                need = false
//            }
//            if need {
//                if let auto = self.automaticallySetModalPresentationStyle, auto == false {
//                    need = false
//                }
//            }
//            if need {
//                viewControllerToPresent.modalPresentationStyle = .fullScreen
//            }
//        }
//        self.sf_present(viewControllerToPresent, animated: flag, completion: completion)
//    }
    
//    open override var preferredStatusBarStyle: UIStatusBarStyle {
//        return (self.topViewController?.preferredStatusBarStyle)!
//    }
    
//    @objc var my_preferredStatusBarStyle: UIStatusBarStyle {
//
//    }
    
    @objc func my_viewDidLoad() {
        self.my_viewDidLoad()
        globalStatusBarStyle.mapToVoid().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.setNeedsStatusBarAppearanceUpdate()
        }).disposed(by: self.rx.disposeBag)
    }
    
    @objc var my_preferredStatusBarStyle: UIStatusBarStyle {
        return globalStatusBarStyle.value
    }
    
}
