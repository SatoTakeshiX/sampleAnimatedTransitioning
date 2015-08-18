//
//  TransitionAnimator.m
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/15.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "TransitionAnimator.h"

@implementation TransitionAnimator

#pragma mark duration
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
{
    //containerViewに遷移元と遷移先のViewを取得して入れる
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    //フェイド・アウトアニメーション
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromVC.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         fromVC.view.alpha = 1.0;
                         toVC.view.alpha = 1.0;
                         //終了を通知
                         [transitionContext completeTransition:YES];
                     }];
}


@end
