//
//  CardCollectionViewCell.h
//  AppStoreAnimation
//
//  Created by Chirag Paneliya on 07/06/19.
//  Copyright © 2019 CugnusSoftTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet CardContentView *cardContentView;
@property (nonatomic) BOOL disabledHighlightedAnimation;

-(void)resetTransform;
-(void)freezeAnimations;
-(void)unfreezeAnimations;

@end

NS_ASSUME_NONNULL_END
