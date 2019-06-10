//
//  CardTransition.swift
//  AppStoreAnimation
//
//  Created by Chirag Paneliya on 06/06/19.
//  Copyright © 2019 CugnusSoftTech. All rights reserved.
//

import UIKit

@objcMembers
final class CardTransition: NSObject, UIViewControllerTransitioningDelegate {
    public struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromCell: CardCollectionViewCell
    }

    var params: Params?
    
    override init() {
        super.init()
    }
    
    @objc public func initWith(fromCardFrame: CGRect, fromCardFrameWithoutTransform: CGRect, fromCell: CardCollectionViewCell) -> CardTransition {
        
        self.params = CardTransition.Params.init(fromCardFrame: fromCardFrame, fromCardFrameWithoutTransform: fromCardFrameWithoutTransform, fromCell: fromCell)
        
        return self;
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let params = PresentCardAnimator.Params.init(
            fromCardFrame: self.params!.fromCardFrame,
            fromCell: self.params!.fromCell
        )
        return PresentCardAnimator(params: params)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let params = DismissCardAnimator.Params.init(
            fromCardFrame: self.params!.fromCardFrame,
            fromCardFrameWithoutTransform: self.params!.fromCardFrameWithoutTransform,
            fromCell: self.params!.fromCell
        )
        return DismissCardAnimator(params: params)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    // IMPORTANT: Must set modalPresentationStyle to `.custom` for this to be used.
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
