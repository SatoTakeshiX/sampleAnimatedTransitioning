//
//  ViewController.m
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/15.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "ViewController.h"
#import "TransitionRotateAnimator.h"
@interface ViewController ()<UIViewControllerTransitioningDelegate>
- (IBAction)dismissView:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.transitioningDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    TransitionRotateAnimator *transitonRotateAnimator = [TransitionRotateAnimator new];
    return transitonRotateAnimator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    TransitionRotateAnimator *transitonRotateAnimator = [TransitionRotateAnimator new];
    transitonRotateAnimator.isReverse = YES;
    return transitonRotateAnimator;
}
- (IBAction)dismissView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
