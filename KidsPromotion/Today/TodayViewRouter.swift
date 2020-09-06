//
//  TodayViewRouter.swift
//  KidsPromotion
//
//  Created by huangjianwu on 2020/9/4.
//  Copyright © 2020 huangjianwu. All rights reserved.
//

import Foundation
import ZIKRouter.Internal
import ZRouter

class TodayViewConfiguration: ZIKViewMakeableConfiguration<NewTodayViewController>, TodayViewModuleInput {

}

class TodayViewRouter: ZIKViewRouter<NewTodayViewController, ZIKViewMakeableConfiguration<NewTodayViewController>> {
    override class func registerRoutableDestination() {
        // Register class with this router. A router can register multi views, and a view can be registered with multi routers
        registerView(NewTodayViewController.self)
        // Register protocol. Then we can fetch this router with the protocol
        register(RoutableView<TodayViewInput>())
        register(RoutableViewModule<TodayViewModuleInput>())
    }
    
    
    override class func defaultRouteConfiguration() -> ZIKViewMakeableConfiguration<NewTodayViewController> {
        return TodayViewConfiguration()
    }
    
//    - (id<LoginViewInput>)destinationWithConfiguration:(ZIKViewRouteConfiguration *)configuration {
//       LoginViewController *destination = [[LoginViewController alloc] init];
//       return destination;
//    }
    
//    override func destination(with configuration: PerformRouteConfig) -> AnyObject? {
//        return NewTodayViewController()
//    }
    override func destination(with configuration: ZIKViewMakeableConfiguration<NewTodayViewController>) -> NewTodayViewController? {
        if let make = configuration.makeDestination {
            return make()
        }
        let destination = NewTodayViewController()
        destination.title = "Swift Sample"
        return destination
    }
//
    
//    override var destination: NewTodayViewController?

}


