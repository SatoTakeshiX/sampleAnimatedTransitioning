//
//  TransitionRotateAnimator.h
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/16.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PanInteractionDelegate <NSObject>
- (void)interactionBeganAtPoint:(CGPoint)point;
@end



@interface TransitionRotateAnimator : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign) BOOL isReverse;
@property (nonatomic, assign) BOOL isTabbar;
@property (nonatomic, assign) NSTimeInterval duration;

/*
 PanInteraction
 */
@property (nonatomic, weak) id <PanInteractionDelegate> delegate;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

- (void)updateInteractiveTransitionWithTranslation:(CGPoint)translation;
- (void)finishInteractiveTransitionWithVelocity:(CGPoint)velocity;
- (void)cancelInteractiveTransition;
@end

