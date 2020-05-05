//
// Created by Leigh Williams on 2020-03-31.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation
import UIKit

class TransitionDelegate: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!

        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)

        toView.transform = offScreenRight

        toView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        fromView.layer.anchorPoint = CGPoint(x: 0, y: 0)

        toView.layer.position = CGPoint(x: 0, y: 0)
        fromView.layer.position = CGPoint(x: 0, y: 0)

        container.addSubview(toView)
        container.addSubview(fromView)

        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {

            fromView.transform = offScreenLeft
            toView.transform = CGAffineTransform.identity

        }, completion: { finished in
            transitionContext.completeTransition(true)
        })

    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

}