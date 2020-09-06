//
//  Viper.swift
//  KidsPromotion
//
//  Created by huangjianwu on 2020/9/4.
//  Copyright © 2020 huangjianwu. All rights reserved.
//

import Foundation
import UIKit

protocol ViperViewEventHandler: class {
    func onViewReady() -> Void
    func onViewRemoved() -> Void
    func onViewWillAppear(_ animated: Bool) -> Void
    func onViewDidAppear(_ animated: Bool) -> Void
    func onViewWillDisappear(_ animated: Bool) -> Void
    func onViewDidDisappear(_ animated: Bool) -> Void
}

extension NSObject: ViperViewEventHandler {
    func onViewReady() {
        
    }
    
    func onViewRemoved() {
        
    }
    
    @objc func onViewWillAppear(_ animated: Bool) {
        
    }
    
    func onViewDidAppear(_ animated: Bool) {
        
    }
    
    func onViewWillDisappear(_ animated: Bool) {
        
    }
    
    func onViewDidDisappear(_ animated: Bool) {
        
    }
}

protocol ViperView: class {
    var routeSource: UIViewController? {get set}
    var eventHandler: ViperViewEventHandler? {get set}
    var viewDataSource: Any? {get set}
}

protocol ViperPresenter: class {
    var view: ViperView? {get set}
}

protocol ViperInteractor: class {
    var dataSource: Any? {get set}
    var eventHandler: Any? {get set}
}


protocol ViperWireframe: class {
    var view: ViperView? {get set}
}

protocol ViperRouter: class {
    
}
