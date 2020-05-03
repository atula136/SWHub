//
//  PagingViewController.swift
//  SWHub
//
//  Created by 杨建祥 on 2020/5/3.
//  Copyright © 2020 杨建祥. All rights reserved.
//

import UIKit
import URLNavigator
import SWFrame

class PagingViewController: SWFrame.ScrollViewController {
    
//    public var collectionView: UICollectionView!
//    open var layout: UICollectionViewLayout {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        return layout
//    }
    
    override init(_ navigator: NavigatorType, _ reactor: BaseViewReactor) {
        super.init(navigator, reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(reactor: BaseViewReactor) {
        super.bind(reactor: reactor)
    }
    
}
