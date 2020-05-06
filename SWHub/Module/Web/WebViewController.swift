//
//  WebViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/6.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SWFrame

class WebViewController: SWFrame.WebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeService.rx
            .bind({ $0.foregroundColor }, to: self.progressView.barView.rx.backgroundColor)
            .disposed(by: self.rx.disposeBag)
    }
    
//    override func loadPage() {
//        guard let url = self.url else { return }
//        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
//        let extra = "tiaotiaoapp/" + UIApplication.shared.version! + "/" + UIDevice.current.uuid
//        let agent = self.webView.customUserAgent
//        if !(agent?.contains(extra) ?? false) {
//            self.webView.evaluateJavaScript("navigator.userAgent") { [weak self] response, error in
//                guard let `self` = self else { return }
//                if let result = response as? String, error == nil {
//                    self.webView.customUserAgent = result + " " + extra
//                }
//                self.webView.load(request)
//            }
//        } else {
//            self.webView.load(request)
//        }
//    }
    
}

