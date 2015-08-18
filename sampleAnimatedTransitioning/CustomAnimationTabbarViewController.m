//
//  CustomAnimationTabbarViewController.m
//  sampleAnimatedTransitioning
//
//  Created by satoutakeshi on 2015/08/18.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "CustomAnimationTabbarViewController.h"
#import "TransitionRotateAnimator.h"

@interface CustomAnimationTabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation CustomAnimationTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
           animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                             toViewController:(UIViewController *)toVC
{
    //segueでTabBarControllerに遷移してくる場合、初期表示はfromVC無いので分岐する
    if(fromVC){
        
        TransitionRotateAnimator *rotateAnimator = [TransitionRotateAnimator new];
        rotateAnimator.isTabbar = YES;
        return rotateAnimator;
        
        
        /*
         TransitionRotateAnimator *rotateAnimator = [TransitionRotateAnimator new];
         
         // 画面遷移の状態によってアニメーションの向きを変える
         rotateAnimator.isReverse = operation == UINavigationControllerOperationPop;
         
         return rotateAnimator;
         */
        
        
    }else{
        return nil;
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
