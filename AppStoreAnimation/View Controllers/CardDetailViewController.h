//
//  CardDetailViewController.h
//  AppStoreAnimation
//
//  Created by Chirag Paneliya on 07/06/19.
//  Copyright © 2019 CugnusSoftTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardContentViewModel.h"
#import "CardContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet CardContentView *cardContentView;
@property (nonatomic, retain) CardContentViewModel *cardViewModel;
@property (nonatomic, retain) CardContentViewModel *unhighlightedCardViewModel;
@property (nonatomic) BOOL isFontStateHighlighted;
@property (nonatomic) BOOL draggingDownToDismiss;
@property (nonatomic) CGPoint interactiveStartingPoint;

@end

NS_ASSUME_NONNULL_END
