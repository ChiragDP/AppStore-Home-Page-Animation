//
//  CardCollectionViewCell.m
//  AppStoreAnimation
//
//  Created by Chirag Paneliya on 07/06/19.
//  Copyright © 2019 CugnusSoftTech. All rights reserved.
//

#import "CardCollectionViewCell.h"

@implementation CardCollectionViewCell

-(void)resetTransform {
    
    self.transform = CGAffineTransformIdentity;
}

-(void)freezeAnimations {
    
    self.disabledHighlightedAnimation = true;
    [self.layer removeAllAnimations];
}

-(void)unfreezeAnimations {
    self.disabledHighlightedAnimation = false;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.cardContentView.layer.cornerRadius = 16;
    self.cardContentView.layer.masksToBounds = true;
    self.backgroundColor = UIColor.clearColor;
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowRadius = 12;
}

#pragma mark - UIView Events
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self animate:true completion:nil];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self animate:false completion:nil];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self animate:false completion:nil];
}

#pragma mark - Scaling Animation
-(void)animate:(BOOL)isHighlighted completion:(void(^)(BOOL isCompleted))completed
{
    if (self.disabledHighlightedAnimation) {
        return;
    }
    
    if (isHighlighted) {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.transform = CGAffineTransformMakeScale(cardHighlightedFactor, cardHighlightedFactor);
        } completion:^(BOOL finished) {
            if (completed) {
                completed(finished);
            }
        }];
    }
    else {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (completed) {
                completed(finished);
            }
        }];
    }
}

@end
