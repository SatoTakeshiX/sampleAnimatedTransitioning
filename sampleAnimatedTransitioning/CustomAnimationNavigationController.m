//
//  CustomAnimationNavigationController.m
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/15.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "CustomAnimationNavigationController.h"
#import "TransitionAnimator.h"
@implementation CustomAnimationNavigationController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
}


- (id<UIViewControllerAnimatedTransitioning>)
navigationController:(UINavigationController *)navigationController
animationControllerForOperation:(UINavigationControllerOperation)operation
fromViewController:(UIViewController*)fromVC
toViewController:(UIViewController*)toVC
{
    TransitionAnimator* transitionAnimator = [[TransitionAnimator alloc] init];
    switch (operation) {
        case UINavigationControllerOperationPush:
            return transitionAnimator;
            break;
        case UINavigationControllerOperationPop:
            return transitionAnimator;
            break;
        case UINavigationControllerOperationNone:
        default:
            break;
    }
    return nil;
}


@end
