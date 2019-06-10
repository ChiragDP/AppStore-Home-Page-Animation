//
//  CardDetailViewController.m
//  AppStoreAnimation
//
//  Created by Chirag Paneliya on 07/06/19.
//  Copyright © 2019 CugnusSoftTech. All rights reserved.
//

#import "CardDetailViewController.h"
#import "AppStoreAnimation-Swift.h"

@interface CardDetailViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) UIViewPropertyAnimator *dismissalAnimator;
@property (nonatomic, retain) UIPanGestureRecognizer *DismissalPanGesture;
@property (nonatomic, retain) UIScreenEdgePanGestureRecognizer *DismissalScreenEdgePanGesture;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.DismissalPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissalPan:)];
    self.DismissalPanGesture.delegate = self;
    self.DismissalPanGesture.maximumNumberOfTouches = 1;
    
    self.DismissalScreenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissalPan:)];
    self.DismissalScreenEdgePanGesture.delegate = self;
    self.DismissalScreenEdgePanGesture.edges = UIRectEdgeLeft;
    
    [self.DismissalPanGesture requireGestureRecognizerToFail:self.DismissalScreenEdgePanGesture];
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.DismissalScreenEdgePanGesture];
    
    self.scrollView.delegate = self;
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.cardContentView.viewModel = self.cardViewModel;
    [self loadViewIfNeeded];
    
    [self.view addGestureRecognizer:self.DismissalPanGesture];
    [self.view addGestureRecognizer:self.DismissalScreenEdgePanGesture];
}

-(void)handleDismissalPan:(UIPanGestureRecognizer *)gesture
{
    BOOL isScreenEdgePan = [gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
    BOOL canStartDragDownToDismissPan = !isScreenEdgePan && !self.draggingDownToDismiss;
    
    // Don't do anything when it's not in the drag down mode
    if (canStartDragDownToDismissPan) { return; }
    
    UIView *targetAnimatedView = gesture.view;
    CGPoint startingPoint;
    CGPoint p = CGPointZero;
    if (CGPointEqualToPoint(p, self.interactiveStartingPoint)) {
        
        startingPoint = p;
    }
    else {
        // Initial location
        startingPoint = [gesture locationInView:nil];
        self.interactiveStartingPoint = startingPoint;
    }
    
    CGPoint currentLocation = [gesture locationInView:nil];
    CGFloat progress = isScreenEdgePan ? ([gesture translationInView:targetAnimatedView].x / 100) : (currentLocation.y - startingPoint.y) / 100;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            self.dismissalAnimator = [self createInteractiveDismissalAnimatorIfNeededFor:gesture];
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.dismissalAnimator = [self createInteractiveDismissalAnimatorIfNeededFor:gesture];
            
            CGFloat actualProgress = progress;
            BOOL isDismissalSuccess = actualProgress >= 1.0;
            
            self.dismissalAnimator.fractionComplete = actualProgress;
            
            if (isDismissalSuccess) {
                
                [self.dismissalAnimator stopAnimation:false];
                [self.dismissalAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
                    
                    switch (finalPosition) {
                        case UIViewAnimatingPositionEnd:
                            [self didSuccessfullyDragDownToDismiss];
                            break;
                        default:
                            break;
                    }
                }];
                [self.dismissalAnimator finishAnimationAtPosition:UIViewAnimatingPositionEnd];
            }
            break;
        }
        case UIGestureRecognizerStateEnded | UIGestureRecognizerStateCancelled :
        {
            if (self.dismissalAnimator == nil) {
                
                // Gesture's too quick that it doesn't have dismissalAnimator!
                [self didCancelDismissalTransition];
                return;
            }
            
            // NOTE:
            // If user lift fingers -> ended
            // If gesture.isEnabled -> cancelled
            
            // Ended, Animate back to start
            [self.dismissalAnimator pauseAnimation];
            self.dismissalAnimator.reversed = true;
            
            // Disable gesture until reverse closing animation finishes.
            gesture.enabled = false;
            
            [self.dismissalAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
                [self didCancelDismissalTransition];
                gesture.enabled = true;
            }];
            [self.dismissalAnimator startAnimation];
            break;
        }
        default:
            break;
    }
}
-(void)setIsFontStateHighlighted:(BOOL)isFontStateHighlighted
{
    _isFontStateHighlighted = isFontStateHighlighted;
    [self.cardContentView setFontState:_isFontStateHighlighted];
}

-(UIViewPropertyAnimator *)createInteractiveDismissalAnimatorIfNeededFor:(UIPanGestureRecognizer *)gesture
{
    if (self.dismissalAnimator != nil) {
        
        return self.dismissalAnimator;
    }
    else {
        UIView *targetAnimatedView = gesture.view;
        CGPoint startingPoint;
        CGPoint p = CGPointZero;
        if (CGPointEqualToPoint(p, self.interactiveStartingPoint)) {
            
            startingPoint = p;
        }
        else {
            // Initial location
            startingPoint = [gesture locationInView:nil];
            self.interactiveStartingPoint = startingPoint;
        }
        
        CGFloat targetShrinkScale = 0.86;
        CGFloat targetCornerRadius = 16;
        UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 curve:UIViewAnimationCurveLinear animations:^{
            targetAnimatedView.transform = CGAffineTransformMakeScale(targetShrinkScale, targetShrinkScale);
            targetAnimatedView.layer.cornerRadius = targetCornerRadius;
        }];
        return animator;
    }
}

-(void)didSuccessfullyDragDownToDismiss {
    _cardViewModel = _unhighlightedCardViewModel;
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)didCancelDismissalTransition {
    // Clean up
    self.interactiveStartingPoint = CGPointZero;
    self.dismissalAnimator = nil;
    self.draggingDownToDismiss = false;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.draggingDownToDismiss || (scrollView.isTracking && scrollView.contentOffset.y < 0)) {
        self.draggingDownToDismiss = true;
        scrollView.contentOffset = CGPointZero;
    }
    
    scrollView.showsVerticalScrollIndicator = !self.draggingDownToDismiss;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // Without this, when user drag down and lift the finger fast at the top, there'll be some scrolling going on.
    // This check prevents that.
    if (velocity.y > 0 && scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
