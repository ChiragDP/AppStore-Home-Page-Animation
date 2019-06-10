//
//  CardContentView.m
//  AppStoreAnimation
//
//  Created by Chirag Paneliya on 06/06/19.
//  Copyright © 2019 CugnusSoftTech. All rights reserved.
//

#import "CardContentView.h"

CGFloat cardHighlightedFactor = 0.96;

@implementation CardContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

-(void)commonSetup
{
    self.imageView.contentMode = UIViewContentModeCenter;
    [self setFontState:false];
}

//Set font size while trasitions
-(void)setFontState:(BOOL)isHighlighted
{
    if (isHighlighted) {
        self.primaryLabel.font = [UIFont systemFontOfSize:(36 * cardHighlightedFactor)];
        self.secondaryLabel.font = [UIFont boldSystemFontOfSize:18 * cardHighlightedFactor];
    } else {
        self.primaryLabel.font = [UIFont systemFontOfSize:36];
        self.secondaryLabel.font = [UIFont boldSystemFontOfSize:18];
    }
}

-(void)setViewModel:(CardContentViewModel *)viewModel
{
    _viewModel = viewModel;
    self.primaryLabel.text = viewModel.primary;
    self.secondaryLabel.text = viewModel.secondary;
    self.detailLabel.text = viewModel.modelDescription;
    self.imageView.image = viewModel.image;
}

@end
