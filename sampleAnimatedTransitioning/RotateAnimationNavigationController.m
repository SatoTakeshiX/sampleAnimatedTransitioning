//
//  RotateAnimationNavigationController.m
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/16.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "RotateAnimationNavigationController.h"
#import "TransitionRotateAnimator.h"

@implementation RotateAnimationNavigationController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    TransitionRotateAnimator *rotateAnimator = [TransitionRotateAnimator new];
    
    //画面を戻る場合はリバースフラグを立てる
    rotateAnimator.isReverse = operation == UINavigationControllerOperationPop;
    
    return rotateAnimator;
}


@end
