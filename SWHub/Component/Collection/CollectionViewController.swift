//
//  CollectionViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/4/29.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import SWFrame

class CollectionViewController: SWFrame.CollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        themeService.rx
            .bind({ $0.primaryColor }, to: self.collectionView.rx.backgroundColor)
            .disposed(by: self.rx.disposeBag)
    }

//    override func setupRefresh(should: Bool) {
//        if should {
//            let animator = RefreshHeaderAnimator.init(frame: .zero)
//            self.scrollView.es.addPullToRefresh(animator: animator) { [weak self] in
//                guard let `self` = self else { return }
//                self.refreshSubject.onNext(())
//            }
//            self.scrollView.refreshIdentifier = "Refresh"
//            self.scrollView.expiredTimeInterval = 30.0
//        } else {
//            self.scrollView.es.removeRefreshHeader()
//        }
//    }
//
//    override func setupLoadMore(should: Bool) {
//        if should {
//            let animator = RefreshFooterAnimator.init(frame: .zero)
//            self.scrollView.es.addInfiniteScrolling(animator: animator) { [weak self] in
//                guard let `self` = self else { return }
//                self.loadMoreSubject.onNext(())
//            }
//        } else {
//            self.scrollView.es.removeRefreshFooter()
//        }
//    }
//
//    override func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        if let message = self.error?.message, !message.isEmpty {
//            return (message + "\n" + R.string.localizable.errorRetry()).styled(with: .alignment(.center), .font(.normal(14)), .color(.lightGray))
//        }
//        return nil
//    }
//
//    override func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
//        return nil
//    }
//
//    override func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
//        return nil
//    }
//
//    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
//        if let _ = self.error {
//            return nil
//        }
//
//        let loadingView = LoadingView()
//        loadingView.sizeToFit()
//        return loadingView
//    }

}
