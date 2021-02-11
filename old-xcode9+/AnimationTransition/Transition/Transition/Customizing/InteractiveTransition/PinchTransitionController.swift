//
//  PinchTransitionController.swift
//  Transition
//
//  Created by 천지운 on 2021/02/05.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//

import UIKit

class PinchTransitionController: UIPercentDrivenInteractiveTransition {
    
    var shouldCompleteTransition = true
    
    weak var targetViewController: UIViewController?
    
    var startScale: CGFloat = 0.0
    
    @objc func handleGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        let scale = gestureRecognizer.scale
        
        switch gestureRecognizer.state {
        case .began:
            targetViewController?.dismiss(animated: true, completion: nil)
            startScale = scale
        case .changed:
            var progress = 1.0 - (scale / startScale)
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            cancel()
        case .ended:
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
    
    init(viewController: UIViewController?) {
        super.init()
        
        targetViewController = viewController
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        targetViewController?.view.addGestureRecognizer(gesture)
    }
    
}
