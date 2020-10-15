//
//  ViewController.swift
//  KidsPromotion
//
//  Created by huangjianwu on 2020/9/4.
//  Copyright © 2020 huangjianwu. All rights reserved.
//

import UIKit
import ZRouter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let vc = TodayViewController()
//        self.present(vc, animated: true, completion: nil)
        Router.perform(
              to: RoutableView<TodayViewInput>(),
              path: .presentModally(from: self),
              configuring: { (config, _) in
                  // Route config
                  // Prepare the destination before transition
                  config.prepareDestination = { [weak self] destination in
                      //destination is inferred as EditorViewInput
//                      destination.delegate = self
//                      destination.constructForCreatingNewNote()
                    
                  }
                  config.successHandler = { destination in
                      // Transition succeed
                  }
                  config.errorHandler = { (action, error) in
                      // Transition failed
                  }
          })
    }
}

