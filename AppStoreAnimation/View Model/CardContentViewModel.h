//
//  CardContentViewModel.h
//  AppStoreAnimation
//
//  Created by Chirag Paneliya on 07/06/19.
//  Copyright © 2019 CugnusSoftTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardContentViewModel : NSObject

@property (nonatomic, retain) NSString *primary;
@property (nonatomic, retain) NSString *secondary;
@property (nonatomic, retain) NSString *modelDescription;
@property (nonatomic, retain) UIImage *image;

@end

NS_ASSUME_NONNULL_END
