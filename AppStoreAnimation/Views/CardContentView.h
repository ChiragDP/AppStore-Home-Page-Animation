//
//  CardContentView.h
//  AppStoreAnimation
//
//  Created by Chirag Paneliya on 06/06/19.
//  Copyright © 2019 CugnusSoftTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardContentViewModel.h"

NS_ASSUME_NONNULL_BEGIN

extern CGFloat cardHighlightedFactor;

@interface CardContentView : UIView

@property (nonatomic, weak) IBOutlet UILabel *secondaryLabel;
@property (nonatomic, weak) IBOutlet UILabel *primaryLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) CardContentViewModel *viewModel;

-(void)setFontState:(BOOL)isHighlighted;

@end

NS_ASSUME_NONNULL_END
