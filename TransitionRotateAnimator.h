//
//  TransitionRotateAnimator.h
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/16.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionRotateAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isReverse;
@property (nonatomic, assign) BOOL isTabbar;
@property (nonatomic, assign) NSTimeInterval duration;

@end
